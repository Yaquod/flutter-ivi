class SpotifyPlaylist {
  final String id;
  final String uri;
  final String name;
  final String? imageUrl;
  final int tracksTotal;

  const SpotifyPlaylist({
    required this.id,
    required this.uri,
    required this.name,
    this.imageUrl,
    required this.tracksTotal,
  });

  factory SpotifyPlaylist.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List?;
    return SpotifyPlaylist(
      id: json['id'] as String,
      uri: json['uri'] as String,
      name: json['name'] as String,
      imageUrl: images != null && images.isNotEmpty
          ? images[0]['url'] as String?
          : null,
      tracksTotal:
          ((json['tracks'] as Map<String, dynamic>?)?['total'] as int?) ?? 0,
    );
  }
}
