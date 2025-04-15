package com.devsecit.dsi_pro;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class NotificationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String route = intent.getStringExtra("route");

        // Send a broadcast back to the plugin to handle navigation
        Intent broadcastIntent = new Intent("com.devsecit.dsi_pro.NAVIGATE_TO_ROUTE");
        broadcastIntent.putExtra("route", route);
        context.sendBroadcast(broadcastIntent);
    }
}
