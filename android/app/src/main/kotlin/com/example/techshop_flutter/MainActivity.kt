package com.example.techshop_flutter

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import vn.zalopay.sdk.ZaloPaySDK
import vn.zalopay.sdk.listeners.PayOrderListener
import vn.zalopay.sdk.ZaloPayError
import vn.zalopay.sdk.Environment;

class MainActivity : FlutterActivity() {
    private val CHANNEL = "zalopay_sdk"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ZaloPaySDK.init(2553, Environment.SANDBOX)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "payOrder") {
                val token: String? = call.argument("token")
                ZaloPaySDK.init(2553, Environment.SANDBOX)
                if (token != null) {
                    ZaloPaySDK.getInstance()
                        .payOrder(this, token, "demozpdk://app", object : PayOrderListener {
                            override fun onPaymentSucceeded(p1: String?, p2: String?, p3: String?) {
                                result.success("Thanh toán thành công")

                            }

                            override fun onPaymentCanceled(p1: String?, p2: String?) {
                                result.success("Hủy thanh toán")
                            }

                            override fun onPaymentError(
                                error: ZaloPayError,
                                p1: String?,
                                p2: String?
                            ) {
                                result.success("Lỗi thanh toán: ${error.toString()}")
                            }

                        })
                } else {
                    result.error("INVALID_ARGUMENT", "Token không hợp lệ", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        ZaloPaySDK.getInstance().onResult(intent)
    }
}