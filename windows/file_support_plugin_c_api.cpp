#include "include/file_support/file_support_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "file_support_plugin.h"

void FileSupportPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  file_support::FileSupportPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
