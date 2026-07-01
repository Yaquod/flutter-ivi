import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Returns an HTTP client with proxy auto-discovery disabled.
/// On embedded Linux, libproxy's module manager can crash if its network
/// extension plugins are missing. Forcing DIRECT bypasses libproxy entirely.
http.Client createSpotifyHttpClient() {
  final inner = HttpClient();
  inner.findProxy = (uri) => 'DIRECT';
  inner.connectionTimeout = const Duration(seconds: 10);
  return IOClient(inner);
}
