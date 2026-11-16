# KidGuard Privacy Policy

Last updated: 2026-11-16

KidGuard is a parental screen-time app. A parent sets it up on a device their child uses. When the allowed time ends, the child finishes a study task the parent set (for example homework or reading for 20 minutes) or answers a knowledge question to get more time. A wrong answer locks the device until a parent unlocks it with the parent PIN.

## Who this app is for

KidGuard is intended for **parents or guardians**. Children use the app only after a parent has set it up and consented on this device.

## Data we store

All of the following stay **on this device** (local storage / SQLite). KidGuard does **not** create user accounts and does **not** upload child profiles or usage logs to our servers.

- Child display name, date of birth, and grade/level (for study tasks, suitable questions and parent reports)
- Study tasks the parent sets for each child (task name, how it is checked, duration and extra time earned)
- Session history (screen time, completed study tasks, correct/wrong answers, topics missed)
- Parent PIN, stored only as a salted one-way hash (PBKDF2-HMAC-SHA256), plus a counter of recent wrong attempts. The PIN itself is never stored.
- App settings (for example initial allowance) and setup checklist confirmations
- Cached question bank files downloaded over HTTPS

Session history (completed tasks and answers) older than 180 days is deleted automatically on the device.

Parents can also delete data in the app (Parent area, after entering the parent PIN):

- Delete one child: removes that child’s profile, study tasks and usage history on this device
- Delete all child data: removes every child profile, study task and usage history on this device

These actions do not remove the cached question bank or parental-control settings such as the initial screen-time allowance and the parent PIN. Uninstalling KidGuard also removes local app data on the device.

## Network use

The app may download question files from a HTTPS URL (default: the public KidGuard question repository, or another HTTPS source a parent chooses). That request does **not** include the child’s name, date of birth, or usage history.

## Permissions (by platform)

Permissions are used only for parental control on this device, for example:

- Android: overlay, notifications, foreground service, optional Accessibility for stronger lock; parents may set battery to unrestricted in system settings
- iOS: Screen Time / Family Controls to block selected apps when time is up (child Apple ID in Family Sharing preferred; parent’s phone lent to a child also supported with a weaker lock)
- macOS / Windows: full-screen lock / kiosk behavior
- All platforms: parents unlock with the KidGuard parent PIN. Optionally, a parent can also allow the device passcode or biometrics (Face ID, Touch ID, fingerprint, Windows Hello). KidGuard only receives a yes/no result from the system and never sees the passcode or biometric data.

KidGuard does not use Accessibility or Screen Time to read message content, keystrokes, or to sell data.

## Children’s privacy

We do not knowingly sell children’s personal information. Child data is collected only for the parental-control features described above and remains on the device unless the parent exports or backs up the device by other means outside this app.

## Contact

For privacy questions about KidGuard, open an issue on the project repository:  
https://github.com/duc1205/kid_guard

## Changes

We may update this policy when the app’s data practices change. The “Last updated” date at the top will change accordingly.
