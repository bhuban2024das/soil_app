package com.devsecit.dsi_pro;

import static android.content.ContentValues.TAG;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class WebPage extends AppCompatActivity {
    private WebView webView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // EdgeToEdge.enable(this);

        setContentView(R.layout.activity_web_page);

        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        String url = getIntent().getStringExtra("url");

        webView = findViewById(R.id.webPage);

        // Configure WebView
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(new WebViewClient());
        webView.addJavascriptInterface(new WebAppInterface(), "Android"); // Add JavaScript interface
        webView.loadUrl(url);


        Log.d(TAG, "Overlay created");
    }


    private class WebAppInterface {
        @JavascriptInterface
        public void loginSuccess(String data) {
            Log.d(TAG, "Data received from webpage: " + data);
            // Validate data and close the popup if necessary
            if (data != null && !data.isEmpty()) {
                Log.d(TAG, "Login successful. Closing the popup.");
                // Toast.makeText(WebPage.this, "SMS : " + data, Toast.LENGTH_LONG).show();

                Intent resultIntent = new Intent();
                resultIntent.putExtra("response", data); // API response
                setResult(Activity.RESULT_OK, resultIntent);

//                if (webView != null) {
//                    webView.loadUrl("about:blank");
//                    webView.clearHistory();
//                    webView.clearCache(true);
//                    webView.destroy();
//                    webView = null;
//                }

                finish();
//                stopServiceSafely(); // Stop the service and close the popup
            } else {
                Log.d(TAG, "Invalid data received from webpage.");
            }
        }
    }

    @Override
    protected void onDestroy() {
        if (webView != null) {
            webView.loadUrl("about:blank");
            webView.clearHistory();
            webView.clearCache(true);
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
        // Additional cleanup if necessary
    }

}