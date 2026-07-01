import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_ivi/ui_components/glass_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:flutter_ivi/constants/app_color.dart';

/// Shows a QR code and waits for [codeFuture] to resolve with the OAuth code.
///
/// The caller is responsible for starting the relay poll (or local server) and
/// passing in the resulting Future — this widget just shows UI.
class SpotifyQrLoginDialog extends StatefulWidget {
  final String authUrl;
  final Future<String> codeFuture;
  final void Function(String code) onCodeReceived;

  const SpotifyQrLoginDialog({
    super.key,
    required this.authUrl,
    required this.codeFuture,
    required this.onCodeReceived,
  });

  @override
  State<SpotifyQrLoginDialog> createState() => _SpotifyQrLoginDialogState();
}

enum _Phase { waiting, connecting, error }

class _SpotifyQrLoginDialogState extends State<SpotifyQrLoginDialog> {
  _Phase _phase = _Phase.waiting;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _waitForCode();
  }

  Future<void> _waitForCode() async {
    try {
      final code = await widget.codeFuture;
      if (!mounted) return;
      setState(() => _phase = _Phase.connecting);
      widget.onCodeReceived(code);
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: r.w(80),
        vertical: r.h(40),
      ),
      child: GlassCard(
        borderRadius: BorderRadius.circular(r.radiusXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(r: r),
            const Divider(color: Colors.white10, height: 1),
            Flexible(
              child: _DialogBody(
                r: r,
                phase: _phase,
                authUrl: widget.authUrl,
                error: _errorMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DialogHeader extends StatelessWidget {
  final ResponsiveLayout r;
  const _DialogHeader({required this.r});

  @override
  Widget build(BuildContext context) => Padding(
        padding: r.edgeInsetsSym(h: 24, v: 16),
        child: Row(
          children: [
            _SpotifyDot(size: r.sp(20)),
            SizedBox(width: r.paddingMd),
            Text(
              'Connect Spotify',
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
      );
}

// ── Body dispatcher ───────────────────────────────────────────────────────────

class _DialogBody extends StatelessWidget {
  final ResponsiveLayout r;
  final _Phase phase;
  final String authUrl;
  final String? error;

  const _DialogBody({
    required this.r,
    required this.phase,
    required this.authUrl,
    this.error,
  });

  @override
  Widget build(BuildContext context) => switch (phase) {
        _Phase.waiting => _QrView(r: r, authUrl: authUrl),
        _Phase.connecting => _ConnectingView(r: r),
        _Phase.error => _ErrorView(r: r, error: error ?? 'Unknown error'),
      };
}

// ── QR code view ──────────────────────────────────────────────────────────────

class _QrView extends StatelessWidget {
  final ResponsiveLayout r;
  final String authUrl;

  const _QrView({required this.r, required this.authUrl});

  @override
  Widget build(BuildContext context) => Padding(
        padding: r.edgeInsetsAll(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan with your phone',
              style: TextStyle(
                color: Colors.white,
                fontSize: r.fontMd,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: r.paddingXs),
            Text(
              'Open your camera — no vehicle Wi-Fi needed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.secondary_text_dark,
                fontSize: r.fontXs,
              ),
            ),
            SizedBox(height: r.paddingLg),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(r.radiusMd),
              ),
              padding: EdgeInsets.all(r.sp(16)),
              child: QrImageView(
                data: authUrl,
                version: QrVersions.auto,
                size: r.sp(280),
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: r.paddingLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PulsingDot(size: r.sp(8)),
                SizedBox(width: r.paddingXs),
                Text(
                  'Waiting for login…',
                  style: TextStyle(
                    color: AppColor.secondary_text_dark,
                    fontSize: r.fontXs,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

// ── Connecting view ───────────────────────────────────────────────────────────

class _ConnectingView extends StatelessWidget {
  final ResponsiveLayout r;
  const _ConnectingView({required this.r});

  @override
  Widget build(BuildContext context) => Padding(
        padding: r.edgeInsetsAll(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
                color: Color(0xFF1DB954), strokeWidth: 3),
            SizedBox(height: r.paddingLg),
            Text(
              'Connecting…',
              style: TextStyle(
                color: Colors.white,
                fontSize: r.fontMd,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final ResponsiveLayout r;
  final String error;

  const _ErrorView({required this.r, required this.error});

  @override
  Widget build(BuildContext context) => Padding(
        padding: r.edgeInsetsAll(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: r.iconMd),
            SizedBox(height: r.paddingMd),
            Text(
              'Login failed',
              style: TextStyle(
                color: Colors.white,
                fontSize: r.fontMd,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: r.paddingSm),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.secondary_text_dark,
                fontSize: r.fontXs,
              ),
            ),
            SizedBox(height: r.paddingLg),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: r.edgeInsetsSym(h: 24, v: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954),
                  borderRadius: BorderRadius.circular(r.radiusMd),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: r.fontSm,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

// ── Small helpers ─────────────────────────────────────────────────────────────

class _SpotifyDot extends StatelessWidget {
  final double size;
  const _SpotifyDot({required this.size});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF1DB954),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.music_note, color: Colors.white, size: size * 0.6),
      );
}

class _PulsingDot extends StatefulWidget {
  final double size;
  const _PulsingDot({required this.size});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween(begin: 0.3, end: 1.0).animate(_ctrl),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            color: Color(0xFF1DB954),
            shape: BoxShape.circle,
          ),
        ),
      );
}
