# KidGuard Privacy Policy

Last updated: 2026-11-16

KidGuard is a parental screen-time app. A parent sets it up on a device their child uses. When the allowed time ends, the child answers a knowledge question to continue, or the device is locked until a parent unlocks it with the device passcode or biometrics.

## Who this app is for

KidGuard is intended for **parents or guardians**. Children use the app only after a parent has set it up and consented on this device.

## Data we store

All of the following stay **on this device** (local storage / SQLite). KidGuard does **not** create user accounts and does **not** upload child profiles or usage logs to our servers.

- Child display name, date of birth, and grade/level (to pick suitable questions and show parent reports)
- Session and answer history (screen time, correct/wrong answers, topics missed)
- App settings (for example initial allowance) and setup checklist confirmations
- Cached question bank files downloaded over HTTPS

Answer history older than 180 days is deleted automatically on the device.

Parents can also delete data in the app (Parent area, after device passcode or biometrics):

- Delete one child: removes that child’s profile and usage history on this device
- Delete all child data: removes every child profile and usage history on this device

These actions do not remove the cached question bank or parental-control settings such as the initial screen-time allowance. Uninstalling KidGuard also removes local app data on the device.

## Network use

The app may download question files from a HTTPS URL (default: the public KidGuard question repository, or another HTTPS source a parent chooses). That request does **not** include the child’s name, date of birth, or usage history.

## Permissions (by platform)

Permissions are used only for parental control on this device, for example:

- Android: overlay, notifications, foreground service, optional Accessibility for stronger lock; parents may set battery to unrestricted in system settings
- iOS: Screen Time / Family Controls to block selected apps when time is up (child Apple ID in Family Sharing preferred; parent’s phone lent to a child also supported with a weaker lock); Face ID / passcode for parent unlock
- macOS / Windows: full-screen lock / kiosk behavior; device passcode or Windows Hello for parent unlock

KidGuard does not use Accessibility or Screen Time to read message content, keystrokes, or to sell data.

## Children’s privacy

We do not knowingly sell children’s personal information. Child data is collected only for the parental-control features described above and remains on the device unless the parent exports or backs up the device by other means outside this app.

## Contact

For privacy questions about KidGuard, open an issue on the project repository:  
https://github.com/duc1205/kid_guard

## Changes

We may update this policy when the app’s data practices change. The “Last updated” date at the top will change accordingly.
