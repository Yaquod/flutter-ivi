import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_ivi/ui_components/glass_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:flutter_ivi/constants/app_color.dart';

class SpotifyLoginDialog extends StatefulWidget {
  final String authUrl;
  final void Function(String code) onCodeReceived;

  const SpotifyLoginDialog({
    super.key,
    required this.authUrl,
    required this.onCodeReceived,
  });

  @override
  State<SpotifyLoginDialog> createState() => _SpotifyLoginDialogState();
}

class _SpotifyLoginDialogState extends State<SpotifyLoginDialog> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _initError;

  static const _redirectPrefix = 'http://127.0.0.1:8080/callback';

  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (err) {
            debugPrint('[WebView] resource error: ${err.description}');
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            debugPrint('[WebView] navigating to: ${request.url}');
            if (request.url.startsWith(_redirectPrefix)) {
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];
              if (code != null && mounted) {
                Navigator.of(context).pop();
                widget.onCodeReceived(code);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ))
        ..loadRequest(Uri.parse(widget.authUrl));
    } catch (e, st) {
      debugPrint('[SpotifyLoginDialog] WebView init failed: $e\n$st');
      _initError = e.toString();
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: r.w(200),
        vertical: r.h(100),
      ),
      child: GlassCard(
        borderRadius: BorderRadius.circular(r.radiusXl),
        child: Column(
          children: [
            // Header
            Padding(
              padding: r.edgeInsetsSym(h: 24, v: 16),
              child: Row(
                children: [
                  Icon(Icons.music_note,
                      color: const Color(0xFF1DB954), size: r.iconXs),
                  SizedBox(width: r.paddingMd),
                  Text(
                    'Connect to Spotify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.fontMd,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close,
                        color: AppColor.secondary_text_dark, size: r.iconXs),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white10, height: 1),

            // Body
            Expanded(
              child: _initError != null
                  ? _ErrorBody(r: r, error: _initError!, authUrl: widget.authUrl)
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(r.radiusXl),
                          ),
                          child: WebViewWidget(controller: _controller!),
                        ),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1DB954),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when WebView fails to initialize — displays the auth URL so the user
/// can open it manually in a browser and paste back the code.
class _ErrorBody extends StatelessWidget {
  final ResponsiveLayout r;
  final String error;
  final String authUrl;

  const _ErrorBody(
      {required this.r, required this.error, required this.authUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: r.edgeInsetsAll(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orangeAccent, size: r.iconMd),
          SizedBox(height: r.paddingMd),
          Text(
            'WebView unavailable',
            style: TextStyle(
                color: Colors.white,
                fontSize: r.fontMd,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: r.paddingSm),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColor.secondary_text_dark, fontSize: r.fontXs),
          ),
          SizedBox(height: r.paddingLg),
          Text(
            'Open this URL in a browser to log in:',
            style: TextStyle(
                color: AppColor.secondary_text_dark, fontSize: r.fontSm),
          ),
          SizedBox(height: r.paddingSm),
          SelectableText(
            authUrl,
            style: TextStyle(
                color: AppColor.action_color, fontSize: r.fontXs),
          ),
        ],
      ),
    );
  }
}
