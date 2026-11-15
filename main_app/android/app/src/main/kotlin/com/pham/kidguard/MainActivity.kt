package com.pham.kidguard

import android.Manifest
import android.app.ActivityManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "startTimer" -> {
                        val deadline = (call.argument<Number>("endsAtMillis") ?: 0).toLong()
                        GuardState.save(this, GuardState(active = true, deadline = deadline, guard = false, suspended = false))
                        SessionGuardService.start(this)
                        result.success(null)
                    }
                    "setGuard" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        val s = GuardState.load(this)
                        GuardState.save(this, s.copy(guard = enabled, suspended = false))
                        if (enabled) enterLockTaskIfOwner() else exitLockTask()
                        SessionGuardService.instance?.syncOverlay()
                        result.success(null)
                    }
                    "suspendGuard" -> {
                        val suspended = call.argument<Boolean>("suspended") ?: false
                        val s = GuardState.load(this).copy(suspended = suspended)
                        GuardState.save(this, s)
                        // Thoát lock task tạm thời để màn nhập mật khẩu của hệ thống
                        // (Android ≤10 là Activity của Settings) không bị chặn.
                        if (suspended) exitLockTask() else if (s.active && s.guard) enterLockTaskIfOwner()
                        SessionGuardService.instance?.syncOverlay()
                        result.success(null)
                    }
                    "stop" -> {
                        GuardState.clear(this)
                        SessionGuardService.stop(this)
                        exitLockTask()
                        result.success(null)
                    }
                    "moveToBackground" -> {
                        moveTaskToBack(true)
                        result.success(null)
                    }
                    "permissionStatus" -> result.success(
                        mapOf(
                            "overlay" to canDrawOverlays(),
                            "notifications" to hasNotificationPermission(),
                            "deviceOwner" to isDeviceOwner(),
                            "accessibility" to isAccessibilityEnabled(),
                            "sdkInt" to Build.VERSION.SDK_INT,
                            "batteryUnrestricted" to isIgnoringBatteryOptimizations(),
                            "manufacturer" to Build.MANUFACTURER.lowercase(),
                        )
                    )
                    "requestIgnoreBatteryOptimizations" -> {
                        if (!isIgnoringBatteryOptimizations()) {
                            tryStart(
                                Intent(
                                    Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                                    Uri.parse("package:$packageName")
                                )
                            ) || openAppDetails()
                        }
                        result.success(null)
                    }
                    // Trả về true nếu mở được đúng màn "Tự khởi động" của hãng, false nếu phải mở trang thông tin app.
                    "openAutoStartSettings" -> {
                        val opened = AUTO_START_COMPONENTS.any { tryStart(Intent().setComponent(it)) }
                        if (!opened) openAppDetails()
                        result.success(opened)
                    }
                    // Xiaomi/Vivo có thêm quyền "Hiển thị cửa sổ bật lên khi chạy trong nền".
                    "openBackgroundPopupSettings" -> {
                        val opened = backgroundPopupIntents().any { tryStart(it) }
                        if (!opened) openAppDetails()
                        result.success(opened)
                    }
                    "openAppSettings" -> result.success(openAppDetails())
                    // Mở danh sách Trợ năng. (Trang chi tiết ACCESSIBILITY_DETAILS_SETTINGS cần quyền
                    // OPEN_ACCESSIBILITY_DETAILS_SETTINGS chỉ dành cho app hệ thống → luôn bị từ chối.)
                    "openAccessibilitySettings" -> {
                        tryStart(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                        result.success(null)
                    }
                    // Gỡ quyền Device Owner (bắt buộc trước khi gỡ cài đặt app).
                    "clearDeviceOwner" -> {
                        if (isDeviceOwner()) {
                            exitLockTask()
                            val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                            dpm.setLockTaskPackages(ComponentName(this, KidGuardAdminReceiver::class.java), arrayOf())
                            @Suppress("DEPRECATION")
                            dpm.clearDeviceOwnerApp(packageName)
                        }
                        result.success(!isDeviceOwner())
                    }
                    "requestOverlayPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !canDrawOverlays()) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                    Uri.parse("package:$packageName")
                                )
                            )
                        }
                        result.success(null)
                    }
                    "requestNotificationPermission" -> {
                        if (Build.VERSION.SDK_INT >= 33 && !hasNotificationPermission()) {
                            ActivityCompat.requestPermissions(
                                this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1
                            )
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("device_control", e.message, null)
            }
        }
    }

    override fun onStart() {
        super.onStart()
        isForeground = true
        SessionGuardService.instance?.syncOverlay()
    }

    override fun onStop() {
        isForeground = false
        SessionGuardService.instance?.syncOverlay()
        super.onStop()
    }

    private fun tryStart(intent: Intent): Boolean = try {
        startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        true
    } catch (_: Exception) {
        false
    }

    private fun backgroundPopupIntents(): List<Intent> = listOf(
        // Xiaomi (MIUI / HyperOS): trang "Quyền khác" của app
        Intent("miui.intent.action.APP_PERM_EDITOR")
            .setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity")
            .putExtra("extra_pkgname", packageName),
        Intent("miui.intent.action.APP_PERM_EDITOR")
            .setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.AppPermissionsEditorActivity")
            .putExtra("extra_pkgname", packageName),
        // Vivo / iQOO
        Intent().setClassName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.SoftPermissionDetailActivity")
            .putExtra("packagename", packageName),
        Intent("permission.intent.action.softPermissionDetail")
            .putExtra("packagename", packageName),
    )

    private fun openAppDetails(): Boolean = tryStart(
        Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName"))
    )

    private fun isIgnoringBatteryOptimizations(): Boolean {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        return pm.isIgnoringBatteryOptimizations(packageName)
    }

    private fun canDrawOverlays(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)

    private fun hasNotificationPermission(): Boolean =
        Build.VERSION.SDK_INT < 33 ||
            ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED

    private fun isAccessibilityEnabled(): Boolean {
        val enabled = Settings.Secure.getString(
            contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false
        val component = ComponentName(this, KidGuardAccessibilityService::class.java)
        return enabled.split(':').any {
            ComponentName.unflattenFromString(it) == component
        }
    }

    private fun isDeviceOwner(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        return dpm.isDeviceOwnerApp(packageName)
    }

    /** Lock task chỉ bật khi là Device Owner (không hiện hộp thoại "ghim màn hình" cho trẻ bấm huỷ). */
    private fun enterLockTaskIfOwner() {
        if (!isDeviceOwner()) return
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        dpm.setLockTaskPackages(ComponentName(this, KidGuardAdminReceiver::class.java), arrayOf(packageName))
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        if (am.lockTaskModeState == ActivityManager.LOCK_TASK_MODE_NONE) startLockTask()
    }

    private fun exitLockTask() {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        if (am.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE) {
            try {
                stopLockTask()
            } catch (_: Exception) {
            }
        }
    }

    companion object {
        private const val CHANNEL = "kidguard/device_control"

        /** Màn hình "Tự khởi động" của các hãng (thử lần lượt, cái nào mở được thì dùng). */
        private val AUTO_START_COMPONENTS = listOf(
            // Oppo / Realme / OnePlus (ColorOS)
            ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity"),
            ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity"),
            ComponentName("com.oplus.safecenter", "com.oplus.safecenter.permission.startup.StartupAppListActivity"),
            ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity"),
            // Xiaomi
            ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity"),
            // Vivo
            ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"),
            ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager"),
            // Huawei / Honor
            ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
            ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity"),
            ComponentName("com.hihonor.systemmanager", "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
            // Samsung: không có "Tự khởi động" → mở màn Pin của Device Care
            ComponentName("com.samsung.android.lool", "com.samsung.android.sm.battery.ui.BatteryActivity"),
        )

        @Volatile
        var isForeground: Boolean = false
    }
}
