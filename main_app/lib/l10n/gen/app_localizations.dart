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
  /// **'Wrong PIN or password, or it was cancelled.'**
  String get authFailed;

  /// No description provided for @authNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This phone has no screen lock. Go to Settings and set a PIN/password first.'**
  String get authNotAvailable;

  /// No description provided for @authReasonRevoke.
  ///
  /// In en, this message translates to:
  /// **'Take the device back and turn off kid mode'**
  String get authReasonRevoke;

  /// No description provided for @authReasonParentArea.
  ///
  /// In en, this message translates to:
  /// **'Open the Parent area'**
  String get authReasonParentArea;

  /// No description provided for @authReasonRegisterChild.
  ///
  /// In en, this message translates to:
  /// **'Add a child\'s profile'**
  String get authReasonRegisterChild;

  /// No description provided for @authReasonDisableHardLock.
  ///
  /// In en, this message translates to:
  /// **'Turn off hard lock'**
  String get authReasonDisableHardLock;

  /// No description provided for @authReasonDeleteChild.
  ///
  /// In en, this message translates to:
  /// **'Delete this child\'s data'**
  String get authReasonDeleteChild;

  /// No description provided for @authReasonClearAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all child data on this device'**
  String get authReasonClearAllData;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'For parents'**
  String get consentTitle;

  /// No description provided for @consentIntro.
  ///
  /// In en, this message translates to:
  /// **'KidGuard helps you set screen time for your child. A few things to know before you start:'**
  String get consentIntro;

  /// No description provided for @consentParentTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up by a parent'**
  String get consentParentTitle;

  /// No description provided for @consentParentBody.
  ///
  /// In en, this message translates to:
  /// **'Only a parent or guardian sets up and unlocks KidGuard.'**
  String get consentParentBody;

  /// No description provided for @consentLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Data stays on this device'**
  String get consentLocalTitle;

  /// No description provided for @consentLocalBody.
  ///
  /// In en, this message translates to:
  /// **'No accounts. Your child\'s profile is never uploaded.'**
  String get consentLocalBody;

  /// No description provided for @consentChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s details'**
  String get consentChildTitle;

  /// No description provided for @consentChildBody.
  ///
  /// In en, this message translates to:
  /// **'Name, date of birth and grade — for study tasks, questions and reports.'**
  String get consentChildBody;

  /// No description provided for @consentNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Internet only for questions'**
  String get consentNetworkTitle;

  /// No description provided for @consentNetworkBody.
  ///
  /// In en, this message translates to:
  /// **'Question updates over HTTPS, without your child\'s details.'**
  String get consentNetworkBody;

  /// No description provided for @consentAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree and continue'**
  String get consentAgree;

  /// No description provided for @consentReadPolicy.
  ///
  /// In en, this message translates to:
  /// **'View privacy policy'**
  String get consentReadPolicy;

  /// No description provided for @consentFootnote.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you confirm you are the child\'s parent or guardian.'**
  String get consentFootnote;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'A summary of how KidGuard uses data. The full policy is linked below.'**
  String get privacyIntro;

  /// No description provided for @privacyStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Stored on this device'**
  String get privacyStoreTitle;

  /// No description provided for @privacyStoreBody.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s profile (name, date of birth, grade), study tasks you set, screen-time history, completed tasks and answers. No online account.'**
  String get privacyStoreBody;

  /// No description provided for @privacyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'You can delete it'**
  String get privacyDeleteTitle;

  /// No description provided for @privacyDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete one child or all data in the Parent area. History older than 180 days is removed automatically.'**
  String get privacyDeleteBody;

  /// No description provided for @privacyUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlocked with a parent PIN'**
  String get privacyUnlockTitle;

  /// No description provided for @privacyUnlockBody.
  ///
  /// In en, this message translates to:
  /// **'Only a one-way salted hash of the PIN is kept on this device. You can also allow the device passcode, Face ID or fingerprint; KidGuard never sees them.'**
  String get privacyUnlockBody;

  /// No description provided for @privacyPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'System access only to lock'**
  String get privacyPermissionsTitle;

  /// No description provided for @privacyPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'Accessibility (Android), Screen Time (iOS), kiosk mode (computers). No reading messages or screen content.'**
  String get privacyPermissionsBody;

  /// No description provided for @privacyNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s data isn\'t sent'**
  String get privacyNetworkTitle;

  /// No description provided for @privacyNetworkBody.
  ///
  /// In en, this message translates to:
  /// **'Only question files are downloaded over HTTPS. No ads, no tracking.'**
  String get privacyNetworkBody;

  /// No description provided for @privacyFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Full policy'**
  String get privacyFullTitle;

  /// No description provided for @privacyCopyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get privacyCopyUrl;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyTitle;

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
  /// **'Study tasks, screen time and answers for each child'**
  String get homeParentAreaSubtitle;

  /// No description provided for @homeSetupHeader.
  ///
  /// In en, this message translates to:
  /// **'Setup on this phone'**
  String get homeSetupHeader;

  /// No description provided for @homeOverlaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'So KidGuard pops up when time is up, even if your child is in another app.'**
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
  /// **'A {brand}-specific permission. Without it, KidGuard won\'t pop up when time is up.'**
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
  /// **'Best on the child\'s iPhone (child Apple ID in Family Sharing): after a parent approves, the child can\'t delete KidGuard or turn Screen Time access off. On a parent\'s iPhone lent to the child, KidGuard can still block selected apps, but the child could delete the app — turn on Guided Access too. When time is up, only the apps you chose are blocked — not the whole phone.'**
  String get homeIosNotice;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'🧒  Lend the phone to your child'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Your child gets {duration}. When time is up, they finish a study task you set, or answer 1 question for their grade (right: 5 more minutes, wrong: the device locks until a parent unlocks it).'**
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
  /// **'Turn off hard lock (requires parent PIN)'**
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
  /// **'When time is up, finish a study task for more time,\nor answer 1 question: right = 5 more minutes, wrong = locked.'**
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

  /// No description provided for @lockedTitleIos.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up'**
  String get lockedTitleIos;

  /// No description provided for @lockedMessageIos.
  ///
  /// In en, this message translates to:
  /// **'Hey {name}, the apps your parents chose are blocked.\nPlease give the phone to a parent to unlock.'**
  String lockedMessageIos(String name);

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
  /// **'No children yet. Add a child to set study tasks before handing over the phone.'**
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
  /// **'Lets KidGuard block the apps you choose when time is up. Prefer the child\'s iPhone in Family Sharing; parent\'s phone lent to the child also works with a weaker lock.'**
  String get homeScreenTimeSubtitle;

  /// No description provided for @homeLimitedAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps blocked when time is up'**
  String get homeLimitedAppsTitle;

  /// No description provided for @homeLimitedAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the apps or app categories (e.g. Games, Social, Entertainment). Do not select KidGuard. Other apps stay usable.'**
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

  /// No description provided for @screenTimeBorrowTitle.
  ///
  /// In en, this message translates to:
  /// **'Is this a parent\'s iPhone?'**
  String get screenTimeBorrowTitle;

  /// No description provided for @screenTimeBorrowBody.
  ///
  /// In en, this message translates to:
  /// **'Screen Time for a child account needs the child\'s Apple ID in Family Sharing. If this is your iPhone and you are lending it to your child, continue with a weaker lock: your child could delete KidGuard or turn Screen Time access off. Turn on Guided Access for a stronger lock.'**
  String get screenTimeBorrowBody;

  /// No description provided for @screenTimeBorrowConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, parent\'s phone'**
  String get screenTimeBorrowConfirm;

  /// No description provided for @screenTimeBorrowCancel.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get screenTimeBorrowCancel;

  /// No description provided for @screenTimeIndividualWarning.
  ///
  /// In en, this message translates to:
  /// **'Weaker lock: your child could delete KidGuard. Turn on Guided Access (Settings › Accessibility › Guided Access).'**
  String get screenTimeIndividualWarning;

  /// No description provided for @screenTimeErrorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Screen Time permission was cancelled.'**
  String get screenTimeErrorCancelled;

  /// No description provided for @screenTimeErrorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Screen Time is not available on this device.'**
  String get screenTimeErrorUnavailable;

  /// No description provided for @screenTimeErrorConflict.
  ///
  /// In en, this message translates to:
  /// **'Another parental-control app already holds Screen Time access on this iPhone. Remove that app\'s access (Settings › Screen Time) and try again.'**
  String get screenTimeErrorConflict;

  /// No description provided for @screenTimeErrorNotChildAccount.
  ///
  /// In en, this message translates to:
  /// **'This iPhone is not signed in with a child\'s Apple ID in Family Sharing. If you are lending your phone, choose \"Yes, parent\'s phone\" when asked.'**
  String get screenTimeErrorNotChildAccount;

  /// No description provided for @screenTimeErrorDenied.
  ///
  /// In en, this message translates to:
  /// **'Screen Time permission was not granted.'**
  String get screenTimeErrorDenied;

  /// No description provided for @screenTimeErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not enable Screen Time. Try again.'**
  String get screenTimeErrorFailed;

  /// No description provided for @homeDesktopTitle.
  ///
  /// In en, this message translates to:
  /// **'How locking works on this computer'**
  String get homeDesktopTitle;

  /// No description provided for @homeMacNotice.
  ///
  /// In en, this message translates to:
  /// **'When time is up, KidGuard comes to the front in full-screen kiosk mode: the Dock, menu bar, Cmd+Tab and Force Quit are disabled until your child finishes a task or answers a question or a parent unlocks with the parent PIN. During a session KidGuard can\'t be quit, and it reopens after login if you allow it below.'**
  String get homeMacNotice;

  /// No description provided for @macRelaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'Reopen KidGuard after login?'**
  String get macRelaunchTitle;

  /// No description provided for @macRelaunchBody.
  ///
  /// In en, this message translates to:
  /// **'During your child\'s session, KidGuard can add itself as a login item so it reopens if your child logs out or restarts the Mac. macOS will show a \"Login item added\" notice. It is removed when the session ends. You can change this on the home screen anytime.'**
  String get macRelaunchBody;

  /// No description provided for @macRelaunchAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get macRelaunchAllow;

  /// No description provided for @macRelaunchDeny.
  ///
  /// In en, this message translates to:
  /// **'Don\'t allow'**
  String get macRelaunchDeny;

  /// No description provided for @homeMacRelaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'Reopen after login (during a session)'**
  String get homeMacRelaunchTitle;

  /// No description provided for @homeMacRelaunchOn.
  ///
  /// In en, this message translates to:
  /// **'On: if your child logs out or restarts the Mac, KidGuard reopens. Removed when the session ends.'**
  String get homeMacRelaunchOn;

  /// No description provided for @homeMacRelaunchOff.
  ///
  /// In en, this message translates to:
  /// **'Off: your child could escape the lock by logging out or restarting the Mac.'**
  String get homeMacRelaunchOff;

  /// No description provided for @homeMacRelaunchEnable.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get homeMacRelaunchEnable;

  /// No description provided for @homeMacRelaunchDisable.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get homeMacRelaunchDisable;

  /// No description provided for @homeWindowsNotice.
  ///
  /// In en, this message translates to:
  /// **'When time is up, KidGuard covers the whole screen and stays on top: the Windows key, Alt+Tab and Alt+F4 are blocked until your child finishes a task or answers a question or a parent unlocks with the parent PIN. During a session KidGuard can\'t be closed and reopens automatically after sign-in. Windows does not allow apps to block Ctrl+Alt+Del.'**
  String get homeWindowsNotice;

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
  /// **'When time is up, KidGuard comes to the front (overlay) with your child\'s study tasks or a question. For a stronger lock—blocking the notification shade, Recents and turning KidGuard off—turn on Advanced lock (Accessibility) below. Emergency and incoming calls still work.'**
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
  /// **'How long your child can use the phone each time before time is up. Applies from the next session.'**
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
  /// **'When time is up or the phone is locked, KidGuard stays on screen and your child can\'t turn KidGuard off during a session.'**
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
  /// **'When time is up or the phone is locked: closes the notification shade and blocks recents, the home screen and split screen, bringing KidGuard back instantly.'**
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
  /// **'KidGuard\'s Accessibility service will see only which app package is in the foreground during a parent-started session. It does not read, store or send anything on the screen.\n\nWhen time is up it closes the notification shade and brings KidGuard back. During a session it blocks Settings and uninstallers so your child cannot turn KidGuard off. Calls still work. Outside a session the service does nothing.\n\nYou will turn it on yourself in system Settings. You can turn it off anytime after ending the child\'s session.'**
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

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get tasksTitle;

  /// No description provided for @tasksIntro.
  ///
  /// In en, this message translates to:
  /// **'{name}, finish one task to get more time.'**
  String tasksIntro(String name);

  /// No description provided for @tasksReward.
  ///
  /// In en, this message translates to:
  /// **'+{reward}'**
  String tasksReward(String reward);

  /// No description provided for @tasksKindCheck.
  ///
  /// In en, this message translates to:
  /// **'A parent checks it'**
  String get tasksKindCheck;

  /// No description provided for @tasksKindTimer.
  ///
  /// In en, this message translates to:
  /// **'{duration} timer'**
  String tasksKindTimer(String duration);

  /// No description provided for @tasksDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get tasksDoneToday;

  /// No description provided for @tasksAskParent.
  ///
  /// In en, this message translates to:
  /// **'I\'m done'**
  String get tasksAskParent;

  /// No description provided for @tasksStartTimer.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tasksStartTimer;

  /// No description provided for @tasksAllDone.
  ///
  /// In en, this message translates to:
  /// **'You\'ve finished all of today\'s tasks. You can answer a question for more time.'**
  String get tasksAllDone;

  /// No description provided for @tasksQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer a question'**
  String get tasksQuizTitle;

  /// No description provided for @tasksQuizBody.
  ///
  /// In en, this message translates to:
  /// **'Right: +{reward}. Wrong: the device locks.'**
  String tasksQuizBody(String reward);

  /// No description provided for @tasksQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get tasksQuizButton;

  /// No description provided for @tasksApproved.
  ///
  /// In en, this message translates to:
  /// **'Well done! {reward} more.'**
  String tasksApproved(String reward);

  /// No description provided for @authReasonApproveTask.
  ///
  /// In en, this message translates to:
  /// **'Confirm the task is done: {task}'**
  String authReasonApproveTask(String task);

  /// No description provided for @taskTimerLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get taskTimerLeft;

  /// No description provided for @taskTimerHint.
  ///
  /// In en, this message translates to:
  /// **'The device stays locked while you work. When the timer ends you get {reward} automatically.'**
  String taskTimerHint(String reward);

  /// No description provided for @taskTimerCancel.
  ///
  /// In en, this message translates to:
  /// **'Choose another task'**
  String get taskTimerCancel;

  /// No description provided for @taskTimerCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop this task?'**
  String get taskTimerCancelTitle;

  /// No description provided for @taskTimerCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The time so far won\'t count.'**
  String get taskTimerCancelBody;

  /// No description provided for @taskTimerCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get taskTimerCancelConfirm;

  /// No description provided for @studyTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily study tasks'**
  String get studyTasksTitle;

  /// No description provided for @studyTasksIntro.
  ///
  /// In en, this message translates to:
  /// **'When time is up, {name} picks a task. Finishing it earns more time. Each task counts once a day. Answering a question is always an option.'**
  String studyTasksIntro(String name);

  /// No description provided for @studyTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet. When time is up, your child answers a question as before.'**
  String get studyTasksEmpty;

  /// No description provided for @studyTasksAdd.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get studyTasksAdd;

  /// No description provided for @studyTasksEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get studyTasksEdit;

  /// No description provided for @studyTaskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get studyTaskTitleLabel;

  /// No description provided for @studyTaskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Math homework, page 32'**
  String get studyTaskTitleHint;

  /// No description provided for @studyTaskKindLabel.
  ///
  /// In en, this message translates to:
  /// **'How it\'s checked'**
  String get studyTaskKindLabel;

  /// No description provided for @studyTaskKindCheck.
  ///
  /// In en, this message translates to:
  /// **'Parent approves'**
  String get studyTaskKindCheck;

  /// No description provided for @studyTaskKindCheckHint.
  ///
  /// In en, this message translates to:
  /// **'Your child taps “I\'m done”, then you enter the parent PIN to approve.'**
  String get studyTaskKindCheckHint;

  /// No description provided for @studyTaskKindTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get studyTaskKindTimer;

  /// No description provided for @studyTaskKindTimerHint.
  ///
  /// In en, this message translates to:
  /// **'A countdown runs on the locked screen. When it ends, the task is done.'**
  String get studyTaskKindTimerHint;

  /// No description provided for @studyTaskDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get studyTaskDurationLabel;

  /// No description provided for @studyTaskRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Extra time earned'**
  String get studyTaskRewardLabel;

  /// No description provided for @studyTaskSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get studyTaskSuggestions;

  /// No description provided for @studyTaskSuggestHomework.
  ///
  /// In en, this message translates to:
  /// **'Do homework'**
  String get studyTaskSuggestHomework;

  /// No description provided for @studyTaskSuggestReading.
  ///
  /// In en, this message translates to:
  /// **'Read a book'**
  String get studyTaskSuggestReading;

  /// No description provided for @studyTaskSuggestVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Learn English words'**
  String get studyTaskSuggestVocabulary;

  /// No description provided for @studyTaskSuggestWriting.
  ///
  /// In en, this message translates to:
  /// **'Handwriting practice'**
  String get studyTaskSuggestWriting;

  /// No description provided for @studyTaskSummaryCheck.
  ///
  /// In en, this message translates to:
  /// **'Parent approves · +{reward}'**
  String studyTaskSummaryCheck(String reward);

  /// No description provided for @studyTaskSummaryTimer.
  ///
  /// In en, this message translates to:
  /// **'{duration} timer · +{reward}'**
  String studyTaskSummaryTimer(String duration, String reward);

  /// No description provided for @studyTaskDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{task}”?'**
  String studyTaskDeleteTitle(String task);

  /// No description provided for @studyTaskDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Past history is kept.'**
  String get studyTaskDeleteBody;

  /// No description provided for @studyTaskDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get studyTaskDeleteConfirm;

  /// No description provided for @validationTaskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a task name.'**
  String get validationTaskTitleRequired;

  /// No description provided for @reportStudyTasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks yet} =1{1 task} other{{count} tasks}}'**
  String reportStudyTasksCount(int count);

  /// No description provided for @reportTaskDone.
  ///
  /// In en, this message translates to:
  /// **'Done: {task} · +{reward}'**
  String reportTaskDone(String task, String reward);

  /// No description provided for @reportSessionTasks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task done} other{{count} tasks done}}'**
  String reportSessionTasks(int count);

  /// No description provided for @reportNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No tasks or questions yet.'**
  String get reportNoActivity;

  /// No description provided for @childAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add a child'**
  String get childAddButton;

  /// No description provided for @childAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a child'**
  String get childAddTitle;

  /// No description provided for @pinEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter parent PIN'**
  String get pinEnterTitle;

  /// No description provided for @pinWrong.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Wrong PIN.} =1{Wrong PIN. 1 try left.} other{Wrong PIN. {count} tries left.}}'**
  String pinWrong(int count);

  /// No description provided for @pinLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries. Try again in {time}.'**
  String pinLocked(String time);

  /// No description provided for @pinUseDevice.
  ///
  /// In en, this message translates to:
  /// **'Use device passcode'**
  String get pinUseDevice;

  /// No description provided for @pinForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get pinForgot;

  /// No description provided for @pinForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot the PIN'**
  String get pinForgotTitle;

  /// No description provided for @pinForgotBody.
  ///
  /// In en, this message translates to:
  /// **'If you allowed the device passcode in the Parent area, tap “Use device passcode”.\n\nOtherwise the PIN can only be reset by uninstalling and reinstalling KidGuard, which deletes all KidGuard data on this device. This way your child can\'t reset it either.'**
  String get pinForgotBody;

  /// No description provided for @pinCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent PIN'**
  String get pinCreateTitle;

  /// No description provided for @pinChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get pinChangeTitle;

  /// No description provided for @pinCreatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Create a parent PIN'**
  String get pinCreatePrompt;

  /// No description provided for @pinCreateBody.
  ///
  /// In en, this message translates to:
  /// **'4–8 digits. Used to approve study tasks, take the device back and open the Parent area. Don\'t tell your child.'**
  String get pinCreateBody;

  /// No description provided for @pinConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get pinConfirmTitle;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs didn\'t match. Start again.'**
  String get pinMismatch;

  /// No description provided for @pinErrorLength.
  ///
  /// In en, this message translates to:
  /// **'The PIN must be 4–8 digits.'**
  String get pinErrorLength;

  /// No description provided for @pinErrorTooSimple.
  ///
  /// In en, this message translates to:
  /// **'Too easy to guess (like 1111 or 1234). Choose another.'**
  String get pinErrorTooSimple;

  /// No description provided for @pinCreated.
  ///
  /// In en, this message translates to:
  /// **'Parent PIN saved.'**
  String get pinCreated;

  /// No description provided for @authReasonCreatePin.
  ///
  /// In en, this message translates to:
  /// **'Confirm you\'re a parent to create the parent PIN'**
  String get authReasonCreatePin;

  /// No description provided for @authReasonChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change the parent PIN'**
  String get authReasonChangePin;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @securityPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent PIN'**
  String get securityPinTitle;

  /// No description provided for @securityPinChange.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get securityPinChange;

  /// No description provided for @securityDeviceAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Also allow device passcode / biometrics'**
  String get securityDeviceAuthTitle;

  /// No description provided for @securityDeviceAuthBody.
  ///
  /// In en, this message translates to:
  /// **'Only turn on if this is your device. On your child\'s own device, they know its passcode and could unlock KidGuard.'**
  String get securityDeviceAuthBody;

  /// No description provided for @homePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent PIN'**
  String get homePinTitle;

  /// No description provided for @homePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required — to approve tasks, take the device back and open the Parent area.'**
  String get homePinSubtitle;

  /// No description provided for @registerNeedsPin.
  ///
  /// In en, this message translates to:
  /// **'A parent needs to create a parent PIN first.'**
  String get registerNeedsPin;
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
