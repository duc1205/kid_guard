import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/app_locator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/image_compressor.dart';
import '../../core/yolo/bundled_yolo_model.dart';
import '../../data/datasources/api_key_store.dart';
import '../../data/datasources/gemini_valuation_datasource.dart';
import '../../domain/entities/valued_item.dart';
import '../result/result_screen.dart';
import '../widgets/common_widgets.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  YOLOViewController _controller = YOLOViewController();

  final String _modelPath = BundledYoloModel.path;

  /// Tránh setState toàn màn → không rebuild YOLOView mỗi frame.
  final ValueNotifier<bool> _busy = ValueNotifier(false);
  final ValueNotifier<List<String>> _hints = ValueNotifier(const []);
  final ValueNotifier<Uint8List?> _frozenFrame = ValueNotifier(null);

  bool _modelReady = false;
  String? _modelError;
  int _viewKey = 0;
  DateTime _lastResultUi = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void dispose() {
    _busy.dispose();
    _hints.dispose();
    _frozenFrame.dispose();
    super.dispose();
  }

  void _onResult(List<YOLOResult> results) {
    if (_busy.value) return;
    final now = DateTime.now();
    if (now.difference(_lastResultUi).inMilliseconds < 400) return;
    _lastResultUi = now;
    final labels = <String>{};
    for (final r in results) {
      if (r.confidence >= 0.4) labels.add(r.className);
    }
    _hints.value = labels.toList(growable: false);
  }

  Future<void> _ensureApiKey() async {
    final existing = await ApiKeyStore.read();
    if (existing != null && existing.isNotEmpty) return;
    if (!mounted) return;

    final controller = TextEditingController();
    final key = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Cấu hình định giá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nhập khóa API để bật tính năng định giá từ ảnh.\n'
              'Lấy key tại Google AI Studio.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'API key',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (key == null || key.isEmpty) {
      throw ValuationException('Cần cấu hình để định giá.');
    }
    await ApiKeyStore.save(key);
  }

  Future<void> _openSettings() async {
    final current = await ApiKeyStore.read() ?? '';
    if (!mounted) return;
    final controller = TextEditingController(
      text: ApiKeyStore.hasDartDefine ? '' : current,
    );
    final key = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cài đặt'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'API key định giá',
            border: const OutlineInputBorder(),
            helperText: ApiKeyStore.hasDartDefine
                ? 'Đang dùng cấu hình từ lúc chạy app.'
                : 'Key lưu trên thiết bị này.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ApiKeyStore.clear();
              if (ctx.mounted) Navigator.pop(ctx, '');
            },
            child: const Text('Xóa'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (key != null && key.isNotEmpty) {
      await ApiKeyStore.save(key);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu cấu hình')),
        );
      }
    }
  }

  Future<void> _unfreezeCamera() async {
    _frozenFrame.value = null;
    try {
      await _controller.resume().timeout(const Duration(seconds: 2));
    } catch (_) {
      try {
        await _controller.restartCamera().timeout(const Duration(seconds: 2));
      } catch (_) {}
    }
    try {
      await _controller.setShowOverlays(true);
    } catch (_) {}
  }

  /// Dừng YOLO không await — `pause()` trên iOS chờ frame kế tiếp, dễ treo UI.
  void _stopYoloInBackground() {
    unawaited(() async {
      try {
        await _controller.setShowOverlays(false);
      } catch (_) {}
      try {
        await _controller.stop().timeout(const Duration(seconds: 1));
      } catch (_) {
        try {
          await _controller.pause().timeout(const Duration(seconds: 1));
        } catch (_) {}
      }
    }());
  }

  Future<Uint8List?> _grabFrame() async {
    // Chụp khi session còn chạy — không pause trước.
    try {
      final photo = await _controller
          .capturePhoto(withOverlays: false)
          .timeout(const Duration(milliseconds: 1800));
      if (photo != null && photo.isNotEmpty) return photo;
    } catch (_) {}
    try {
      return await _controller
          .captureFrame()
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      return null;
    }
  }

  Future<void> _captureAndValue() async {
    if (_busy.value || !_modelReady) return;

    // Overlay full-screen ngay → che box YOLO (hết cảm giác “treo khung”).
    _busy.value = true;
    HapticFeedback.mediumImpact();
    // Cho frame UI vẽ overlay trước khi gọi native capture.
    await WidgetsBinding.instance.endOfFrame;

    final hints = List<String>.from(_hints.value);

    try {
      await _ensureApiKey();

      final bytes = await _grabFrame();
      if (bytes == null || bytes.isEmpty) {
        throw ValuationException('Không chụp được ảnh. Thử lại.');
      }

      _frozenFrame.value = bytes;
      _stopYoloInBackground();

      final compressed = await ImageCompressor.forValuation(bytes);

      final result = await AppLocator.valuation
          .valueFromImage(
            jpegBytes: compressed,
            detectionHints: hints,
          )
          .timeout(
            const Duration(seconds: 40),
            onTimeout: () => throw ValuationException(
              'Phân tích quá lâu. Kiểm tra mạng rồi thử lại.',
            ),
          );

      final entry = ScanHistoryEntry(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        result: result,
      );
      unawaited(AppLocator.history.add(entry));

      if (!mounted) return;
      HapticFeedback.lightImpact();
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(entry: entry),
        ),
      );
    } on ValuationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không định giá được. Thử lại sau.')),
      );
    } finally {
      _busy.value = false;
      if (mounted) {
        await _unfreezeCamera();
      }
    }
  }

  Future<void> _switchCamera() async {
    if (!_modelReady || _busy.value) return;
    HapticFeedback.selectionClick();
    try {
      await _controller.switchCamera();
      _controller.resetTorchState();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không đổi được camera. Thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Camera / YOLO — không rebuild khi busy/hints đổi.
            RepaintBoundary(
              child: YOLOView(
                key: ValueKey('yolo-view-$_viewKey'),
                modelPath: _modelPath,
                task: BundledYoloModel.task,
                controller: _controller,
                confidenceThreshold: 0.4,
                iouThreshold: 0.5,
                useGpu: true,
                onResult: _onResult,
                onModelLoad: (path, task) {
                  if (!mounted) return;
                  setState(() {
                    _modelReady = true;
                    _modelError = null;
                  });
                },
                onModelError: (error, path, task) {
                  if (!mounted) return;
                  setState(() {
                    _modelReady = false;
                    _modelError = 'Không khởi động được camera. Thử lại.';
                  });
                },
              ),
            ),
            // Khung hình đóng băng khi đang phân tích.
            ValueListenableBuilder<Uint8List?>(
              valueListenable: _frozenFrame,
              builder: (context, frame, _) {
                if (frame == null) return const SizedBox.shrink();
                return Positioned.fill(
                  child: Image.memory(
                    frame,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                );
              },
            ),
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x66000000),
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0x99000000),
                    ],
                    stops: [0, 0.22, 0.55, 1],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _busy,
              builder: (context, busy, _) {
                if (busy) return const SizedBox.shrink();
                return const IgnorePointer(child: ViewfinderFrame());
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _busy,
                      builder: (context, busy, _) {
                        if (busy) return const SizedBox(height: 48);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _RoundIcon(
                              icon: Icons.settings_rounded,
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                _openSettings();
                              },
                            ),
                            const SizedBox(width: 6),
                            _RoundIcon(
                              icon: Icons.cameraswitch_rounded,
                              onPressed: _switchCamera,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Material(
                  type: MaterialType.transparency,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _busy,
                    builder: (context, busy, _) {
                      if (busy) return const SizedBox.shrink();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ScanShutterButton(
                            busy: false,
                            enabled: _modelReady,
                            onPressed: _captureAndValue,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chạm để định giá',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            // Full-screen loading — che YOLO box + chặn tương tác khi định giá.
            ValueListenableBuilder<bool>(
              valueListenable: _busy,
              builder: (context, busy, _) {
                if (!busy) return const SizedBox.shrink();
                return const ColoredBox(
                  color: Color(0xCC000000),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.accent,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Đang phân tích giá…',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Vui lòng chờ trong giây lát',
                          style: TextStyle(
                            color: Color(0xC7FFFFFF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (!_modelReady && _modelError == null)
              const ColoredBox(
                color: Color(0xB8000000),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.accent),
                      SizedBox(height: 16),
                      Text(
                        'Đang chuẩn bị camera…',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_modelError != null)
              ColoredBox(
                color: Colors.black.withValues(alpha: 0.82),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.accent,
                          size: 48,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _modelError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: () => setState(() {
                            _modelError = null;
                            _modelReady = false;
                            _controller = YOLOViewController();
                            _viewKey++;
                          }),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.glass,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
