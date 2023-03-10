class Playlist {
  String name;
  String playlistUrl;
  String imageUrl;
  String description;
  int favCount;
  String id;
  int trackCount;
  Playlist(
      {required this.name,
      required this.imageUrl,
        required this.id,
        required this.trackCount,
      required this.description,
      required this.favCount,
      required this.playlistUrl});
}
