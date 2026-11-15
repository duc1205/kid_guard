import '../../../domain/repositories/repositories.dart';
import '../../l10n_ext.dart';

/// Nội dung hướng dẫn từng bước cho các mục thiết lập theo từng hãng.
/// Câu chữ bám theo tên mục tiếng Việt trên máy; có thể khác chút giữa các phiên bản.
class SetupGuide {
  const SetupGuide({required this.title, required this.steps, this.note});

  final String title;
  final List<String> steps;
  final String? note;
}

SetupGuide overlayGuide(AppLocalizations l10n, OemFamily oem) => SetupGuide(
  title: l10n.setupOverlayTitle,
  steps: [
    if (oem == OemFamily.samsung || oem == OemFamily.other)
      l10n.setupOverlayStepOpenPage
    else
      l10n.setupOverlayStepOpenList,
    l10n.setupOverlayStepToggle,
    l10n.setupBack,
  ],
  note: l10n.setupOverlayNote,
);

SetupGuide autoStartGuide(AppLocalizations l10n, OemFamily oem) =>
    switch (oem) {
      OemFamily.oppo => SetupGuide(
        title: l10n.setupAutoStartOppoTitle,
        steps: [
          l10n.setupAutoStartOppoStep1,
          l10n.setupAutoStartOppoStep2,
          l10n.setupAutoStartOppoStep3,
          l10n.setupAutoStartOppoStep4,
          l10n.setupBack,
        ],
        note: l10n.setupAutoStartOppoNote,
      ),
      OemFamily.xiaomi => SetupGuide(
        title: l10n.setupAutoStartXiaomiTitle,
        steps: [
          l10n.setupAutoStartXiaomiStep1,
          l10n.setupFindAndToggle,
          l10n.setupBack,
        ],
        note: l10n.setupAutoStartXiaomiNote,
      ),
      OemFamily.vivo => SetupGuide(
        title: l10n.setupAutoStartVivoTitle,
        steps: [
          l10n.setupAutoStartVivoStep1,
          l10n.setupFindAndToggle,
          l10n.setupBack,
        ],
        note: l10n.setupAutoStartVivoNote,
      ),
      OemFamily.huawei => SetupGuide(
        title: l10n.setupAutoStartHuaweiTitle,
        steps: [
          l10n.setupAutoStartHuaweiStep1,
          l10n.setupAutoStartHuaweiStep2,
          l10n.setupAutoStartHuaweiStep3,
          l10n.setupBack,
        ],
      ),
      _ => SetupGuide(
        title: l10n.setupAutoStartTitle,
        steps: [
          l10n.setupAutoStartStep1,
          l10n.setupAutoStartStep2,
          l10n.setupBack,
        ],
      ),
    };

SetupGuide backgroundPopupGuide(AppLocalizations l10n, OemFamily oem) =>
    switch (oem) {
      OemFamily.xiaomi => SetupGuide(
        title: l10n.setupPopupXiaomiTitle,
        steps: [
          l10n.setupPopupXiaomiStep1,
          l10n.setupPopupXiaomiStep2,
          l10n.setupPopupXiaomiStep3,
          l10n.setupBack,
        ],
        note: l10n.setupPopupXiaomiNote,
      ),
      _ => SetupGuide(
        title: l10n.setupPopupVivoTitle,
        steps: [
          l10n.setupPopupVivoStep1,
          l10n.setupPopupVivoStep2,
          l10n.setupBack,
        ],
        note: l10n.setupPopupVivoNote,
      ),
    };

SetupGuide recentsLockGuide(AppLocalizations l10n, OemFamily oem) => SetupGuide(
  title: l10n.setupRecentsTitle,
  steps: [
    l10n.setupRecentsStepOpen,
    switch (oem) {
      OemFamily.oppo => l10n.setupRecentsStepOppo,
      OemFamily.xiaomi => l10n.setupRecentsStepXiaomi,
      OemFamily.vivo => l10n.setupRecentsStepVivo,
      OemFamily.huawei => l10n.setupRecentsStepHuawei,
      OemFamily.samsung => l10n.setupRecentsStepSamsung,
      OemFamily.other => l10n.setupRecentsStepOther,
    },
    l10n.setupRecentsStepDone,
  ],
  note: l10n.setupRecentsNote,
);

SetupGuide batteryGuide(AppLocalizations l10n, OemFamily oem) => switch (oem) {
  OemFamily.oppo => SetupGuide(
    title: l10n.setupBatteryTitle,
    steps: [
      l10n.setupBatteryOppoStep1,
      l10n.setupBatteryOppoStep2,
      l10n.setupBatteryOppoStep3,
      l10n.setupBatteryStepToggle,
      l10n.setupBack,
    ],
    note: l10n.setupBatteryOppoNote,
  ),
  OemFamily.xiaomi => SetupGuide(
    title: l10n.setupBatteryTitle,
    steps: [
      l10n.setupBatteryStepOpen,
      l10n.setupBatteryStepFind,
      l10n.setupBatteryXiaomiStep,
      l10n.setupBack,
    ],
  ),
  _ => SetupGuide(
    title: l10n.setupBatteryTitle,
    steps: [
      l10n.setupBatteryStepOpen,
      l10n.setupBatteryStepFind,
      l10n.setupBatteryStepToggle,
      l10n.setupBack,
    ],
    note: l10n.setupBatteryNote,
  ),
};
