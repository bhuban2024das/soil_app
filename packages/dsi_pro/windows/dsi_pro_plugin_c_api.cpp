#include "include/dsi_pro/dsi_pro_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "dsi_pro_plugin.h"

void DsiProPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  dsi_pro::DsiProPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
