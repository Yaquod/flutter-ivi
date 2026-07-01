import 'spotify_track.dart';
import 'spotify_device.dart';

class SpotifyPlaybackState {
  final bool isPlaying;
  final int progressMs;
  final SpotifyTrack? track;
  final SpotifyDevice? device;
  final bool shuffleState;
  final String repeatState;
  final DateTime fetchedAt;

  const SpotifyPlaybackState({
    required this.isPlaying,
    required this.progressMs,
    this.track,
    this.device,
    required this.shuffleState,
    required this.repeatState,
    required this.fetchedAt,
  });

  /// Interpolates progress forward from fetchedAt for smooth seek-bar display.
  int get estimatedProgressMs {
    if (!isPlaying) return progressMs;
    final elapsed = DateTime.now().difference(fetchedAt).inMilliseconds;
    final total = track?.durationMs ?? 0;
    return (progressMs + elapsed).clamp(0, total);
  }

  factory SpotifyPlaybackState.fromJson(Map<String, dynamic> json) {
    final item = json['item'] as Map<String, dynamic>?;
    final deviceJson = json['device'] as Map<String, dynamic>?;
    return SpotifyPlaybackState(
      isPlaying: json['is_playing'] as bool,
      progressMs: json['progress_ms'] as int? ?? 0,
      track: item != null ? SpotifyTrack.fromJson(item) : null,
      device: deviceJson != null ? SpotifyDevice.fromJson(deviceJson) : null,
      shuffleState: json['shuffle_state'] as bool,
      repeatState: json['repeat_state'] as String,
      fetchedAt: DateTime.now(),
    );
  }

  SpotifyPlaybackState copyWith({
    bool? isPlaying,
    int? progressMs,
    SpotifyTrack? track,
    SpotifyDevice? device,
    bool? shuffleState,
    String? repeatState,
    DateTime? fetchedAt,
  }) =>
      SpotifyPlaybackState(
        isPlaying: isPlaying ?? this.isPlaying,
        progressMs: progressMs ?? this.progressMs,
        track: track ?? this.track,
        device: device ?? this.device,
        shuffleState: shuffleState ?? this.shuffleState,
        repeatState: repeatState ?? this.repeatState,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
}
