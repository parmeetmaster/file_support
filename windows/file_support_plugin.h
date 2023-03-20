#ifndef FLUTTER_PLUGIN_FILE_SUPPORT_PLUGIN_H_
#define FLUTTER_PLUGIN_FILE_SUPPORT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace file_support {

class FileSupportPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FileSupportPlugin();

  virtual ~FileSupportPlugin();

  // Disallow copy and assign.
  FileSupportPlugin(const FileSupportPlugin&) = delete;
  FileSupportPlugin& operator=(const FileSupportPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace file_support

#endif  // FLUTTER_PLUGIN_FILE_SUPPORT_PLUGIN_H_
