#ifndef FLUTTER_PLUGIN_DSI_PRO_PLUGIN_H_
#define FLUTTER_PLUGIN_DSI_PRO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace dsi_pro {

class DsiProPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DsiProPlugin();

  virtual ~DsiProPlugin();

  // Disallow copy and assign.
  DsiProPlugin(const DsiProPlugin&) = delete;
  DsiProPlugin& operator=(const DsiProPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace dsi_pro

#endif  // FLUTTER_PLUGIN_DSI_PRO_PLUGIN_H_
