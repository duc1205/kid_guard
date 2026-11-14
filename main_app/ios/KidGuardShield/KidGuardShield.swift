import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Giao diện lá chắn khi bé mở app bị chặn: nhắc mở KidGuard để trả lời câu hỏi.
class KidGuardShield: ShieldConfigurationDataSource {
  private var vi: Bool { Locale.preferredLanguages.first?.hasPrefix("vi") ?? false }

  private func make() -> ShieldConfiguration {
    ShieldConfiguration(
      backgroundBlurStyle: .systemThickMaterial,
      backgroundColor: UIColor(red: 0.31, green: 0.42, blue: 0.93, alpha: 1),
      icon: UIImage(systemName: "alarm.fill"),
      title: ShieldConfiguration.Label(
        text: vi ? "Hết giờ rồi!" : "Time's up!", color: .white),
      subtitle: ShieldConfiguration.Label(
        text: vi
          ? "Mở KidGuard và trả lời 1 câu hỏi để được dùng thêm 5 phút."
          : "Open KidGuard and answer a question to get 5 more minutes.",
        color: .white),
      primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
      primaryButtonBackgroundColor: UIColor(red: 1.0, green: 0.62, blue: 0.26, alpha: 1))
  }

  override func configuration(shielding application: Application) -> ShieldConfiguration { make() }

  override func configuration(
    shielding application: Application, in category: ActivityCategory
  ) -> ShieldConfiguration { make() }

  override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration { make() }

  override func configuration(
    shielding webDomain: WebDomain, in category: ActivityCategory
  ) -> ShieldConfiguration { make() }
}
