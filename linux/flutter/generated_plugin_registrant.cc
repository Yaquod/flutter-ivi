//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <video_player_linux/video_player_linux.h>
#include <webview_flutter_linux/cef_web_view_platform.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) video_player_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "VideoPlayerLinux");
  video_player_linux_register_with_registrar(video_player_linux_registrar);
  g_autoptr(FlPluginRegistrar) webview_flutter_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CefWebViewPlatform");
  cef_web_view_platform_register_with_registrar(webview_flutter_linux_registrar);
}
