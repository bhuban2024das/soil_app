package com.devsecit.dsi_pro;
import static android.content.Intent.getIntent;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@NonNull Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Check if the app was opened via the custom URI scheme
        Intent intent = getIntent();
        if (Intent.ACTION_VIEW.equals(intent.getAction())) {
            Uri data = intent.getData();
            if (data != null && "flutter".equals(data.getScheme()) && "notifications-all".equals(data.getHost())) {
                // Navigate to the /notifications-all route in Flutter
                navigateToNotificationsScreen();
            }
        }
    }

    private void navigateToNotificationsScreen() {
        // This will push the notifications-all route in Flutter
        getFlutterEngine().getNavigationChannel().pushRoute("/notifications-all");
    }
}
