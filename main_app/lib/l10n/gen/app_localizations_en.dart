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
  String get validationGradeRequired => 'Please choose your grade (1 – 12).';

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
  String get authReasonDisableHardLock =>
      'Enter the phone password to turn off hard lock';

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
  String get homeHardLockTitle => 'Hard lock — optional, recommended';

  @override
  String get homeHardLockOn =>
      'On: your child can\'t leave the lock screen in any way.';

  @override
  String get homeHardLockOff =>
      'Fully blocks the Home and Recents buttons and the notification bar while locked. Needs a computer, one-time setup.';

  @override
  String get homeManage => 'Manage';

  @override
  String get homeIosNotice =>
      'When time is up, Screen Time blocks the selected apps. Your child opens KidGuard to answer the question. For even stronger locking, also turn on Guided Access (Settings › Accessibility › Guided Access).';

  @override
  String get homeHeroTitle => '🧒  Lend the phone to your child';

  @override
  String get homeHeroBody =>
      'Your child gets 15 minutes. When time is up, they answer 1 question for their grade: a right answer earns 5 more minutes, a wrong one locks the phone until a parent unlocks it.';

  @override
  String get homeStartKidMode => 'Start kid mode';

  @override
  String get homeGrant => 'Grant';

  @override
  String get hardLockTitle => 'Hard lock';

  @override
  String get hardLockDisableTitle => 'Turn off hard lock?';

  @override
  String get hardLockDisableBody =>
      'KidGuard keeps working normally, but when the phone is locked your child can swipe the navigation bar (it\'s pulled back after ~1 second). You must turn off hard lock before uninstalling KidGuard.';

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
  String get hardLockIntro =>
      'One-time setup, takes about 10 minutes, needs a computer and a USB cable.';

  @override
  String get hardLockStep1Title => 'Turn on Developer options';

  @override
  String hardLockStep1UsbDebugging(String location) {
    return 'Go to $location › turn on \"USB debugging\".';
  }

  @override
  String get hardLockStep2Title => 'Temporarily remove accounts & extra users';

  @override
  String get hardLockStep2Accounts =>
      'Android only allows hard lock when the phone has NO accounts. Go to Settings › Users & accounts (or \"Accounts\") and remove all of them: Google, manufacturer accounts (HeyTap/Oppo, Mi, Samsung…), and app accounts like Zalo, Telegram, WhatsApp if they are listed.';

  @override
  String get hardLockStep2NoDataLoss =>
      'No data is lost. Once step 4 is done you can sign back in right away.';

  @override
  String get hardLockStep3Title => 'Prepare the computer';

  @override
  String get hardLockStep3Mac =>
      'macOS: open Terminal and run the command below (requires Homebrew):';

  @override
  String get hardLockStep3Windows =>
      'Windows: download \"SDK Platform-Tools for Windows\" from developer.android.com/tools/releases/platform-tools, unzip it, open the platform-tools folder, type \"cmd\" in the address bar and press Enter to open a command window.';

  @override
  String get hardLockStep3Plug =>
      'Plug in the USB cable. When the phone shows \"Allow USB debugging?\" › check \"Always allow from this computer\" › Allow. If asked for a USB mode, choose \"File transfer\".';

  @override
  String get hardLockStep3Check =>
      'Check the connection — you should see 1 line ending in \"device\":';

  @override
  String get hardLockStep4Title => 'Turn on hard lock';

  @override
  String get hardLockStep4Run => 'Run the command:';

  @override
  String get hardLockStep4Success =>
      'It worked when you see \"Success: Device owner set to package com.pham.kidguard\". Go back to the app; the status above will turn green.';

  @override
  String get hardLockStep4After =>
      'You can now sign back in to your accounts, turn off \"USB debugging\" and unplug the cable.';

  @override
  String get hardLockTroubleTitle => 'Having trouble?';

  @override
  String get hardLockErrAccountsFix =>
      'There are still accounts on the phone. Redo step 2 and carefully check app accounts too.';

  @override
  String get hardLockErrSecurityFix =>
      'The phone is blocking commands over USB. Check \"USB debugging\" in Developer options again.';

  @override
  String get hardLockErrUnknownAdminFix =>
      'KidGuard isn\'t installed on the phone, or the command was mistyped — use the copy button.';

  @override
  String get hardLockErrNoDevice =>
      'adb devices doesn\'t show the phone / \"unauthorized\"';

  @override
  String get hardLockErrNoDeviceFix =>
      'Unplug and replug the cable, unlock the phone screen and tap \"Allow\" in the USB debugging dialog. Try another cable (some cables only charge).';

  @override
  String get hardLockErrNoAdbFix =>
      'platform-tools isn\'t installed (step 3). On Windows, you must open the command window inside the platform-tools folder.';

  @override
  String get hardLockStatusOn => 'Hard lock is ON';

  @override
  String get hardLockStatusOff => 'Hard lock is off';

  @override
  String get hardLockStatusOnBody =>
      'When the phone is locked, your child can\'t press Home or Recents, pull down the notification bar, or force-stop the app. Only the phone password can unlock it.';

  @override
  String get hardLockStatusOffBody =>
      'Without hard lock, KidGuard still brings the lock screen back when your child leaves it, but they may see another screen for ~1 second and could open Settings to force-stop the app if they\'re quick enough. Hard lock blocks this completely.';

  @override
  String get hardLockCopy => 'Copy';

  @override
  String get hardLockCopied => 'Command copied';

  @override
  String get hardLockDevOppoEnable =>
      'Settings › About device › Version › tap \"Build number\" 7 times in a row and enter the phone password.';

  @override
  String get hardLockDevLocationAdditional =>
      'Settings › Additional settings › Developer options';

  @override
  String get hardLockDevOppoUsers =>
      'Remove \"Second space\", \"App cloner\" and guest users (Settings › Apps › App cloner; Settings › Users & accounts).';

  @override
  String get hardLockDevOppoExtra =>
      'Oppo/Realme only: in Developer options, also turn on \"Disable permission monitoring\". Without it, the command in step 4 will be rejected.';

  @override
  String get hardLockDevXiaomiEnable =>
      'Settings › About phone › tap \"HyperOS/MIUI version\" 7 times in a row.';

  @override
  String get hardLockDevXiaomiUsers =>
      'Remove \"Second space\" and \"Dual apps\" (Settings › Apps › Dual apps).';

  @override
  String get hardLockDevXiaomiExtra =>
      'Xiaomi only: also turn on \"USB debugging (Security settings)\" — this requires a SIM card and a signed-in Mi account; turn it on first, then remove accounts in step 2.';

  @override
  String get hardLockDevVivoEnable =>
      'Settings › System › About › Software information › tap \"Software version\" 7 times in a row.';

  @override
  String get hardLockDevLocationSystem =>
      'Settings › System › Developer options';

  @override
  String get hardLockDevVivoUsers => 'Remove \"App clone\" and guest users.';

  @override
  String get hardLockDevSamsungEnable =>
      'Settings › About phone › Software information › tap \"Build number\" 7 times in a row.';

  @override
  String get hardLockDevSamsungLocation =>
      'Settings › Developer options (at the bottom of the list)';

  @override
  String get hardLockDevSamsungUsers =>
      'Remove \"Secure Folder\" and \"Dual Messenger\" if present.';

  @override
  String get hardLockDevGenericEnable =>
      'Settings › About phone › tap \"Build number\" 7 times in a row.';

  @override
  String get hardLockDevHuaweiLocation =>
      'Settings › System & updates › Developer options';

  @override
  String get hardLockDevHuaweiUsers =>
      'Remove \"PrivateSpace\", \"App Twin\" and guest users.';

  @override
  String get hardLockDevOtherUsers =>
      'Remove guest users, work profiles and cloned apps if any.';

  @override
  String get registerTitle => 'About you';

  @override
  String get registerGreeting => 'Hi there! 👋';

  @override
  String get registerIntro =>
      'Fill in your details to use the phone for 15 minutes.';

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerNameHint => 'Example: Alex Smith';

  @override
  String get registerDobLabel => 'Date of birth';

  @override
  String get registerDobPick => 'Choose your birthday';

  @override
  String get registerGradeLabel => 'What grade are you in?';

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
  String runningGrade(int grade) {
    return 'Grade $grade';
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
  String dashboardChildInfo(int grade, int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age years old',
      one: '1 year old',
    );
    return 'Grade $grade · $_temp0';
  }

  @override
  String reportChildInfo(int grade, String dob) {
    return 'Grade $grade · Born $dob';
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
}
