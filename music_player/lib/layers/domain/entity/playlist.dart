import 'package:music_player/layers/domain/entity/song.dart';

class Playlist {
  int id;
  String name;
  String image;
  int size;
  List<Song> songList = [];

  Playlist({required this.id, required this.name, required this.image, required this.size});
}