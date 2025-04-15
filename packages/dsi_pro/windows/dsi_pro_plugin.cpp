#include "dsi_pro_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include "<flutter_window.h>"
#include "<flutter_window_controller.h>"

#include <memory>
#include <sstream>

namespace dsi_pro {

// static
void DsiProPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "dsi_pro",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DsiProPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

DsiProPlugin::DsiProPlugin() {}

DsiProPlugin::~DsiProPlugin() {}

void DsiProPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {


  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if(method_call.method_name().compare("restartApp") == 0) {
    auto window_controller = flutter::FlutterWindowController::GetInstance(); 
      // Restart the Flutter window
      window_controller->RestartFlutterWindow();
      result->Success(flutter::EncodableValue(version_stream.str()));
  }else  {
    result->NotImplemented();
  }
}

}  // namespace dsi_pro
