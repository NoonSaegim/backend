package com.noonsaegim.frontend;

import io.flutter.embedding.android.FlutterActivity;
import android.app.KeyguardManager;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true);
            setTurnScreenOn(true);
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
        } else {
            getWindow().addFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED    // deprecated api 27
                            | WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD     // deprecated api 26
                            | WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON   // deprecated api 27
                            | WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
            );
        }
        KeyguardManager keyguardManager = (KeyguardManager) getSystemService(Context.KEYGUARD_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            keyguardManager.requestDismissKeyguard(this, null);
        }
    }
}
