import 'package:flutter/widgets.dart';

import '../domain/entities/question.dart';
import '../domain/usecases/register_child.dart';
import '../l10n/gen/app_localizations.dart';

export '../l10n/gen/app_localizations.dart';

/// Ngôn ngữ app theo ngôn ngữ máy: tiếng Việt nếu máy dùng tiếng Việt,
/// còn lại dùng tiếng Anh.
Locale resolveAppLocale(List<Locale>? deviceLocales) {
  for (final l in deviceLocales ?? const <Locale>[]) {
    if (AppLocalizations.supportedLocales.any(
      (s) => s.languageCode == l.languageCode,
    )) {
      return Locale(l.languageCode);
    }
  }
  return const Locale('en');
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension L10nFormat on AppLocalizations {
  /// "1 giờ 5 phút" / "1 h 5 min", "12 phút" / "12 minutes", "40 giây" / "40 seconds"
  String duration(Duration d) {
    if (d.inSeconds < 60) return durationSeconds(d.inSeconds);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return durationMinutes(m);
    return m == 0 ? durationHours(h) : durationHoursMinutes(h, m);
  }

  String questionType(QuestionType t) => switch (t) {
    QuestionType.academic => questionTypeAcademic,
    QuestionType.open => questionTypeOpen,
    QuestionType.social => questionTypeSocial,
  };

  String validation(ValidationError e) => switch (e) {
    ValidationError.nameRequired => validationNameRequired,
    ValidationError.dobRequired => validationDobRequired,
    ValidationError.dobInvalid => validationDobInvalid,
    ValidationError.gradeRequired => validationGradeRequired,
  };
}
