import 'package:music_player/layers/domain/entity/singer.dart';

class Song {
  int id;
  String name;
  String image;
  String linkSong;
  DateTime releaseDate;
  List<Singer> singers;

  Song({
    required this.id,
    required this.name,
    required this.image,
    required this.linkSong,
    required this.releaseDate,
    required this.singers
  });

  String getSingerNames() {
    return singers.map((singer) => singer.name).join(', ');
  }
}
