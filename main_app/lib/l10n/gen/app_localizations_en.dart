// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KidGuard';

  @override
  String durationSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '1 second',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get questionTypeAcademic => 'School subject';

  @override
  String get questionTypeOpen => 'Open question';

  @override
  String get questionTypeSocial => 'General knowledge';

  @override
  String get validationNameRequired => 'Please enter your full name.';

  @override
  String get validationDobRequired => 'Please choose your date of birth.';

  @override
  String get validationDobInvalid => 'Invalid date of birth.';

  @override
  String get validationGradeRequired =>
      'Please choose your grade or level of study.';

  @override
  String get authFailed => 'Wrong password or authentication was cancelled.';

  @override
  String get authNotAvailable =>
      'This phone has no screen lock. Go to Settings and set a PIN/password first.';

  @override
  String get authReasonRevoke =>
      'Enter the phone password to take the phone back and turn off kid mode';

  @override
  String get authReasonParentArea =>
      'Enter the phone password to open the parent area';

  @override
  String get authReasonRegisterChild =>
      'Enter the phone password to add a child\'s profile';

  @override
  String get authReasonDisableHardLock =>
      'Enter the phone password to turn off hard lock';

  @override
  String get consentTitle => 'For parents';

  @override
  String get consentIntro =>
      'KidGuard is a parental screen-time tool. Please confirm before using it on this device.';

  @override
  String get consentBulletParent =>
      'Only a parent or guardian should set up KidGuard.';

  @override
  String get consentBulletLocal =>
      'Profiles and usage history stay on this device. KidGuard does not create online accounts.';

  @override
  String get consentBulletChildData =>
      'A child\'s name, date of birth and grade are stored locally to pick questions and show parent reports.';

  @override
  String get consentBulletNetwork =>
      'The app may download question files over HTTPS. Those requests do not include your child\'s personal details.';

  @override
  String get consentReadPolicy => 'Read privacy policy';

  @override
  String get consentAgree => 'I am a parent/guardian and I agree';

  @override
  String get privacyTitle => 'Privacy policy';

  @override
  String get privacyBody =>
      'KidGuard stores child profiles and screen-time/quiz history only on this device. Parent unlock uses the device passcode or biometrics. Optional lock features (Accessibility on Android, Screen Time on iOS, kiosk on desktop) are used for parental control on this device, not to sell data or read messages. Question updates are downloaded over HTTPS without uploading child data. Full policy (also for store listings):';

  @override
  String get privacyOnlineLabel => 'Public URL';

  @override
  String get privacyCopyUrl => 'Copy policy URL';

  @override
  String get privacyUrlCopied => 'Privacy policy URL copied.';

  @override
  String get homePrivacyPolicy => 'Privacy policy';

  @override
  String get setupBack => 'Tap the Back button (◁) to return to KidGuard.';

  @override
  String get setupOverlayTitle => 'Display over other apps';

  @override
  String get setupOverlayStepOpenPage =>
      'The phone opens KidGuard\'s \"Display over other apps\" page.';

  @override
  String get setupOverlayStepOpenList =>
      'The phone opens a LIST of apps. Scroll down (or use the search box 🔍) to find KidGuard and tap it.';

  @override
  String get setupOverlayStepToggle =>
      'Turn on the \"Allow display over other apps\" switch.';

  @override
  String get setupOverlayNote =>
      'Only turn this on for KidGuard; leave other apps as they are.';

  @override
  String get setupAutoStartOppoTitle => 'Autostart (Oppo / Realme / OnePlus)';

  @override
  String get setupAutoStartOppoStep1 =>
      'The phone opens KidGuard\'s \"App info\" page.';

  @override
  String get setupAutoStartOppoStep2 =>
      'Scroll down and tap \"Battery usage\" (or \"Battery\").';

  @override
  String get setupAutoStartOppoStep3 =>
      'Turn on ALL switches on this page, including: \"Allow background activity\", \"Allow auto launch\" (or \"Auto launch\"), and \"Allow launch by other apps\" if present.';

  @override
  String get setupAutoStartOppoStep4 =>
      'If there is an \"Optimize battery usage\" option, choose \"Don\'t optimize\" / \"Allow\".';

  @override
  String get setupAutoStartOppoNote =>
      'Older phones (ColorOS 11 and earlier): go to Phone Manager › Privacy permissions › Startup manager › turn on KidGuard.';

  @override
  String get setupAutoStartXiaomiTitle => 'Autostart (Xiaomi / Redmi / POCO)';

  @override
  String get setupAutoStartXiaomiStep1 =>
      'The phone opens the \"Autostart\" list.';

  @override
  String get setupFindAndToggle =>
      'Find KidGuard and turn on the switch next to it.';

  @override
  String get setupAutoStartXiaomiNote =>
      'If the phone opens the App info page: turn on \"Autostart\", then go to \"Battery saver\" › choose \"No restrictions\".';

  @override
  String get setupAutoStartVivoTitle => 'Autostart (Vivo / iQOO)';

  @override
  String get setupAutoStartVivoStep1 =>
      'The phone opens the \"Autostart\" / \"Background startup manager\" list.';

  @override
  String get setupAutoStartVivoNote =>
      'If the phone opens the App info page: go to \"Permissions\" › \"Autostart\" and turn it on.';

  @override
  String get setupAutoStartHuaweiTitle => 'App launch (Huawei / Honor)';

  @override
  String get setupAutoStartHuaweiStep1 =>
      'The phone opens the \"App launch\" list.';

  @override
  String get setupAutoStartHuaweiStep2 =>
      'Find KidGuard and turn OFF the \"Manage automatically\" switch.';

  @override
  String get setupAutoStartHuaweiStep3 =>
      'In the dialog that appears, turn on all 3 options \"Auto-launch\", \"Secondary launch\", \"Run in background\" › OK.';

  @override
  String get setupAutoStartTitle => 'Autostart';

  @override
  String get setupAutoStartStep1 =>
      'The phone opens KidGuard\'s App info page.';

  @override
  String get setupAutoStartStep2 =>
      'Go to \"Battery\" › choose \"Unrestricted\".';

  @override
  String get setupPopupXiaomiTitle => 'Background pop-ups (Xiaomi)';

  @override
  String get setupPopupXiaomiStep1 =>
      'The phone opens KidGuard\'s \"Other permissions\" page.';

  @override
  String get setupPopupXiaomiStep2 =>
      'Tap \"Display pop-up windows while running in the background\" › choose \"Always allow\".';

  @override
  String get setupPopupXiaomiStep3 =>
      'Tap \"Display pop-up windows\" › choose \"Always allow\".';

  @override
  String get setupPopupXiaomiNote =>
      'If the phone opens the App info page: go to \"App permissions\" › \"Other permissions\".';

  @override
  String get setupPopupVivoTitle => 'Background pop-ups (Vivo)';

  @override
  String get setupPopupVivoStep1 =>
      'The phone opens KidGuard\'s permissions page.';

  @override
  String get setupPopupVivoStep2 =>
      'Turn on \"Display pop-up windows while running in the background\" (some phones call it \"Start apps from background\").';

  @override
  String get setupPopupVivoNote =>
      'If the phone opens the App info page: go to \"Permissions\" › \"Other permissions\".';

  @override
  String get setupRecentsTitle => 'Lock KidGuard in Recents';

  @override
  String get setupRecentsStepOpen =>
      'Open Recents: swipe up from the bottom edge and hold (or tap the ▢ button).';

  @override
  String get setupRecentsStepOppo =>
      'On the KidGuard card, tap the ⋮ button at the top (or swipe the card down) › choose \"Lock\".';

  @override
  String get setupRecentsStepXiaomi =>
      'Long-press the KidGuard card › tap the lock icon 🔒.';

  @override
  String get setupRecentsStepVivo =>
      'Swipe the KidGuard card down (or long-press it) › choose \"Lock\" 🔒.';

  @override
  String get setupRecentsStepHuawei =>
      'Swipe the KidGuard card down › tap the lock icon 🔒.';

  @override
  String get setupRecentsStepSamsung =>
      'Tap the KidGuard icon above the card › choose \"Keep open\".';

  @override
  String get setupRecentsStepOther =>
      'Long-press the KidGuard card; if there is a \"Lock\" / \"Pin\" option, choose it.';

  @override
  String get setupRecentsStepDone =>
      'Once the KidGuard card shows a lock icon, you\'re done. Go back to KidGuard.';

  @override
  String get setupRecentsNote =>
      'Once locked, your child can\'t close KidGuard even by tapping \"Clear all\".';

  @override
  String get setupConfirmQuestion =>
      'Have you finished this step for KidGuard?';

  @override
  String get setupConfirmAgain => 'Not yet, try again';

  @override
  String get setupConfirmDone => 'Done';

  @override
  String get setupReadStepsFirst =>
      'Read the steps first, then tap \"Open settings\":';

  @override
  String get setupFollowSteps => 'Follow these steps:';

  @override
  String get setupOpenSettings => 'Open settings';

  @override
  String get setupGotIt => 'Got it';

  @override
  String get homeParentArea => 'Parent area';

  @override
  String get homeParentAreaSubtitle =>
      'See screen time and right/wrong answers for each child';

  @override
  String get homeSetupHeader => 'Setup on this phone';

  @override
  String get homeScreenLockTitle => 'Screen lock password';

  @override
  String get homeScreenLockSubtitle =>
      'Required — lets adults take the phone back and unlock it.';

  @override
  String get homeOverlaySubtitle =>
      'So the question screen pops up when time is up, even if your child is in another app.';

  @override
  String get homePopupTitle =>
      'Display pop-up windows while running in background';

  @override
  String get homeConfirmedOn => 'You confirmed this is on.';

  @override
  String homePopupSubtitle(String brand) {
    return 'A $brand-specific permission. Without it, the question screen won\'t pop up when time is up.';
  }

  @override
  String get homeReview => 'Review';

  @override
  String get homeGuide => 'Guide';

  @override
  String get homeNotificationsTitle => 'Notifications';

  @override
  String get homeNotificationsSubtitle =>
      'Shows the countdown timer in the notification bar.';

  @override
  String get homeBatteryTitle => 'Unrestricted battery';

  @override
  String get homeBatterySubtitle =>
      'So the system doesn\'t stop the timer while your child uses other apps.';

  @override
  String get homeAutoStartSubtitle =>
      'So lock mode keeps working when your child clears Recents or restarts the phone.';

  @override
  String get homeConfirmedLocked => 'You confirmed it is locked.';

  @override
  String get homeRecentsSubtitle =>
      'So the \"Clear all\" button can\'t close KidGuard.';

  @override
  String get homeManage => 'Manage';

  @override
  String get homeIosNotice =>
      'When time is up, Screen Time blocks the selected apps. Your child opens KidGuard to answer the question. For even stronger locking, also turn on Guided Access (Settings › Accessibility › Guided Access).';

  @override
  String get homeHeroTitle => '🧒  Lend the phone to your child';

  @override
  String homeHeroBody(String duration) {
    return 'Your child gets $duration. When time is up, they answer 1 question for their grade: a right answer earns 5 more minutes, a wrong one locks the phone until a parent unlocks it.';
  }

  @override
  String get homeStartKidMode => 'Start kid mode';

  @override
  String get homeGrant => 'Grant';

  @override
  String get hardLockDisableTitle => 'Turn off hard lock?';

  @override
  String get hardLockDisableBody =>
      'KidGuard keeps working (with Advanced lock if it\'s on). You must turn this off before uninstalling KidGuard.';

  @override
  String get hardLockCancel => 'Cancel';

  @override
  String get hardLockTurnOff => 'Turn off';

  @override
  String get hardLockDisabledOk =>
      'Hard lock is off. You can now uninstall KidGuard like a normal app.';

  @override
  String get hardLockDisableFailed => 'Couldn\'t turn off hard lock.';

  @override
  String get hardLockDisableButton =>
      'Turn off hard lock (requires phone password)';

  @override
  String get registerTitle => 'About you';

  @override
  String get registerGreeting => 'Hi there! 👋';

  @override
  String registerIntro(String duration) {
    return 'Fill in your details to use the phone for $duration.';
  }

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerNameHint => 'Example: Alex Smith';

  @override
  String get registerDobLabel => 'Date of birth';

  @override
  String get registerDobPick => 'Choose your birthday';

  @override
  String get registerGradeLabel => 'What grade or level are you studying?';

  @override
  String registerGradeChip(int grade) {
    return 'Grade $grade';
  }

  @override
  String get registerLevelPrimary => 'Primary';

  @override
  String get registerLevelLowerSecondary => 'Middle';

  @override
  String get registerLevelUpperSecondary => 'High';

  @override
  String get registerHigherEducation => 'Higher education';

  @override
  String get gradeUniversity => 'University';

  @override
  String get gradeUniversityHint => 'College, university';

  @override
  String get gradePostgraduate => 'Postgraduate';

  @override
  String get gradePostgraduateHint => 'Master\'s, PhD';

  @override
  String get registerNeedsScreenLock =>
      'This phone has no screen lock. A parent needs to set a password first so they can take the phone back.';

  @override
  String registerErrorGeneric(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String get registerStart => 'Start using the phone';

  @override
  String runningGreeting(String name) {
    return 'Hi $name!';
  }

  @override
  String runningGrade(String grade) {
    return '$grade';
  }

  @override
  String get runningTimeLeft => 'Time left';

  @override
  String get runningRules =>
      'When time is up, you\'ll answer 1 question.\nGet it right for 5 more minutes. Get it wrong and the phone will lock.';

  @override
  String get runningUseOtherApps => 'Use other apps';

  @override
  String get quizCorrect => '🎉 Correct! You get 5 more minutes.';

  @override
  String get quizTimeUp => 'Time\'s up!';

  @override
  String get quizInstruction => 'Answer correctly to get 5 more minutes.';

  @override
  String get quizSubmit => 'Answer';

  @override
  String get reviewWrong => 'Not quite right!';

  @override
  String get reviewYourChoice => 'You chose';

  @override
  String get reviewCorrectAnswer => 'Correct answer';

  @override
  String get reviewSuggestionTitle => 'What to review';

  @override
  String get reviewLockNotice =>
      'When you tap OK, the phone will lock. Please give the phone to your parents.';

  @override
  String get commonOk => 'OK';

  @override
  String get lockedTitle => 'Phone locked';

  @override
  String lockedMessage(String name) {
    return 'Hey $name, please give the phone to your parents.\nRemember to review what was suggested!';
  }

  @override
  String get lockedUnlockButton => 'Adult: unlock & take back phone';

  @override
  String get revokeButton => 'Adult: take back phone';

  @override
  String get dashboardTitle => 'Parent area';

  @override
  String get dashboardEmpty => 'No child has used this phone yet.';

  @override
  String get dashboardTotalTime => 'Total time';

  @override
  String get dashboardCorrect => 'Correct';

  @override
  String get dashboardWrong => 'Wrong';

  @override
  String get dashboardChildren => 'Children';

  @override
  String dashboardChildInfo(String grade, int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age years old',
      one: '1 year old',
    );
    return '$grade · $_temp0';
  }

  @override
  String reportChildInfo(String grade, String dob) {
    return '$grade · Born $dob';
  }

  @override
  String get reportTimeUsed => 'Time used';

  @override
  String get reportCorrect => 'Correct';

  @override
  String get reportWrong => 'Wrong';

  @override
  String get reportWeakTopicsTitle => 'Topics to review';

  @override
  String reportWrongTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wrong $count times',
      one: 'wrong once',
    );
    return '$_temp0';
  }

  @override
  String reportHistoryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return 'Usage history ($_temp0)';
  }

  @override
  String get reportNoSessions => 'No sessions yet.';

  @override
  String get reportLoadMore => 'Load more';

  @override
  String reportLogRetention(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Logs are kept for up to $_temp0.';
  }

  @override
  String get reportStatusActive => 'In progress';

  @override
  String get reportStatusLocked => 'Locked after a wrong answer';

  @override
  String get reportStatusRevoked => 'Taken back by an adult';

  @override
  String reportSessionSummary(
    String duration,
    int count,
    int correct,
    int wrong,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return 'Used $duration · $_temp0 (✅ $correct  ❌ $wrong)';
  }

  @override
  String reportEndedAt(String time) {
    return 'Ended: $time';
  }

  @override
  String get reportNoAttempts => 'No questions answered yet.';

  @override
  String reportAttemptTitle(int number, String subject, String topic) {
    return 'Question $number · $subject — $topic';
  }

  @override
  String reportChosenAnswer(String letter, String option) {
    return 'Child chose: $letter. $option';
  }

  @override
  String reportCorrectAnswer(String letter, String option) {
    return 'Correct answer: $letter. $option';
  }

  @override
  String quizLoadError(String error) {
    return 'Could not load the question: $error';
  }

  @override
  String get homeScreenTimeTitle => 'Screen Time permission';

  @override
  String get homeScreenTimeSubtitle =>
      'Lets KidGuard block the apps you choose when time is up. Confirm with Face ID or the phone passcode.';

  @override
  String get homeLimitedAppsTitle => 'Apps blocked when time is up';

  @override
  String get homeLimitedAppsSubtitle =>
      'Choose the apps or app categories (e.g. Games, Social, Entertainment). Do not select KidGuard.';

  @override
  String get homeLimitedAppsOn =>
      'Selected. You can change the list at any time.';

  @override
  String get homeLimitedAppsChoose => 'Choose';

  @override
  String get homeLimitedAppsChange => 'Change';

  @override
  String get homeScreenTimeFirst => 'Grant the Screen Time permission first.';

  @override
  String get homeDesktopTitle => 'How locking works on this computer';

  @override
  String get homeMacNotice =>
      'When time is up, KidGuard comes to the front in full-screen kiosk mode: the Dock, menu bar, Cmd+Tab and Force Quit are disabled until the question is answered or a parent unlocks with the Mac password or Touch ID. During a session KidGuard can\'t be quit and reopens automatically after login.';

  @override
  String get homeWindowsNotice =>
      'When time is up, KidGuard covers the whole screen and stays on top: the Windows key, Alt+Tab and Alt+F4 are blocked until the question is answered or a parent unlocks with Windows Hello (PIN, fingerprint or face). During a session KidGuard can\'t be closed and reopens automatically after sign-in. Windows does not allow apps to block Ctrl+Alt+Del.';

  @override
  String get homeWindowsHelloHint =>
      'Windows Hello must be set up (Settings › Accounts › Sign-in options › PIN).';

  @override
  String get runningIosHint =>
      'Swipe up (or press the Home button) to use other apps.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get dashboardQuestionSource => 'Question source';

  @override
  String get qsTitle => 'Question source';

  @override
  String get qsSource => 'Source';

  @override
  String get qsDefaultSource => 'Default (KidGuard)';

  @override
  String get qsCustomSource => 'Custom';

  @override
  String get qsVersion => 'Question bank version';

  @override
  String get qsDownloaded => 'Grades using downloaded questions';

  @override
  String get qsBundledOnly => 'Using the questions built into the app';

  @override
  String get qsLastSync => 'Last checked';

  @override
  String get qsNever => 'Never';

  @override
  String get qsSyncNow => 'Update now';

  @override
  String get qsChangeSource => 'Change question source';

  @override
  String get qsChangeTitle => 'manifest.json address';

  @override
  String get qsUseDefault => 'Use default source';

  @override
  String get qsSave => 'Save and download';

  @override
  String get qsHelp =>
      'Questions are downloaded over the internet and stored on this device, so they still work offline. Every file is checked for format and checksum; if anything is wrong, the app keeps the questions it already has. A custom source (for example your school\'s) needs a manifest.json and grade_N.json files in the same format: grades 1–12, 13 = University, 14 = Postgraduate.';

  @override
  String get qsCustomSourceWarningTitle => 'Use only a trusted source';

  @override
  String get qsCustomSourceWarningBody =>
      'KidGuard will download and show questions from this HTTPS address. Use only a source you trust (for example your school). A malicious source could show inappropriate or wrong content to your child.';

  @override
  String get qsCustomSourceConfirm => 'I trust this source';

  @override
  String get homeAndroidNotice =>
      'When time is up, KidGuard comes to the front (overlay) and shows a question. For a stronger lock—blocking the notification shade, Recents and turning KidGuard off—turn on Advanced lock (Accessibility) below. Emergency and incoming calls still work.';

  @override
  String qsResultUpdated(int version) {
    return 'Question bank updated to version $version.';
  }

  @override
  String get qsResultUpToDate => 'The question bank is already up to date.';

  @override
  String get qsErrorNetwork =>
      'Couldn\'t download questions (check the connection or address). The app keeps using the questions already on this device.';

  @override
  String get qsErrorManifest =>
      'manifest.json is not in the right format. The app keeps using the questions already on this device.';

  @override
  String get qsErrorQuestions =>
      'A question file is not in the right format. The app keeps using the questions already on this device.';

  @override
  String get qsErrorChecksum =>
      'A question file doesn\'t match the checksum in the manifest. The app keeps using the questions already on this device.';

  @override
  String get qsInvalidUrl => 'This address is not valid.';

  @override
  String get qsInsecureUrl =>
      'Only addresses starting with https:// are allowed.';

  @override
  String get registerPickTitle => 'Who\'s using the phone?';

  @override
  String registerPickIntro(String duration) {
    return 'Tap your name to use the phone for $duration.';
  }

  @override
  String get registerAddNew => 'I\'m not on the list';

  @override
  String get registerBackToList => 'Pick a saved name';

  @override
  String get registerSavedHint =>
      'Wrong details or a new school year? Ask a parent to update them in the parent area.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsInitialAllowance => 'Starting screen time';

  @override
  String settingsInitialAllowanceDefault(String duration) {
    return '$duration (default)';
  }

  @override
  String get settingsInitialAllowanceHint =>
      'How long your child can use the phone each time before the first question. Applies from the next session.';

  @override
  String get settingsMinutesLabel => 'Minutes';

  @override
  String settingsMinutesMin(int min) {
    return 'At least $min minutes.';
  }

  @override
  String get settingsMinutesInvalid => 'Enter a whole number of minutes.';

  @override
  String settingsResetDefault(String duration) {
    return 'Use default ($duration)';
  }

  @override
  String get settingsSave => 'Save';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get childEditTooltip => 'Edit details';

  @override
  String get childEditTitle => 'Edit child details';

  @override
  String get childEditGradeLabel => 'Grade / level';

  @override
  String get childEditNote =>
      'Update the grade at the start of each school year so questions match your child\'s level. Past history is kept.';

  @override
  String childEditSaved(String name) {
    return 'Saved $name\'s details.';
  }

  @override
  String get homeAdvancedLockTitle =>
      'Advanced lock (Accessibility) — recommended';

  @override
  String get homeAdvancedLockOn =>
      'On: when time is up your child can\'t pull down notifications or open recents or other apps.';

  @override
  String get homeAdvancedLockOff =>
      'Turn on in Settings › Accessibility right on this phone, no computer needed. Blocks the notification shade, recents and turning KidGuard off.';

  @override
  String get advancedLockTitle => 'Advanced lock';

  @override
  String get advancedLockStatusOn => 'Advanced lock is ON';

  @override
  String get advancedLockStatusOff => 'Advanced lock is off';

  @override
  String get advancedLockStatusOnBody =>
      'When time is up or the phone is locked, KidGuard keeps the quiz on screen and your child can\'t turn KidGuard off during a session.';

  @override
  String get advancedLockStatusOffBody =>
      'KidGuard still covers the screen when time is up, but your child can pull down the notification shade and could turn KidGuard off from Settings during their free time.';

  @override
  String get advancedLockWhatTitle => 'What it does';

  @override
  String get advancedLockWhat1 =>
      'When time is up or the phone is locked: closes the notification shade and blocks recents, the home screen and split screen, bringing the quiz back instantly.';

  @override
  String get advancedLockWhat2 =>
      'During your child\'s whole session: blocks Settings and uninstallers so your child cannot turn KidGuard off (including Accessibility).';

  @override
  String get advancedLockWhat3 => 'Incoming and emergency calls still work.';

  @override
  String get advancedLockPrivacy =>
      'KidGuard only uses Accessibility to know which app package is on top. It does not read, store or send what\'s on your screen.';

  @override
  String get advancedLockStepsTitle => 'How to turn it on (about 1 minute)';

  @override
  String get advancedLockStepRestricted =>
      'Android 13 and later, if KidGuard wasn\'t installed from Google Play: open KidGuard\'s App info › tap ⋮ (top right) › \"Allow restricted settings\" › enter the phone\'s password. If you don\'t see it, skip this step.';

  @override
  String get advancedLockOpenAppInfo => 'Open App info';

  @override
  String get advancedLockStepEnable =>
      'Tap the button below › choose KidGuard (usually under \"Downloaded apps\" or \"Installed apps\") › turn it on › Allow.';

  @override
  String get advancedLockOpenSettings => 'Open Accessibility settings';

  @override
  String get advancedLockStepBack =>
      'Come back to KidGuard: the status above turns ON.';

  @override
  String get advancedLockOffNote =>
      'To turn it off: end your child\'s session first (parent unlock), then go to Settings › Accessibility › KidGuard › off.';

  @override
  String get legacyHardLockTitle => 'Old hard lock (Device Owner) is on';

  @override
  String get legacyHardLockBody =>
      'This phone had hard lock turned on with a computer in an earlier version. Turn it off before uninstalling KidGuard.';
}
