import 'dart:io';

import 'package:ultralytics_yolo/ultralytics_yolo.dart';

/// Model YOLO đóng gói trong [assets/models] — load local, không download.
abstract final class BundledYoloModel {
  /// ID chính thức; plugin tự lấy file từ assets nếu có.
  static const officialId = 'yolo26n';

  static const androidAsset = 'assets/models/yolo26n_w8a32.tflite';
  static const iosAsset = 'assets/models/yolo26n.mlpackage.zip';

  /// Đường dẫn dùng cho [YOLOView.modelPath].
  static String get path {
    // Dùng asset path tường minh để luôn ưu tiên file trong bundle.
    if (Platform.isIOS || Platform.isMacOS) return iosAsset;
    return androidAsset;
  }

  static YOLOTask get task => YOLOTask.detect;
}
