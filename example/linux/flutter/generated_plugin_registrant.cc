//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_support/file_support_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) file_support_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSupportPlugin");
  file_support_plugin_register_with_registrar(file_support_registrar);
}
