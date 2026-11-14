package com.pham.kidguard

import android.app.admin.DeviceAdminReceiver

/** Chỉ dùng khi app được đặt làm Device Owner để bật lock task không cần xác nhận. */
class KidGuardAdminReceiver : DeviceAdminReceiver()
