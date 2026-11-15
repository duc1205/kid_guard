import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KidGuard'**
  String get appTitle;

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 second} other{{count} seconds}}'**
  String durationSeconds(int count);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String durationMinutes(int count);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String durationHours(int count);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @questionTypeAcademic.
  ///
  /// In en, this message translates to:
  /// **'School subject'**
  String get questionTypeAcademic;

  /// No description provided for @questionTypeOpen.
  ///
  /// In en, this message translates to:
  /// **'Open question'**
  String get questionTypeOpen;

  /// No description provided for @questionTypeSocial.
  ///
  /// In en, this message translates to:
  /// **'General knowledge'**
  String get questionTypeSocial;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name.'**
  String get validationNameRequired;

  /// No description provided for @validationDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose your date of birth.'**
  String get validationDobRequired;

  /// No description provided for @validationDobInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid date of birth.'**
  String get validationDobInvalid;

  /// No description provided for @validationGradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose your grade or level of study.'**
  String get validationGradeRequired;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Wrong password or authentication was cancelled.'**
  String get authFailed;

  /// No description provided for @authNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This phone has no screen lock. Go to Settings and set a PIN/password first.'**
  String get authNotAvailable;

  /// No description provided for @authReasonRevoke.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to take the phone back and turn off kid mode'**
  String get authReasonRevoke;

  /// No description provided for @authReasonParentArea.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to open the parent area'**
  String get authReasonParentArea;

  /// No description provided for @authReasonRegisterChild.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to add a child\'s profile'**
  String get authReasonRegisterChild;

  /// No description provided for @authReasonDisableHardLock.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to turn off hard lock'**
  String get authReasonDisableHardLock;

  /// No description provided for @authReasonDeleteChild.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to delete this child\'s data'**
  String get authReasonDeleteChild;

  /// No description provided for @authReasonClearAllData.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to delete all child data on this device'**
  String get authReasonClearAllData;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'For parents'**
  String get consentTitle;

  /// No description provided for @consentIntro.
  ///
  /// In en, this message translates to:
  /// **'KidGuard is a parental screen-time tool. Please confirm before using it on this device.'**
  String get consentIntro;

  /// No description provided for @consentBulletParent.
  ///
  /// In en, this message translates to:
  /// **'Only a parent or guardian should set up KidGuard.'**
  String get consentBulletParent;

  /// No description provided for @consentBulletLocal.
  ///
  /// In en, this message translates to:
  /// **'Profiles and usage history stay on this device. KidGuard does not create online accounts.'**
  String get consentBulletLocal;

  /// No description provided for @consentBulletChildData.
  ///
  /// In en, this message translates to:
  /// **'A child\'s name, date of birth and grade are stored locally to pick questions and show parent reports.'**
  String get consentBulletChildData;

  /// No description provided for @consentBulletNetwork.
  ///
  /// In en, this message translates to:
  /// **'The app may download question files over HTTPS. Those requests do not include your child\'s personal details.'**
  String get consentBulletNetwork;

  /// No description provided for @consentReadPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read privacy policy'**
  String get consentReadPolicy;

  /// No description provided for @consentAgree.
  ///
  /// In en, this message translates to:
  /// **'I am a parent/guardian and I agree'**
  String get consentAgree;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'KidGuard stores child profiles and screen-time/quiz history only on this device. Parents can delete one child or all child data in the Parent area after device passcode or biometrics; question files and parental-control settings stay. Parent unlock uses the device passcode or biometrics. Optional lock features (Accessibility on Android, Screen Time on iOS, kiosk on desktop) are used for parental control on this device, not to sell data or read messages. Question updates are downloaded over HTTPS without uploading child data. Full policy (also for store listings):'**
  String get privacyBody;

  /// No description provided for @privacyOnlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Public URL'**
  String get privacyOnlineLabel;

  /// No description provided for @privacyCopyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy policy URL'**
  String get privacyCopyUrl;

  /// No description provided for @privacyUrlCopied.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy URL copied.'**
  String get privacyUrlCopied;

  /// No description provided for @homePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get homePrivacyPolicy;

  /// No description provided for @setupBack.
  ///
  /// In en, this message translates to:
  /// **'Tap the Back button (◁) to return to KidGuard.'**
  String get setupBack;

  /// No description provided for @setupOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Display over other apps'**
  String get setupOverlayTitle;

  /// No description provided for @setupOverlayStepOpenPage.
  ///
  /// In en, this message translates to:
  /// **'The phone opens KidGuard\'s \"Display over other apps\" page.'**
  String get setupOverlayStepOpenPage;

  /// No description provided for @setupOverlayStepOpenList.
  ///
  /// In en, this message translates to:
  /// **'The phone opens a LIST of apps. Scroll down (or use the search box 🔍) to find KidGuard and tap it.'**
  String get setupOverlayStepOpenList;

  /// No description provided for @setupOverlayStepToggle.
  ///
  /// In en, this message translates to:
  /// **'Turn on the \"Allow display over other apps\" switch.'**
  String get setupOverlayStepToggle;

  /// No description provided for @setupOverlayNote.
  ///
  /// In en, this message translates to:
  /// **'Only turn this on for KidGuard; leave other apps as they are.'**
  String get setupOverlayNote;

  /// No description provided for @setupAutoStartOppoTitle.
  ///
  /// In en, this message translates to:
  /// **'Autostart (Oppo / Realme / OnePlus)'**
  String get setupAutoStartOppoTitle;

  /// No description provided for @setupAutoStartOppoStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens KidGuard\'s \"App info\" page.'**
  String get setupAutoStartOppoStep1;

  /// No description provided for @setupAutoStartOppoStep2.
  ///
  /// In en, this message translates to:
  /// **'Scroll down and tap \"Battery usage\" (or \"Battery\").'**
  String get setupAutoStartOppoStep2;

  /// No description provided for @setupAutoStartOppoStep3.
  ///
  /// In en, this message translates to:
  /// **'Turn on ALL switches on this page, including: \"Allow background activity\", \"Allow auto launch\" (or \"Auto launch\"), and \"Allow launch by other apps\" if present.'**
  String get setupAutoStartOppoStep3;

  /// No description provided for @setupAutoStartOppoStep4.
  ///
  /// In en, this message translates to:
  /// **'If there is an \"Optimize battery usage\" option, choose \"Don\'t optimize\" / \"Allow\".'**
  String get setupAutoStartOppoStep4;

  /// No description provided for @setupAutoStartOppoNote.
  ///
  /// In en, this message translates to:
  /// **'Older phones (ColorOS 11 and earlier): go to Phone Manager › Privacy permissions › Startup manager › turn on KidGuard.'**
  String get setupAutoStartOppoNote;

  /// No description provided for @setupAutoStartXiaomiTitle.
  ///
  /// In en, this message translates to:
  /// **'Autostart (Xiaomi / Redmi / POCO)'**
  String get setupAutoStartXiaomiTitle;

  /// No description provided for @setupAutoStartXiaomiStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens the \"Autostart\" list.'**
  String get setupAutoStartXiaomiStep1;

  /// No description provided for @setupFindAndToggle.
  ///
  /// In en, this message translates to:
  /// **'Find KidGuard and turn on the switch next to it.'**
  String get setupFindAndToggle;

  /// No description provided for @setupAutoStartXiaomiNote.
  ///
  /// In en, this message translates to:
  /// **'If the phone opens the App info page: turn on \"Autostart\", then go to \"Battery saver\" › choose \"No restrictions\".'**
  String get setupAutoStartXiaomiNote;

  /// No description provided for @setupAutoStartVivoTitle.
  ///
  /// In en, this message translates to:
  /// **'Autostart (Vivo / iQOO)'**
  String get setupAutoStartVivoTitle;

  /// No description provided for @setupAutoStartVivoStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens the \"Autostart\" / \"Background startup manager\" list.'**
  String get setupAutoStartVivoStep1;

  /// No description provided for @setupAutoStartVivoNote.
  ///
  /// In en, this message translates to:
  /// **'If the phone opens the App info page: go to \"Permissions\" › \"Autostart\" and turn it on.'**
  String get setupAutoStartVivoNote;

  /// No description provided for @setupAutoStartHuaweiTitle.
  ///
  /// In en, this message translates to:
  /// **'App launch (Huawei / Honor)'**
  String get setupAutoStartHuaweiTitle;

  /// No description provided for @setupAutoStartHuaweiStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens the \"App launch\" list.'**
  String get setupAutoStartHuaweiStep1;

  /// No description provided for @setupAutoStartHuaweiStep2.
  ///
  /// In en, this message translates to:
  /// **'Find KidGuard and turn OFF the \"Manage automatically\" switch.'**
  String get setupAutoStartHuaweiStep2;

  /// No description provided for @setupAutoStartHuaweiStep3.
  ///
  /// In en, this message translates to:
  /// **'In the dialog that appears, turn on all 3 options \"Auto-launch\", \"Secondary launch\", \"Run in background\" › OK.'**
  String get setupAutoStartHuaweiStep3;

  /// No description provided for @setupAutoStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Autostart'**
  String get setupAutoStartTitle;

  /// No description provided for @setupAutoStartStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens KidGuard\'s App info page.'**
  String get setupAutoStartStep1;

  /// No description provided for @setupAutoStartStep2.
  ///
  /// In en, this message translates to:
  /// **'Go to \"Battery\" › choose \"Unrestricted\".'**
  String get setupAutoStartStep2;

  /// No description provided for @setupBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Unrestricted battery'**
  String get setupBatteryTitle;

  /// No description provided for @setupBatteryStepOpen.
  ///
  /// In en, this message translates to:
  /// **'The phone opens battery optimization settings (or a list of apps).'**
  String get setupBatteryStepOpen;

  /// No description provided for @setupBatteryStepFind.
  ///
  /// In en, this message translates to:
  /// **'Find KidGuard in the list (use search 🔍 if needed).'**
  String get setupBatteryStepFind;

  /// No description provided for @setupBatteryStepToggle.
  ///
  /// In en, this message translates to:
  /// **'Set KidGuard to \"Unrestricted\" / \"Don\'t optimize\" / \"Allow\".'**
  String get setupBatteryStepToggle;

  /// No description provided for @setupBatteryNote.
  ///
  /// In en, this message translates to:
  /// **'If KidGuard is missing from the list, open App info for KidGuard › Battery › Unrestricted.'**
  String get setupBatteryNote;

  /// No description provided for @setupBatteryOppoStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens \"Battery optimization\" (or \"Optimize battery use\").'**
  String get setupBatteryOppoStep1;

  /// No description provided for @setupBatteryOppoStep2.
  ///
  /// In en, this message translates to:
  /// **'At the top, switch from \"Not optimized\" / \"Apps not optimized\" to \"All apps\" (or \"All\").'**
  String get setupBatteryOppoStep2;

  /// No description provided for @setupBatteryOppoStep3.
  ///
  /// In en, this message translates to:
  /// **'Scroll or search 🔍 to find KidGuard and tap it.'**
  String get setupBatteryOppoStep3;

  /// No description provided for @setupBatteryOppoNote.
  ///
  /// In en, this message translates to:
  /// **'If the list never shows KidGuard: open App info › Battery usage › turn on \"Allow background activity\" and choose \"Don\'t optimize\".'**
  String get setupBatteryOppoNote;

  /// No description provided for @setupBatteryXiaomiStep.
  ///
  /// In en, this message translates to:
  /// **'Open KidGuard › Battery saver › choose \"No restrictions\".'**
  String get setupBatteryXiaomiStep;

  /// No description provided for @setupPopupXiaomiTitle.
  ///
  /// In en, this message translates to:
  /// **'Background pop-ups (Xiaomi)'**
  String get setupPopupXiaomiTitle;

  /// No description provided for @setupPopupXiaomiStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens KidGuard\'s \"Other permissions\" page.'**
  String get setupPopupXiaomiStep1;

  /// No description provided for @setupPopupXiaomiStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Display pop-up windows while running in the background\" › choose \"Always allow\".'**
  String get setupPopupXiaomiStep2;

  /// No description provided for @setupPopupXiaomiStep3.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Display pop-up windows\" › choose \"Always allow\".'**
  String get setupPopupXiaomiStep3;

  /// No description provided for @setupPopupXiaomiNote.
  ///
  /// In en, this message translates to:
  /// **'If the phone opens the App info page: go to \"App permissions\" › \"Other permissions\".'**
  String get setupPopupXiaomiNote;

  /// No description provided for @setupPopupVivoTitle.
  ///
  /// In en, this message translates to:
  /// **'Background pop-ups (Vivo)'**
  String get setupPopupVivoTitle;

  /// No description provided for @setupPopupVivoStep1.
  ///
  /// In en, this message translates to:
  /// **'The phone opens KidGuard\'s permissions page.'**
  String get setupPopupVivoStep1;

  /// No description provided for @setupPopupVivoStep2.
  ///
  /// In en, this message translates to:
  /// **'Turn on \"Display pop-up windows while running in the background\" (some phones call it \"Start apps from background\").'**
  String get setupPopupVivoStep2;

  /// No description provided for @setupPopupVivoNote.
  ///
  /// In en, this message translates to:
  /// **'If the phone opens the App info page: go to \"Permissions\" › \"Other permissions\".'**
  String get setupPopupVivoNote;

  /// No description provided for @setupRecentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock KidGuard in Recents'**
  String get setupRecentsTitle;

  /// No description provided for @setupRecentsStepOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Recents: swipe up from the bottom edge and hold (or tap the ▢ button).'**
  String get setupRecentsStepOpen;

  /// No description provided for @setupRecentsStepOppo.
  ///
  /// In en, this message translates to:
  /// **'On the KidGuard card, tap the ⋮ button at the top (or swipe the card down) › choose \"Lock\".'**
  String get setupRecentsStepOppo;

  /// No description provided for @setupRecentsStepXiaomi.
  ///
  /// In en, this message translates to:
  /// **'Long-press the KidGuard card › tap the lock icon 🔒.'**
  String get setupRecentsStepXiaomi;

  /// No description provided for @setupRecentsStepVivo.
  ///
  /// In en, this message translates to:
  /// **'Swipe the KidGuard card down (or long-press it) › choose \"Lock\" 🔒.'**
  String get setupRecentsStepVivo;

  /// No description provided for @setupRecentsStepHuawei.
  ///
  /// In en, this message translates to:
  /// **'Swipe the KidGuard card down › tap the lock icon 🔒.'**
  String get setupRecentsStepHuawei;

  /// No description provided for @setupRecentsStepSamsung.
  ///
  /// In en, this message translates to:
  /// **'Tap the KidGuard icon above the card › choose \"Keep open\".'**
  String get setupRecentsStepSamsung;

  /// No description provided for @setupRecentsStepOther.
  ///
  /// In en, this message translates to:
  /// **'Long-press the KidGuard card; if there is a \"Lock\" / \"Pin\" option, choose it.'**
  String get setupRecentsStepOther;

  /// No description provided for @setupRecentsStepDone.
  ///
  /// In en, this message translates to:
  /// **'Once the KidGuard card shows a lock icon, you\'re done. Go back to KidGuard.'**
  String get setupRecentsStepDone;

  /// No description provided for @setupRecentsNote.
  ///
  /// In en, this message translates to:
  /// **'Once locked, your child can\'t close KidGuard even by tapping \"Clear all\".'**
  String get setupRecentsNote;

  /// No description provided for @setupConfirmQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you finished this step for KidGuard?'**
  String get setupConfirmQuestion;

  /// No description provided for @setupConfirmAgain.
  ///
  /// In en, this message translates to:
  /// **'Not yet, try again'**
  String get setupConfirmAgain;

  /// No description provided for @setupConfirmDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get setupConfirmDone;

  /// No description provided for @setupReadStepsFirst.
  ///
  /// In en, this message translates to:
  /// **'Read the steps first, then tap \"Open settings\":'**
  String get setupReadStepsFirst;

  /// No description provided for @setupFollowSteps.
  ///
  /// In en, this message translates to:
  /// **'Follow these steps:'**
  String get setupFollowSteps;

  /// No description provided for @setupOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get setupOpenSettings;

  /// No description provided for @setupGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get setupGotIt;

  /// No description provided for @homeParentArea.
  ///
  /// In en, this message translates to:
  /// **'Parent area'**
  String get homeParentArea;

  /// No description provided for @homeParentAreaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See screen time and right/wrong answers for each child'**
  String get homeParentAreaSubtitle;

  /// No description provided for @homeSetupHeader.
  ///
  /// In en, this message translates to:
  /// **'Setup on this phone'**
  String get homeSetupHeader;

  /// No description provided for @homeScreenLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen lock password'**
  String get homeScreenLockTitle;

  /// No description provided for @homeScreenLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required — lets adults take the phone back and unlock it.'**
  String get homeScreenLockSubtitle;

  /// No description provided for @homeOverlaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'So the question screen pops up when time is up, even if your child is in another app.'**
  String get homeOverlaySubtitle;

  /// No description provided for @homePopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Display pop-up windows while running in background'**
  String get homePopupTitle;

  /// No description provided for @homeConfirmedOn.
  ///
  /// In en, this message translates to:
  /// **'You confirmed this is on.'**
  String get homeConfirmedOn;

  /// No description provided for @homePopupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A {brand}-specific permission. Without it, the question screen won\'t pop up when time is up.'**
  String homePopupSubtitle(String brand);

  /// No description provided for @homeReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get homeReview;

  /// No description provided for @homeGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get homeGuide;

  /// No description provided for @homeNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotificationsTitle;

  /// No description provided for @homeNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows the countdown timer in the notification bar.'**
  String get homeNotificationsSubtitle;

  /// No description provided for @homeBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Unrestricted battery'**
  String get homeBatteryTitle;

  /// No description provided for @homeBatterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open battery settings and set KidGuard to Unrestricted / Don\'t optimize so the timer keeps running.'**
  String get homeBatterySubtitle;

  /// No description provided for @homeAutoStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'So lock mode keeps working when your child clears Recents or restarts the phone.'**
  String get homeAutoStartSubtitle;

  /// No description provided for @homeConfirmedLocked.
  ///
  /// In en, this message translates to:
  /// **'You confirmed it is locked.'**
  String get homeConfirmedLocked;

  /// No description provided for @homeRecentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'So the \"Clear all\" button can\'t close KidGuard.'**
  String get homeRecentsSubtitle;

  /// No description provided for @homeManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get homeManage;

  /// No description provided for @homeIosNotice.
  ///
  /// In en, this message translates to:
  /// **'When time is up, Screen Time blocks the selected apps. Your child opens KidGuard to answer the question. For even stronger locking, also turn on Guided Access (Settings › Accessibility › Guided Access).'**
  String get homeIosNotice;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'🧒  Lend the phone to your child'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Your child gets {duration}. When time is up, they answer 1 question for their grade: a right answer earns 5 more minutes, a wrong one locks the phone until a parent unlocks it.'**
  String homeHeroBody(String duration);

  /// No description provided for @homeStartKidMode.
  ///
  /// In en, this message translates to:
  /// **'Start kid mode'**
  String get homeStartKidMode;

  /// No description provided for @homeGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get homeGrant;

  /// No description provided for @hardLockDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off hard lock?'**
  String get hardLockDisableTitle;

  /// No description provided for @hardLockDisableBody.
  ///
  /// In en, this message translates to:
  /// **'KidGuard keeps working (with Advanced lock if it\'s on). You must turn this off before uninstalling KidGuard.'**
  String get hardLockDisableBody;

  /// No description provided for @hardLockCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get hardLockCancel;

  /// No description provided for @hardLockTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get hardLockTurnOff;

  /// No description provided for @hardLockDisabledOk.
  ///
  /// In en, this message translates to:
  /// **'Hard lock is off. You can now uninstall KidGuard like a normal app.'**
  String get hardLockDisabledOk;

  /// No description provided for @hardLockDisableFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t turn off hard lock.'**
  String get hardLockDisableFailed;

  /// No description provided for @hardLockDisableButton.
  ///
  /// In en, this message translates to:
  /// **'Turn off hard lock (requires phone password)'**
  String get hardLockDisableButton;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get registerTitle;

  /// No description provided for @registerGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi there! 👋'**
  String get registerGreeting;

  /// No description provided for @registerIntro.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to use the phone for {duration}.'**
  String registerIntro(String duration);

  /// No description provided for @registerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Alex Smith'**
  String get registerNameHint;

  /// No description provided for @registerDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get registerDobLabel;

  /// No description provided for @registerDobPick.
  ///
  /// In en, this message translates to:
  /// **'Choose your birthday'**
  String get registerDobPick;

  /// No description provided for @registerGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'What grade or level are you studying?'**
  String get registerGradeLabel;

  /// No description provided for @registerGradeChip.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String registerGradeChip(int grade);

  /// No description provided for @registerLevelPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get registerLevelPrimary;

  /// No description provided for @registerLevelLowerSecondary.
  ///
  /// In en, this message translates to:
  /// **'Middle'**
  String get registerLevelLowerSecondary;

  /// No description provided for @registerLevelUpperSecondary.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get registerLevelUpperSecondary;

  /// No description provided for @registerHigherEducation.
  ///
  /// In en, this message translates to:
  /// **'Higher education'**
  String get registerHigherEducation;

  /// No description provided for @gradeUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get gradeUniversity;

  /// No description provided for @gradeUniversityHint.
  ///
  /// In en, this message translates to:
  /// **'College, university'**
  String get gradeUniversityHint;

  /// No description provided for @gradePostgraduate.
  ///
  /// In en, this message translates to:
  /// **'Postgraduate'**
  String get gradePostgraduate;

  /// No description provided for @gradePostgraduateHint.
  ///
  /// In en, this message translates to:
  /// **'Master\'s, PhD'**
  String get gradePostgraduateHint;

  /// No description provided for @registerNeedsScreenLock.
  ///
  /// In en, this message translates to:
  /// **'This phone has no screen lock. A parent needs to set a password first so they can take the phone back.'**
  String get registerNeedsScreenLock;

  /// No description provided for @registerErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String registerErrorGeneric(String error);

  /// No description provided for @registerStart.
  ///
  /// In en, this message translates to:
  /// **'Start using the phone'**
  String get registerStart;

  /// No description provided for @runningGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}!'**
  String runningGreeting(String name);

  /// No description provided for @runningGrade.
  ///
  /// In en, this message translates to:
  /// **'{grade}'**
  String runningGrade(String grade);

  /// No description provided for @runningTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get runningTimeLeft;

  /// No description provided for @runningRules.
  ///
  /// In en, this message translates to:
  /// **'When time is up, you\'ll answer 1 question.\nGet it right for 5 more minutes. Get it wrong and the phone will lock.'**
  String get runningRules;

  /// No description provided for @runningUseOtherApps.
  ///
  /// In en, this message translates to:
  /// **'Use other apps'**
  String get runningUseOtherApps;

  /// No description provided for @quizCorrect.
  ///
  /// In en, this message translates to:
  /// **'🎉 Correct! You get 5 more minutes.'**
  String get quizCorrect;

  /// No description provided for @quizTimeUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get quizTimeUp;

  /// No description provided for @quizInstruction.
  ///
  /// In en, this message translates to:
  /// **'Answer correctly to get 5 more minutes.'**
  String get quizInstruction;

  /// No description provided for @quizSubmit.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get quizSubmit;

  /// No description provided for @reviewWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite right!'**
  String get reviewWrong;

  /// No description provided for @reviewYourChoice.
  ///
  /// In en, this message translates to:
  /// **'You chose'**
  String get reviewYourChoice;

  /// No description provided for @reviewCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get reviewCorrectAnswer;

  /// No description provided for @reviewSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'What to review'**
  String get reviewSuggestionTitle;

  /// No description provided for @reviewLockNotice.
  ///
  /// In en, this message translates to:
  /// **'When you tap OK, the phone will lock. Please give the phone to your parents.'**
  String get reviewLockNotice;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @lockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone locked'**
  String get lockedTitle;

  /// No description provided for @lockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}, please give the phone to your parents.\nRemember to review what was suggested!'**
  String lockedMessage(String name);

  /// No description provided for @lockedUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Adult: unlock & take back phone'**
  String get lockedUnlockButton;

  /// No description provided for @revokeButton.
  ///
  /// In en, this message translates to:
  /// **'Adult: take back phone'**
  String get revokeButton;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent area'**
  String get dashboardTitle;

  /// No description provided for @dashboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No child has used this phone yet.'**
  String get dashboardEmpty;

  /// No description provided for @dashboardTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get dashboardTotalTime;

  /// No description provided for @dashboardCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get dashboardCorrect;

  /// No description provided for @dashboardWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get dashboardWrong;

  /// No description provided for @dashboardChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get dashboardChildren;

  /// No description provided for @dashboardChildInfo.
  ///
  /// In en, this message translates to:
  /// **'{grade} · {age, plural, =1{1 year old} other{{age} years old}}'**
  String dashboardChildInfo(String grade, int age);

  /// No description provided for @reportChildInfo.
  ///
  /// In en, this message translates to:
  /// **'{grade} · Born {dob}'**
  String reportChildInfo(String grade, String dob);

  /// No description provided for @reportTimeUsed.
  ///
  /// In en, this message translates to:
  /// **'Time used'**
  String get reportTimeUsed;

  /// No description provided for @reportCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get reportCorrect;

  /// No description provided for @reportWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get reportWrong;

  /// No description provided for @reportWeakTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Topics to review'**
  String get reportWeakTopicsTitle;

  /// No description provided for @reportWrongTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{wrong once} other{wrong {count} times}}'**
  String reportWrongTimes(int count);

  /// No description provided for @reportHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage history ({count, plural, =1{1 session} other{{count} sessions}})'**
  String reportHistoryTitle(int count);

  /// No description provided for @reportNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet.'**
  String get reportNoSessions;

  /// No description provided for @reportLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get reportLoadMore;

  /// No description provided for @reportLogRetention.
  ///
  /// In en, this message translates to:
  /// **'Logs are kept for up to {days, plural, =1{1 day} other{{days} days}}.'**
  String reportLogRetention(int days);

  /// No description provided for @reportStatusActive.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get reportStatusActive;

  /// No description provided for @reportStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked after a wrong answer'**
  String get reportStatusLocked;

  /// No description provided for @reportStatusRevoked.
  ///
  /// In en, this message translates to:
  /// **'Taken back by an adult'**
  String get reportStatusRevoked;

  /// No description provided for @reportSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Used {duration} · {count, plural, =1{1 question} other{{count} questions}} (✅ {correct}  ❌ {wrong})'**
  String reportSessionSummary(
    String duration,
    int count,
    int correct,
    int wrong,
  );

  /// No description provided for @reportEndedAt.
  ///
  /// In en, this message translates to:
  /// **'Ended: {time}'**
  String reportEndedAt(String time);

  /// No description provided for @reportNoAttempts.
  ///
  /// In en, this message translates to:
  /// **'No questions answered yet.'**
  String get reportNoAttempts;

  /// No description provided for @reportAttemptTitle.
  ///
  /// In en, this message translates to:
  /// **'Question {number} · {subject} — {topic}'**
  String reportAttemptTitle(int number, String subject, String topic);

  /// No description provided for @reportChosenAnswer.
  ///
  /// In en, this message translates to:
  /// **'Child chose: {letter}. {option}'**
  String reportChosenAnswer(String letter, String option);

  /// No description provided for @reportCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer: {letter}. {option}'**
  String reportCorrectAnswer(String letter, String option);

  /// No description provided for @quizLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the question: {error}'**
  String quizLoadError(String error);

  /// No description provided for @homeScreenTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Time permission'**
  String get homeScreenTimeTitle;

  /// No description provided for @homeScreenTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lets KidGuard block the apps you choose when time is up. Confirm with Face ID or the phone passcode.'**
  String get homeScreenTimeSubtitle;

  /// No description provided for @homeLimitedAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps blocked when time is up'**
  String get homeLimitedAppsTitle;

  /// No description provided for @homeLimitedAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the apps or app categories (e.g. Games, Social, Entertainment). Do not select KidGuard.'**
  String get homeLimitedAppsSubtitle;

  /// No description provided for @homeLimitedAppsOn.
  ///
  /// In en, this message translates to:
  /// **'Selected. You can change the list at any time.'**
  String get homeLimitedAppsOn;

  /// No description provided for @homeLimitedAppsChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get homeLimitedAppsChoose;

  /// No description provided for @homeLimitedAppsChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get homeLimitedAppsChange;

  /// No description provided for @homeScreenTimeFirst.
  ///
  /// In en, this message translates to:
  /// **'Grant the Screen Time permission first.'**
  String get homeScreenTimeFirst;

  /// No description provided for @homeDesktopTitle.
  ///
  /// In en, this message translates to:
  /// **'How locking works on this computer'**
  String get homeDesktopTitle;

  /// No description provided for @homeMacNotice.
  ///
  /// In en, this message translates to:
  /// **'When time is up, KidGuard comes to the front in full-screen kiosk mode: the Dock, menu bar, Cmd+Tab and Force Quit are disabled until the question is answered or a parent unlocks with the Mac password or Touch ID. During a session KidGuard can\'t be quit and reopens automatically after login.'**
  String get homeMacNotice;

  /// No description provided for @homeWindowsNotice.
  ///
  /// In en, this message translates to:
  /// **'When time is up, KidGuard covers the whole screen and stays on top: the Windows key, Alt+Tab and Alt+F4 are blocked until the question is answered or a parent unlocks with Windows Hello (PIN, fingerprint or face). During a session KidGuard can\'t be closed and reopens automatically after sign-in. Windows does not allow apps to block Ctrl+Alt+Del.'**
  String get homeWindowsNotice;

  /// No description provided for @homeWindowsHelloHint.
  ///
  /// In en, this message translates to:
  /// **'Windows Hello must be set up (Settings › Accounts › Sign-in options › PIN).'**
  String get homeWindowsHelloHint;

  /// No description provided for @runningIosHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe up (or press the Home button) to use other apps.'**
  String get runningIosHint;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @dashboardQuestionSource.
  ///
  /// In en, this message translates to:
  /// **'Question source'**
  String get dashboardQuestionSource;

  /// No description provided for @qsTitle.
  ///
  /// In en, this message translates to:
  /// **'Question source'**
  String get qsTitle;

  /// No description provided for @qsSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get qsSource;

  /// No description provided for @qsDefaultSource.
  ///
  /// In en, this message translates to:
  /// **'Default (KidGuard)'**
  String get qsDefaultSource;

  /// No description provided for @qsCustomSource.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get qsCustomSource;

  /// No description provided for @qsVersion.
  ///
  /// In en, this message translates to:
  /// **'Question bank version'**
  String get qsVersion;

  /// No description provided for @qsDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Grades using downloaded questions'**
  String get qsDownloaded;

  /// No description provided for @qsBundledOnly.
  ///
  /// In en, this message translates to:
  /// **'Using the questions built into the app'**
  String get qsBundledOnly;

  /// No description provided for @qsLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last checked'**
  String get qsLastSync;

  /// No description provided for @qsNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get qsNever;

  /// No description provided for @qsSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get qsSyncNow;

  /// No description provided for @qsChangeSource.
  ///
  /// In en, this message translates to:
  /// **'Change question source'**
  String get qsChangeSource;

  /// No description provided for @qsChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'manifest.json address'**
  String get qsChangeTitle;

  /// No description provided for @qsUseDefault.
  ///
  /// In en, this message translates to:
  /// **'Use default source'**
  String get qsUseDefault;

  /// No description provided for @qsSave.
  ///
  /// In en, this message translates to:
  /// **'Save and download'**
  String get qsSave;

  /// No description provided for @qsHelp.
  ///
  /// In en, this message translates to:
  /// **'Questions are downloaded over the internet and stored on this device, so they still work offline. Every file is checked for format and checksum; if anything is wrong, the app keeps the questions it already has. A custom source (for example your school\'s) needs a manifest.json and grade_N.json files in the same format: grades 1–12, 13 = University, 14 = Postgraduate.'**
  String get qsHelp;

  /// No description provided for @qsCustomSourceWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Use only a trusted source'**
  String get qsCustomSourceWarningTitle;

  /// No description provided for @qsCustomSourceWarningBody.
  ///
  /// In en, this message translates to:
  /// **'KidGuard will download and show questions from this HTTPS address. Use only a source you trust (for example your school). A malicious source could show inappropriate or wrong content to your child.'**
  String get qsCustomSourceWarningBody;

  /// No description provided for @qsCustomSourceConfirm.
  ///
  /// In en, this message translates to:
  /// **'I trust this source'**
  String get qsCustomSourceConfirm;

  /// No description provided for @homeAndroidNotice.
  ///
  /// In en, this message translates to:
  /// **'When time is up, KidGuard comes to the front (overlay) and shows a question. For a stronger lock—blocking the notification shade, Recents and turning KidGuard off—turn on Advanced lock (Accessibility) below. Emergency and incoming calls still work.'**
  String get homeAndroidNotice;

  /// No description provided for @qsResultUpdated.
  ///
  /// In en, this message translates to:
  /// **'Question bank updated to version {version}.'**
  String qsResultUpdated(int version);

  /// No description provided for @qsResultUpToDate.
  ///
  /// In en, this message translates to:
  /// **'The question bank is already up to date.'**
  String get qsResultUpToDate;

  /// No description provided for @qsErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download questions (check the connection or address). The app keeps using the questions already on this device.'**
  String get qsErrorNetwork;

  /// No description provided for @qsErrorManifest.
  ///
  /// In en, this message translates to:
  /// **'manifest.json is not in the right format. The app keeps using the questions already on this device.'**
  String get qsErrorManifest;

  /// No description provided for @qsErrorQuestions.
  ///
  /// In en, this message translates to:
  /// **'A question file is not in the right format. The app keeps using the questions already on this device.'**
  String get qsErrorQuestions;

  /// No description provided for @qsErrorChecksum.
  ///
  /// In en, this message translates to:
  /// **'A question file doesn\'t match the checksum in the manifest. The app keeps using the questions already on this device.'**
  String get qsErrorChecksum;

  /// No description provided for @qsInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'This address is not valid.'**
  String get qsInvalidUrl;

  /// No description provided for @qsInsecureUrl.
  ///
  /// In en, this message translates to:
  /// **'Only addresses starting with https:// are allowed.'**
  String get qsInsecureUrl;

  /// No description provided for @registerPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s using the phone?'**
  String get registerPickTitle;

  /// No description provided for @registerPickIntro.
  ///
  /// In en, this message translates to:
  /// **'Tap your name to use the phone for {duration}.'**
  String registerPickIntro(String duration);

  /// No description provided for @registerAddNew.
  ///
  /// In en, this message translates to:
  /// **'I\'m not on the list'**
  String get registerAddNew;

  /// No description provided for @registerBackToList.
  ///
  /// In en, this message translates to:
  /// **'Pick a saved name'**
  String get registerBackToList;

  /// No description provided for @registerSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Wrong details or a new school year? Ask a parent to update them in the parent area.'**
  String get registerSavedHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsInitialAllowance.
  ///
  /// In en, this message translates to:
  /// **'Starting screen time'**
  String get settingsInitialAllowance;

  /// No description provided for @settingsInitialAllowanceDefault.
  ///
  /// In en, this message translates to:
  /// **'{duration} (default)'**
  String settingsInitialAllowanceDefault(String duration);

  /// No description provided for @settingsInitialAllowanceHint.
  ///
  /// In en, this message translates to:
  /// **'How long your child can use the phone each time before the first question. Applies from the next session.'**
  String get settingsInitialAllowanceHint;

  /// No description provided for @settingsMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get settingsMinutesLabel;

  /// No description provided for @settingsMinutesMin.
  ///
  /// In en, this message translates to:
  /// **'At least {min} minutes.'**
  String settingsMinutesMin(int min);

  /// No description provided for @settingsMinutesInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of minutes.'**
  String get settingsMinutesInvalid;

  /// No description provided for @settingsResetDefault.
  ///
  /// In en, this message translates to:
  /// **'Use default ({duration})'**
  String settingsResetDefault(String duration);

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @childEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get childEditTooltip;

  /// No description provided for @childEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit child details'**
  String get childEditTitle;

  /// No description provided for @childEditGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grade / level'**
  String get childEditGradeLabel;

  /// No description provided for @childEditNote.
  ///
  /// In en, this message translates to:
  /// **'Update the grade at the start of each school year so questions match your child\'s level. Past history is kept.'**
  String get childEditNote;

  /// No description provided for @childEditSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {name}\'s details.'**
  String childEditSaved(String name);

  /// No description provided for @childDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete child'**
  String get childDeleteTooltip;

  /// No description provided for @childDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String childDeleteTitle(String name);

  /// No description provided for @childDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes this child\'s profile and usage history on this device. It cannot be undone.'**
  String get childDeleteBody;

  /// No description provided for @childDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get childDeleteConfirm;

  /// No description provided for @childDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted {name}\'s data.'**
  String childDeleted(String name);

  /// No description provided for @clearAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all child data?'**
  String get clearAllDataTitle;

  /// No description provided for @clearAllDataBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes every child profile and usage history on this device. Question files and app settings for parental controls stay. It cannot be undone.'**
  String get clearAllDataBody;

  /// No description provided for @clearAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get clearAllDataConfirm;

  /// No description provided for @clearAllDataButton.
  ///
  /// In en, this message translates to:
  /// **'Delete all child data'**
  String get clearAllDataButton;

  /// No description provided for @clearAllDataDone.
  ///
  /// In en, this message translates to:
  /// **'All child data on this device was deleted.'**
  String get clearAllDataDone;

  /// No description provided for @deleteBlockedActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Finish or stop the child\'s session before deleting data.'**
  String get deleteBlockedActiveSession;

  /// No description provided for @homeAdvancedLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced lock (Accessibility) — recommended'**
  String get homeAdvancedLockTitle;

  /// No description provided for @homeAdvancedLockOn.
  ///
  /// In en, this message translates to:
  /// **'On: when time is up your child can\'t pull down notifications or open recents or other apps.'**
  String get homeAdvancedLockOn;

  /// No description provided for @homeAdvancedLockOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on in Settings › Accessibility right on this phone, no computer needed. Blocks the notification shade, recents and turning KidGuard off.'**
  String get homeAdvancedLockOff;

  /// No description provided for @advancedLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced lock'**
  String get advancedLockTitle;

  /// No description provided for @advancedLockStatusOn.
  ///
  /// In en, this message translates to:
  /// **'Advanced lock is ON'**
  String get advancedLockStatusOn;

  /// No description provided for @advancedLockStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Advanced lock is off'**
  String get advancedLockStatusOff;

  /// No description provided for @advancedLockStatusOnBody.
  ///
  /// In en, this message translates to:
  /// **'When time is up or the phone is locked, KidGuard keeps the quiz on screen and your child can\'t turn KidGuard off during a session.'**
  String get advancedLockStatusOnBody;

  /// No description provided for @advancedLockStatusOffBody.
  ///
  /// In en, this message translates to:
  /// **'KidGuard still covers the screen when time is up, but your child can pull down the notification shade and could turn KidGuard off from Settings during their free time.'**
  String get advancedLockStatusOffBody;

  /// No description provided for @advancedLockWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What it does'**
  String get advancedLockWhatTitle;

  /// No description provided for @advancedLockWhat1.
  ///
  /// In en, this message translates to:
  /// **'When time is up or the phone is locked: closes the notification shade and blocks recents, the home screen and split screen, bringing the quiz back instantly.'**
  String get advancedLockWhat1;

  /// No description provided for @advancedLockWhat2.
  ///
  /// In en, this message translates to:
  /// **'During your child\'s whole session: blocks Settings and uninstallers so your child cannot turn KidGuard off (including Accessibility).'**
  String get advancedLockWhat2;

  /// No description provided for @advancedLockWhat3.
  ///
  /// In en, this message translates to:
  /// **'Incoming and emergency calls still work.'**
  String get advancedLockWhat3;

  /// No description provided for @advancedLockPrivacy.
  ///
  /// In en, this message translates to:
  /// **'KidGuard only uses Accessibility to know which app package is on top. It does not read, store or send what\'s on your screen.'**
  String get advancedLockPrivacy;

  /// No description provided for @advancedLockStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to turn it on (about 1 minute)'**
  String get advancedLockStepsTitle;

  /// No description provided for @advancedLockStepRestricted.
  ///
  /// In en, this message translates to:
  /// **'Android 13 and later, if KidGuard wasn\'t installed from Google Play: open KidGuard\'s App info › tap ⋮ (top right) › \"Allow restricted settings\" › enter the phone\'s password. If you don\'t see it, skip this step.'**
  String get advancedLockStepRestricted;

  /// No description provided for @advancedLockOpenAppInfo.
  ///
  /// In en, this message translates to:
  /// **'Open App info'**
  String get advancedLockOpenAppInfo;

  /// No description provided for @advancedLockStepEnable.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below › choose KidGuard (usually under \"Downloaded apps\" or \"Installed apps\") › turn it on › Allow.'**
  String get advancedLockStepEnable;

  /// No description provided for @advancedLockOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings'**
  String get advancedLockOpenSettings;

  /// No description provided for @advancedLockStepBack.
  ///
  /// In en, this message translates to:
  /// **'Come back to KidGuard: the status above turns ON.'**
  String get advancedLockStepBack;

  /// No description provided for @advancedLockOffNote.
  ///
  /// In en, this message translates to:
  /// **'To turn it off: end your child\'s session first (parent unlock), then go to Settings › Accessibility › KidGuard › off.'**
  String get advancedLockOffNote;

  /// No description provided for @advancedLockDisclosureTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you turn on Advanced lock'**
  String get advancedLockDisclosureTitle;

  /// No description provided for @advancedLockDisclosureBody.
  ///
  /// In en, this message translates to:
  /// **'KidGuard\'s Accessibility service will see only which app package is in the foreground during a parent-started session. It does not read, store or send anything on the screen.\n\nWhen time is up it closes the notification shade and brings the quiz back. During a session it blocks Settings and uninstallers so your child cannot turn KidGuard off. Calls still work. Outside a session the service does nothing.\n\nYou will turn it on yourself in system Settings. You can turn it off anytime after ending the child\'s session.'**
  String get advancedLockDisclosureBody;

  /// No description provided for @advancedLockAgreeContinue.
  ///
  /// In en, this message translates to:
  /// **'I understand — continue'**
  String get advancedLockAgreeContinue;

  /// No description provided for @legacyHardLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Old hard lock (Device Owner) is on'**
  String get legacyHardLockTitle;

  /// No description provided for @legacyHardLockBody.
  ///
  /// In en, this message translates to:
  /// **'This phone had hard lock turned on with a computer in an earlier version. Turn it off before uninstalling KidGuard.'**
  String get legacyHardLockBody;

  /// No description provided for @advancedLockDroppedTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced lock was turned off'**
  String get advancedLockDroppedTitle;

  /// No description provided for @advancedLockDroppedBody.
  ///
  /// In en, this message translates to:
  /// **'Android turns Advanced lock off when KidGuard is force-stopped (Settings › Force stop, clearing Recents on some phones, or reinstalling the app). Turn it on again before giving the phone to your child.'**
  String get advancedLockDroppedBody;

  /// No description provided for @advancedLockTurnOnAgain.
  ///
  /// In en, this message translates to:
  /// **'Turn on again'**
  String get advancedLockTurnOnAgain;

  /// No description provided for @advancedLockStopUsing.
  ///
  /// In en, this message translates to:
  /// **'Stop using it'**
  String get advancedLockStopUsing;

  /// No description provided for @advancedLockDroppedStartBody.
  ///
  /// In en, this message translates to:
  /// **'Advanced lock is off, so your child can pull down the notification shade and turn KidGuard off in Settings. Turn it on again before handing over the phone?'**
  String get advancedLockDroppedStartBody;

  /// No description provided for @advancedLockContinueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get advancedLockContinueAnyway;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
