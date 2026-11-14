package com.pham.kidguard

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Color
import android.graphics.PixelFormat
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.util.TypedValue
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat

/**
 * Foreground service giữ "đồng hồ" của phiên dùng máy, kể cả khi app Flutter bị đẩy xuống nền
 * hoặc bị vuốt khỏi danh sách đa nhiệm.
 *
 * - Khi hết giờ: bật guard và đưa MainActivity lên trên cùng (màn câu hỏi).
 * - Khi guard bật (đang hỏi / đang khoá): nếu MainActivity không ở foreground thì mở lại ngay,
 *   nên trẻ không thể thoát ra ứng dụng khác.
 * - Một số ROM (ColorOS/MIUI…) vẫn chặn mở Activity từ nền dù đã có quyền "Hiển thị trên ứng
 *   dụng khác" (log: `checkBackgroundActivityPermission deny!`). Vì vậy khi guard bật mà app không
 *   ở trên cùng, service phủ một cửa sổ overlay toàn màn hình: chặn mọi thao tác với app bên dưới
 *   và có nút mở màn câu hỏi (bấm nút = thao tác của người dùng trên cửa sổ của app → được phép mở).
 */
class SessionGuardService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var lastRelaunchAt = 0L
    private var overlay: View? = null

    /** Đang giữ audio focus để buộc app khác (YouTube, kể cả cửa sổ PiP) dừng phát. */
    private var holdingAudio = false
    private var focusRequest: AudioFocusRequest? = null
    private val focusListener = AudioManager.OnAudioFocusChangeListener { change ->
        // App khác giành lại focus (trẻ bấm Play) → tick sau sẽ giành lại và dừng tiếp.
        if (change == AudioManager.AUDIOFOCUS_LOSS ||
            change == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT ||
            change == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK
        ) {
            holdingAudio = false
        }
    }

    private val tick = object : Runnable {
        override fun run() {
            onTick()
            handler.postDelayed(this, TICK_MS)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startAsForeground()
        handler.removeCallbacks(tick)
        handler.post(tick)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        hideOverlay()
        releaseAudio()
        if (instance === this) instance = null
        super.onDestroy()
    }

    private fun onTick() {
        val state = GuardState.load(this)
        if (!state.active) {
            hideOverlay()
            releaseAudio()
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
        if (guard && !state.suspended) silenceOtherMedia() else releaseAudio()
        val mustCover = guard && !state.suspended && !MainActivity.isForeground
        if (mustCover) showOverlay() else hideOverlay()
        if (mustCover && now - lastRelaunchAt > RELAUNCH_THROTTLE_MS) {
            lastRelaunchAt = now
            bringAppToFront()
        }
    }

    /** Gọi từ MainActivity khi vào/ra foreground để ẩn/hiện overlay ngay, không chờ tick. */
    fun syncOverlay() {
        val state = GuardState.load(this)
        if (state.active && state.guard && !state.suspended && !MainActivity.isForeground) {
            showOverlay()
        } else {
            hideOverlay()
        }
    }

    /**
     * Hết giờ / bị khoá: giành audio focus (app media chuẩn như YouTube, Spotify… sẽ tự dừng)
     * và gửi phím Pause tới phiên media đang phát cho app không tôn trọng audio focus.
     */
    private fun silenceOtherMedia() {
        if (holdingAudio) return
        val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val granted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val req = focusRequest ?: AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                .setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MOVIE)
                        .build()
                )
                .setWillPauseWhenDucked(false)
                .setOnAudioFocusChangeListener(focusListener, handler)
                .build()
                .also { focusRequest = it }
            am.requestAudioFocus(req)
        } else {
            @Suppress("DEPRECATION")
            am.requestAudioFocus(focusListener, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)
        }
        holdingAudio = granted == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        try {
            am.dispatchMediaKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PAUSE))
            am.dispatchMediaKeyEvent(KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_MEDIA_PAUSE))
        } catch (_: Exception) {
        }
    }

    private fun releaseAudio() {
        if (!holdingAudio && focusRequest == null) return
        val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            focusRequest?.let { am.abandonAudioFocusRequest(it) }
        } else {
            @Suppress("DEPRECATION")
            am.abandonAudioFocus(focusListener)
        }
        focusRequest = null
        holdingAudio = false
    }

    private fun showOverlay() {
        if (overlay != null) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) return
        val wm = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val dp = { v: Int ->
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v.toFloat(), resources.displayMetrics).toInt()
        }
        val root = object : LinearLayout(this) {
            // Nuốt phím Back để không đóng được overlay.
            override fun dispatchKeyEvent(event: KeyEvent): Boolean =
                if (event.keyCode == KeyEvent.KEYCODE_BACK) true else super.dispatchKeyEvent(event)
        }.apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(Color.parseColor("#F2F5FB"))
            setPadding(dp(32), dp(32), dp(32), dp(32))
            isClickable = true
            isFocusable = true
            isFocusableInTouchMode = true
            setOnClickListener { bringAppToFront() }
        }
        root.addView(TextView(this).apply {
            text = getString(R.string.notif_time_up_title)
            setTextColor(Color.parseColor("#E5484D"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 28f)
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            gravity = Gravity.CENTER
        })
        root.addView(TextView(this).apply {
            text = getString(R.string.notif_time_up_text)
            setTextColor(Color.parseColor("#333A45"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 17f)
            gravity = Gravity.CENTER
            setPadding(0, dp(12), 0, dp(28))
        })
        root.addView(Button(this).apply {
            text = getString(R.string.overlay_open_quiz)
            isAllCaps = false
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
            setOnClickListener { bringAppToFront() }
        }, LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(56)))

        @Suppress("DEPRECATION")
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            WindowManager.LayoutParams.TYPE_PHONE
        }
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            type,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
            PixelFormat.OPAQUE
        ).apply { gravity = Gravity.TOP or Gravity.START }
        try {
            wm.addView(root, params)
            overlay = root
            root.requestFocus()
        } catch (_: Exception) {
        }
    }

    private fun hideOverlay() {
        val v = overlay ?: return
        overlay = null
        try {
            (getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(v)
        } catch (_: Exception) {
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

        @Volatile
        var instance: SessionGuardService? = null

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
