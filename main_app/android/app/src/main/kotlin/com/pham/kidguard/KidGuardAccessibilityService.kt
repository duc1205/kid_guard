package com.pham.kidguard

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.os.Build
import android.os.SystemClock
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent

/**
 * "Khoá nâng cao": người lớn bật trong Cài đặt › Trợ năng, không cần máy tính.
 *
 * Chỉ dùng để biết ứng dụng nào đang ở trên cùng; không đọc, không lưu, không gửi
 * nội dung màn hình đi đâu. Chỉ phản ứng khi có phiên đang chạy:
 * - Hết giờ / đang khoá: đóng thanh thông báo, chặn đa nhiệm / màn hình chính /
 *   app khác bằng cách đưa KidGuard lên lại ngay (nhanh hơn vòng 1 giây của service).
 * - Suốt phiên (kể cả lúc bé đang được dùng máy): chặn mở trang cài đặt / gỡ cài đặt
 *   của KidGuard để bé không tắt được KidGuard. Người lớn thu hồi máy xong là hết chặn.
 */
class KidGuardAccessibilityService : AccessibilityService() {

    private var lastFrontAt = 0L
    private var lastSettingsCheckAt = 0L

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val pkg = event?.packageName?.toString() ?: return
        if (pkg == packageName) return
        val state = GuardState.load(this)
        if (!state.active || state.suspended) return
        val guarded = state.guard ||
            (state.deadline > 0 && System.currentTimeMillis() >= state.deadline)

        if (pkg in SETTINGS_PACKAGES && showsKidGuard(event)) {
            performGlobalAction(GLOBAL_ACTION_BACK)
            if (guarded) bringAppToFront()
            return
        }
        if (!guarded || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        if (isAllowedWhileGuarded(pkg)) return

        if (pkg == SYSTEM_UI) {
            dismissNotificationShade()
            return
        }
        bringAppToFront()
    }

    override fun onInterrupt() {}

    /** Trang cài đặt / hộp thoại gỡ cài đặt có nhắc tới KidGuard. */
    private fun showsKidGuard(event: AccessibilityEvent): Boolean {
        val now = SystemClock.uptimeMillis()
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED &&
            now - lastSettingsCheckAt < SETTINGS_CHECK_THROTTLE_MS
        ) return false
        lastSettingsCheckAt = now
        val root = rootInActiveWindow ?: return false
        return try {
            root.findAccessibilityNodeInfosByText(getString(R.string.app_name)).isNotEmpty()
        } catch (_: Exception) {
            false
        }
    }

    /** Cuộc gọi đến / gọi khẩn cấp và bàn phím vẫn được dùng khi bị khoá. */
    private fun isAllowedWhileGuarded(pkg: String): Boolean {
        if (pkg.contains("incallui") || pkg in CALL_PACKAGES) return true
        val ime = Settings.Secure.getString(contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD)
        return ime != null && ime.substringBefore('/') == pkg
    }

    private fun dismissNotificationShade() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            performGlobalAction(GLOBAL_ACTION_DISMISS_NOTIFICATION_SHADE)
        } else {
            try {
                @Suppress("WrongConstant")
                val sbm = getSystemService("statusbar")
                sbm?.javaClass?.getMethod("collapsePanels")?.invoke(sbm)
            } catch (_: Exception) {
                performGlobalAction(GLOBAL_ACTION_BACK)
            }
        }
    }

    private fun bringAppToFront() {
        val now = SystemClock.uptimeMillis()
        if (now - lastFrontAt < FRONT_THROTTLE_MS) return
        lastFrontAt = now
        try {
            startActivity(
                Intent(this, MainActivity::class.java).addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
            )
        } catch (_: Exception) {
            // Lớp che toàn màn hình của SessionGuardService vẫn chặn thao tác.
        }
    }

    companion object {
        private const val SYSTEM_UI = "com.android.systemui"
        private const val FRONT_THROTTLE_MS = 300L
        private const val SETTINGS_CHECK_THROTTLE_MS = 400L

        /** Cài đặt / trình gỡ cài đặt của Android và các hãng. */
        private val SETTINGS_PACKAGES = setOf(
            "com.android.settings",
            "com.coloros.settings",
            "com.oplus.settings",
            "com.miui.securitycenter",
            "com.android.packageinstaller",
            "com.google.android.packageinstaller",
            "com.samsung.android.packageinstaller",
            "com.oplus.appdetail",
            "com.coloros.safecenter",
        )

        private val CALL_PACKAGES = setOf(
            "com.android.server.telecom",
            "com.android.phone",
        )
    }
}
