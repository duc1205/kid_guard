import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

/// Dùng chung giữa app KidGuard và extension DeviceActivityMonitor (qua App Group).
enum KidGuardShared {
  static let appGroup = "group.com.pham.kidguard"
  static let activity = DeviceActivityName("kidguard.session")

  private static let selectionKey = "kg.selection"
  private static let guardKey = "kg.guard"

  static var defaults: UserDefaults {
    UserDefaults(suiteName: appGroup) ?? .standard
  }

  static var store: ManagedSettingsStore {
    ManagedSettingsStore(named: ManagedSettingsStore.Name("kidguard"))
  }

  /// Các app / nhóm app / trang web người lớn đã chọn để chặn khi hết giờ.
  static func loadSelection() -> FamilyActivitySelection {
    guard let data = defaults.data(forKey: selectionKey),
          let sel = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else { return FamilyActivitySelection() }
    return sel
  }

  static func saveSelection(_ selection: FamilyActivitySelection) {
    if let data = try? JSONEncoder().encode(selection) {
      defaults.set(data, forKey: selectionKey)
    }
  }

  static func hasSelection(_ s: FamilyActivitySelection = loadSelection()) -> Bool {
    !s.applicationTokens.isEmpty || !s.categoryTokens.isEmpty || !s.webDomainTokens.isEmpty
  }

  /// Bật lá chắn Screen Time cho các mục đã chọn.
  static func applyShield() {
    let s = loadSelection()
    let store = store
    store.shield.applications = s.applicationTokens.isEmpty ? nil : s.applicationTokens
    store.shield.applicationCategories =
      s.categoryTokens.isEmpty ? nil : .specific(s.categoryTokens)
    store.shield.webDomains = s.webDomainTokens.isEmpty ? nil : s.webDomainTokens
    store.shield.webDomainCategories =
      s.categoryTokens.isEmpty ? nil : .specific(s.categoryTokens)
    defaults.set(true, forKey: guardKey)
  }

  static func clearShield() {
    store.clearAllSettings()
    defaults.set(false, forKey: guardKey)
  }
}
