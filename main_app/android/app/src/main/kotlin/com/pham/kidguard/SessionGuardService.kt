package com.pham.kidguard

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat

/**
 * Foreground service giữ "đồng hồ" của phiên dùng máy, kể cả khi app Flutter bị đẩy xuống nền
 * hoặc bị vuốt khỏi danh sách đa nhiệm.
 *
 * - Khi hết giờ: bật guard và đưa MainActivity lên trên cùng (màn câu hỏi).
 * - Khi guard bật (đang hỏi / đang khoá): nếu MainActivity không ở foreground thì mở lại ngay,
 *   nên trẻ không thể thoát ra ứng dụng khác.
 */
class SessionGuardService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var lastRelaunchAt = 0L

    private val tick = object : Runnable {
        override fun run() {
            onTick()
            handler.postDelayed(this, TICK_MS)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startAsForeground()
        handler.removeCallbacks(tick)
        handler.post(tick)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        super.onDestroy()
    }

    private fun onTick() {
        val state = GuardState.load(this)
        if (!state.active) {
            stopSelf()
            return
        }
        val now = System.currentTimeMillis()
        var guard = state.guard
        if (!guard && state.deadline in 1..now) {
            guard = true
            GuardState.save(this, state.copy(guard = true))
            refreshNotification()
        }
        if (guard && !state.suspended && !MainActivity.isForeground &&
            now - lastRelaunchAt > RELAUNCH_THROTTLE_MS
        ) {
            lastRelaunchAt = now
            bringAppToFront()
        }
    }

    private fun bringAppToFront() {
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            )
        }
        try {
            startActivity(intent)
        } catch (_: Exception) {
            // Thiếu quyền "Hiển thị trên ứng dụng khác" -> notification full-screen vẫn nhắc trẻ.
        }
    }

    private fun startAsForeground() {
        val notification = buildNotification()
        ServiceCompat.startForeground(
            this,
            NOTIFICATION_ID,
            notification,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
            } else {
                0
            }
        )
    }

    private fun refreshNotification() {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIFICATION_ID, buildNotification())
    }

    private fun buildNotification(): android.app.Notification {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            nm.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, getString(R.string.notif_channel_name), NotificationManager.IMPORTANCE_LOW)
            )
        }
        val state = GuardState.load(this)
        val openApp = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(openApp)
        if (state.guard) {
            builder.setContentTitle(getString(R.string.notif_time_up_title))
                .setContentText(getString(R.string.notif_time_up_text))
        } else {
            builder.setContentTitle(getString(R.string.notif_running_title))
                .setContentText(getString(R.string.notif_running_text))
                .setUsesChronometer(true)
                .setChronometerCountDown(true)
                .setWhen(state.deadline)
                .setShowWhen(true)
        }
        return builder.build()
    }

    companion object {
        private const val CHANNEL_ID = "kidguard_session"
        private const val NOTIFICATION_ID = 1501
        private const val TICK_MS = 1000L
        private const val RELAUNCH_THROTTLE_MS = 800L

        fun start(context: Context) {
            val intent = Intent(context, SessionGuardService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            context.stopService(Intent(context, SessionGuardService::class.java))
        }
    }
}

/** Trạng thái phía native, lưu vào SharedPreferences để sống sót khi process bị kill. */
data class GuardState(
    val active: Boolean,
    val deadline: Long,
    val guard: Boolean,
    val suspended: Boolean,
) {
    companion object {
        private const val PREFS = "kidguard_native"

        fun load(context: Context): GuardState {
            val p = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            return GuardState(
                active = p.getBoolean("active", false),
                deadline = p.getLong("deadline", 0L),
                guard = p.getBoolean("guard", false),
                suspended = p.getBoolean("suspended", false),
            )
        }

        fun save(context: Context, s: GuardState) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putBoolean("active", s.active)
                .putLong("deadline", s.deadline)
                .putBoolean("guard", s.guard)
                .putBoolean("suspended", s.suspended)
                .commit()
        }

        fun clear(context: Context) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().clear().commit()
        }
    }
}
