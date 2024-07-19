import 'package:music_player/layers/domain/entity/uploaded_song.dart';

class UploadedSongDto {
  String name;
  int singerId;
  int genreId;
  String songLink;
  String imageLink;
  DateTime releaseDate;

  UploadedSongDto({
    required this.name,
    required this.singerId,
    required this.genreId,
    required this.songLink,
    required this.imageLink,
    DateTime? releaseDate,
  }) : releaseDate = releaseDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageLink': imageLink,
      'songLink': songLink,
      'singerId': singerId,
      'genreId': genreId,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }

  factory UploadedSongDto.fromUploadedSong(UploadedSong song) {
    return UploadedSongDto(
        name: song.name,
        singerId: song.singerId,
        genreId: song.genreId,
        songLink: song.songLink,
        imageLink: song.imageLink);
  }
}
