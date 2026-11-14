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
  /// **'Please choose your grade (1 – 12).'**
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

  /// No description provided for @authReasonDisableHardLock.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone password to turn off hard lock'**
  String get authReasonDisableHardLock;

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
  /// **'So the system doesn\'t stop the timer while your child uses other apps.'**
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

  /// No description provided for @homeHardLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Hard lock — optional, recommended'**
  String get homeHardLockTitle;

  /// No description provided for @homeHardLockOn.
  ///
  /// In en, this message translates to:
  /// **'On: your child can\'t leave the lock screen in any way.'**
  String get homeHardLockOn;

  /// No description provided for @homeHardLockOff.
  ///
  /// In en, this message translates to:
  /// **'Fully blocks the Home and Recents buttons and the notification bar while locked. Needs a computer, one-time setup.'**
  String get homeHardLockOff;

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
  /// **'Your child gets 15 minutes. When time is up, they answer 1 question for their grade: a right answer earns 5 more minutes, a wrong one locks the phone until a parent unlocks it.'**
  String get homeHeroBody;

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

  /// No description provided for @hardLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Hard lock'**
  String get hardLockTitle;

  /// No description provided for @hardLockDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off hard lock?'**
  String get hardLockDisableTitle;

  /// No description provided for @hardLockDisableBody.
  ///
  /// In en, this message translates to:
  /// **'KidGuard keeps working normally, but when the phone is locked your child can swipe the navigation bar (it\'s pulled back after ~1 second). You must turn off hard lock before uninstalling KidGuard.'**
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

  /// No description provided for @hardLockIntro.
  ///
  /// In en, this message translates to:
  /// **'One-time setup, takes about 10 minutes, needs a computer and a USB cable.'**
  String get hardLockIntro;

  /// No description provided for @hardLockStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Turn on Developer options'**
  String get hardLockStep1Title;

  /// No description provided for @hardLockStep1UsbDebugging.
  ///
  /// In en, this message translates to:
  /// **'Go to {location} › turn on \"USB debugging\".'**
  String hardLockStep1UsbDebugging(String location);

  /// No description provided for @hardLockStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Temporarily remove accounts & extra users'**
  String get hardLockStep2Title;

  /// No description provided for @hardLockStep2Accounts.
  ///
  /// In en, this message translates to:
  /// **'Android only allows hard lock when the phone has NO accounts. Go to Settings › Users & accounts (or \"Accounts\") and remove all of them: Google, manufacturer accounts (HeyTap/Oppo, Mi, Samsung…), and app accounts like Zalo, Telegram, WhatsApp if they are listed.'**
  String get hardLockStep2Accounts;

  /// No description provided for @hardLockStep2NoDataLoss.
  ///
  /// In en, this message translates to:
  /// **'No data is lost. Once step 4 is done you can sign back in right away.'**
  String get hardLockStep2NoDataLoss;

  /// No description provided for @hardLockStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Prepare the computer'**
  String get hardLockStep3Title;

  /// No description provided for @hardLockStep3Mac.
  ///
  /// In en, this message translates to:
  /// **'macOS: open Terminal and run the command below (requires Homebrew):'**
  String get hardLockStep3Mac;

  /// No description provided for @hardLockStep3Windows.
  ///
  /// In en, this message translates to:
  /// **'Windows: download \"SDK Platform-Tools for Windows\" from developer.android.com/tools/releases/platform-tools, unzip it, open the platform-tools folder, type \"cmd\" in the address bar and press Enter to open a command window.'**
  String get hardLockStep3Windows;

  /// No description provided for @hardLockStep3Plug.
  ///
  /// In en, this message translates to:
  /// **'Plug in the USB cable. When the phone shows \"Allow USB debugging?\" › check \"Always allow from this computer\" › Allow. If asked for a USB mode, choose \"File transfer\".'**
  String get hardLockStep3Plug;

  /// No description provided for @hardLockStep3Check.
  ///
  /// In en, this message translates to:
  /// **'Check the connection — you should see 1 line ending in \"device\":'**
  String get hardLockStep3Check;

  /// No description provided for @hardLockStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Turn on hard lock'**
  String get hardLockStep4Title;

  /// No description provided for @hardLockStep4Run.
  ///
  /// In en, this message translates to:
  /// **'Run the command:'**
  String get hardLockStep4Run;

  /// No description provided for @hardLockStep4Success.
  ///
  /// In en, this message translates to:
  /// **'It worked when you see \"Success: Device owner set to package com.pham.kidguard\". Go back to the app; the status above will turn green.'**
  String get hardLockStep4Success;

  /// No description provided for @hardLockStep4After.
  ///
  /// In en, this message translates to:
  /// **'You can now sign back in to your accounts, turn off \"USB debugging\" and unplug the cable.'**
  String get hardLockStep4After;

  /// No description provided for @hardLockTroubleTitle.
  ///
  /// In en, this message translates to:
  /// **'Having trouble?'**
  String get hardLockTroubleTitle;

  /// No description provided for @hardLockErrAccountsFix.
  ///
  /// In en, this message translates to:
  /// **'There are still accounts on the phone. Redo step 2 and carefully check app accounts too.'**
  String get hardLockErrAccountsFix;

  /// No description provided for @hardLockErrSecurityFix.
  ///
  /// In en, this message translates to:
  /// **'The phone is blocking commands over USB. Check \"USB debugging\" in Developer options again.'**
  String get hardLockErrSecurityFix;

  /// No description provided for @hardLockErrUnknownAdminFix.
  ///
  /// In en, this message translates to:
  /// **'KidGuard isn\'t installed on the phone, or the command was mistyped — use the copy button.'**
  String get hardLockErrUnknownAdminFix;

  /// No description provided for @hardLockErrNoDevice.
  ///
  /// In en, this message translates to:
  /// **'adb devices doesn\'t show the phone / \"unauthorized\"'**
  String get hardLockErrNoDevice;

  /// No description provided for @hardLockErrNoDeviceFix.
  ///
  /// In en, this message translates to:
  /// **'Unplug and replug the cable, unlock the phone screen and tap \"Allow\" in the USB debugging dialog. Try another cable (some cables only charge).'**
  String get hardLockErrNoDeviceFix;

  /// No description provided for @hardLockErrNoAdbFix.
  ///
  /// In en, this message translates to:
  /// **'platform-tools isn\'t installed (step 3). On Windows, you must open the command window inside the platform-tools folder.'**
  String get hardLockErrNoAdbFix;

  /// No description provided for @hardLockStatusOn.
  ///
  /// In en, this message translates to:
  /// **'Hard lock is ON'**
  String get hardLockStatusOn;

  /// No description provided for @hardLockStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Hard lock is off'**
  String get hardLockStatusOff;

  /// No description provided for @hardLockStatusOnBody.
  ///
  /// In en, this message translates to:
  /// **'When the phone is locked, your child can\'t press Home or Recents, pull down the notification bar, or force-stop the app. Only the phone password can unlock it.'**
  String get hardLockStatusOnBody;

  /// No description provided for @hardLockStatusOffBody.
  ///
  /// In en, this message translates to:
  /// **'Without hard lock, KidGuard still brings the lock screen back when your child leaves it, but they may see another screen for ~1 second and could open Settings to force-stop the app if they\'re quick enough. Hard lock blocks this completely.'**
  String get hardLockStatusOffBody;

  /// No description provided for @hardLockCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get hardLockCopy;

  /// No description provided for @hardLockCopied.
  ///
  /// In en, this message translates to:
  /// **'Command copied'**
  String get hardLockCopied;

  /// No description provided for @hardLockDevOppoEnable.
  ///
  /// In en, this message translates to:
  /// **'Settings › About device › Version › tap \"Build number\" 7 times in a row and enter the phone password.'**
  String get hardLockDevOppoEnable;

  /// No description provided for @hardLockDevLocationAdditional.
  ///
  /// In en, this message translates to:
  /// **'Settings › Additional settings › Developer options'**
  String get hardLockDevLocationAdditional;

  /// No description provided for @hardLockDevOppoUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove \"Second space\", \"App cloner\" and guest users (Settings › Apps › App cloner; Settings › Users & accounts).'**
  String get hardLockDevOppoUsers;

  /// No description provided for @hardLockDevOppoExtra.
  ///
  /// In en, this message translates to:
  /// **'Oppo/Realme only: in Developer options, also turn on \"Disable permission monitoring\". Without it, the command in step 4 will be rejected.'**
  String get hardLockDevOppoExtra;

  /// No description provided for @hardLockDevXiaomiEnable.
  ///
  /// In en, this message translates to:
  /// **'Settings › About phone › tap \"HyperOS/MIUI version\" 7 times in a row.'**
  String get hardLockDevXiaomiEnable;

  /// No description provided for @hardLockDevXiaomiUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove \"Second space\" and \"Dual apps\" (Settings › Apps › Dual apps).'**
  String get hardLockDevXiaomiUsers;

  /// No description provided for @hardLockDevXiaomiExtra.
  ///
  /// In en, this message translates to:
  /// **'Xiaomi only: also turn on \"USB debugging (Security settings)\" — this requires a SIM card and a signed-in Mi account; turn it on first, then remove accounts in step 2.'**
  String get hardLockDevXiaomiExtra;

  /// No description provided for @hardLockDevVivoEnable.
  ///
  /// In en, this message translates to:
  /// **'Settings › System › About › Software information › tap \"Software version\" 7 times in a row.'**
  String get hardLockDevVivoEnable;

  /// No description provided for @hardLockDevLocationSystem.
  ///
  /// In en, this message translates to:
  /// **'Settings › System › Developer options'**
  String get hardLockDevLocationSystem;

  /// No description provided for @hardLockDevVivoUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove \"App clone\" and guest users.'**
  String get hardLockDevVivoUsers;

  /// No description provided for @hardLockDevSamsungEnable.
  ///
  /// In en, this message translates to:
  /// **'Settings › About phone › Software information › tap \"Build number\" 7 times in a row.'**
  String get hardLockDevSamsungEnable;

  /// No description provided for @hardLockDevSamsungLocation.
  ///
  /// In en, this message translates to:
  /// **'Settings › Developer options (at the bottom of the list)'**
  String get hardLockDevSamsungLocation;

  /// No description provided for @hardLockDevSamsungUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove \"Secure Folder\" and \"Dual Messenger\" if present.'**
  String get hardLockDevSamsungUsers;

  /// No description provided for @hardLockDevGenericEnable.
  ///
  /// In en, this message translates to:
  /// **'Settings › About phone › tap \"Build number\" 7 times in a row.'**
  String get hardLockDevGenericEnable;

  /// No description provided for @hardLockDevHuaweiLocation.
  ///
  /// In en, this message translates to:
  /// **'Settings › System & updates › Developer options'**
  String get hardLockDevHuaweiLocation;

  /// No description provided for @hardLockDevHuaweiUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove \"PrivateSpace\", \"App Twin\" and guest users.'**
  String get hardLockDevHuaweiUsers;

  /// No description provided for @hardLockDevOtherUsers.
  ///
  /// In en, this message translates to:
  /// **'Remove guest users, work profiles and cloned apps if any.'**
  String get hardLockDevOtherUsers;

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
  /// **'Fill in your details to use the phone for 15 minutes.'**
  String get registerIntro;

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
  /// **'What grade are you in?'**
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
  /// **'Grade {grade}'**
  String runningGrade(int grade);

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
  /// **'Grade {grade} · {age, plural, =1{1 year old} other{{age} years old}}'**
  String dashboardChildInfo(int grade, int age);

  /// No description provided for @reportChildInfo.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade} · Born {dob}'**
  String reportChildInfo(int grade, String dob);

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
