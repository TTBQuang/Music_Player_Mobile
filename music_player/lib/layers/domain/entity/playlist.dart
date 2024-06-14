import 'package:music_player/layers/domain/entity/song.dart';

class Playlist {
  int id;
  String name;
  String image;
  int totalItems;
  List<Song> songList = [];

  Playlist({required this.id, required this.name, required this.image, required this.totalItems});

  Playlist clone() {
    return Playlist(
      id: id,
      name: name,
      image: image,
      totalItems: totalItems,
    )..songList = List<Song>.from(songList);
  }
}