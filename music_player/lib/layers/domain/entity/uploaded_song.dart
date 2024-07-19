class UploadedSong {
  String name;
  int singerId;
  int genreId;
  String songLink;
  String imageLink;
  DateTime releaseDate;

  UploadedSong({
    required this.name,
    required this.singerId,
    required this.genreId,
    required this.songLink,
    required this.imageLink,
    DateTime? releaseDate,
  }) : releaseDate = releaseDate ?? DateTime.now();
}
