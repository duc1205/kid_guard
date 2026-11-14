package com.pham.kidguard

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Khởi động lại dịch vụ giám sát sau khi máy reboot nếu phiên vẫn chưa được người lớn thu hồi. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_LOCKED_BOOT_COMPLETED
        ) return
        if (GuardState.load(context).active) {
            try {
                SessionGuardService.start(context)
            } catch (_: Exception) {
            }
        }
    }
}
