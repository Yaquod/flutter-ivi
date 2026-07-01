class SpotifyTrack {
  final String id;
  final String uri;
  final String name;
  final String artistName;
  final String albumName;
  final String? albumArtUrl;
  final int durationMs;

  const SpotifyTrack({
    required this.id,
    required this.uri,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.albumArtUrl,
    required this.durationMs,
  });

  factory SpotifyTrack.fromJson(Map<String, dynamic> item) {
    final artists = (item['artists'] as List)
        .map((a) => a['name'] as String)
        .join(', ');
    final images = item['album']['images'] as List;
    return SpotifyTrack(
      id: item['id'] as String,
      uri: item['uri'] as String,
      name: item['name'] as String,
      artistName: artists,
      albumName: item['album']['name'] as String,
      albumArtUrl: images.isNotEmpty ? images[0]['url'] as String : null,
      durationMs: item['duration_ms'] as int,
    );
  }
}
