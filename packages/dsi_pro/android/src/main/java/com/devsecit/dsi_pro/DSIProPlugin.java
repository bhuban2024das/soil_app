package com.devsecit.dsi_pro;

import static android.app.Activity.RESULT_OK;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.app.Activity;

/** DSIProPlugin */
public class DSIProPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Context context;
  private Activity activity;
  private MethodChannel.Result flutterResult;
  private static final String CHANNEL_ID = "dsi_pro_notification_channel";
  private static final int WEB_PAGE_REQUEST_CODE = 100;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "dsi_pro");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
    context = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener((requestCode, resultCode, data) -> onActivityResult(requestCode, resultCode, data));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener((requestCode, resultCode, data) -> onActivityResult(requestCode, resultCode, data));
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "getAndroidId":
        result.success(getAndroidId());
        break;
      case "launchWeb":
        String url = call.argument("url");
        launchWebPage(url, result);
        break;
      case "showNotification":
        String title = call.argument("title");
        String content = call.argument("content");
        String route = call.argument("route");
        showNotification(title, content, route);
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void launchWebPage(String url, MethodChannel.Result result) {
    if (activity == null) {
      result.error("ACTIVITY_NOT_ATTACHED", "Activity is not attached", null);
      return;
    }

    Intent intent = new Intent(activity, WebPage.class);
    intent.putExtra("url", url);
    activity.startActivityForResult(intent, WEB_PAGE_REQUEST_CODE);
    flutterResult = result;
  }

  private boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    if (requestCode == WEB_PAGE_REQUEST_CODE) {
      if (resultCode == RESULT_OK && data != null) {
        String response = data.getStringExtra("response");
        if (flutterResult != null) {
          flutterResult.success(response);
          flutterResult = null;
        }
      } else {
        if (flutterResult != null) {
          flutterResult.error("NO_RESPONSE", "No data received or operation cancelled", null);
          flutterResult = null;
        }
      }
      return true;
    }
    return false;
  }

  private void showNotification(String title, String content, String route) {
    if (context == null) return;

    NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationChannel channel = new NotificationChannel(
              CHANNEL_ID,
              "DSI Pro Notifications",
              NotificationManager.IMPORTANCE_HIGH
      );
      notificationManager.createNotificationChannel(channel);
    }

    Intent intent = new Intent(context, MainActivity.class);
    intent.putExtra("route", route);
    PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

    Notification notification = new NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build();

    notificationManager.notify(1, notification);
  }

  private String getAndroidId() {
    return Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
  }
}
