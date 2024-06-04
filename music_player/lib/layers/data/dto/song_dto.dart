import 'package:music_player/layers/data/dto/singer_dto.dart';

import '../../domain/entity/singer.dart';
import '../../domain/entity/song.dart';

class SongDto extends Song {
  SongDto(
      {required super.id,
      required super.name,
      required super.image,
      required super.linkSong,
      required super.releaseDate,
      required super.singers});

  factory SongDto.fromJson(Map<String, dynamic> json) {
    // Parse the list of singers
    List<Singer> singers = [];
    if (json['singers'] != null) {
      List<dynamic> singerJsonList = json['singers'] as List<dynamic>;
      singers = singerJsonList.map((singerJson) => SingerDto.fromJson(singerJson)).toList();
    }

    return SongDto(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      linkSong: json['link_song'],
      releaseDate: DateTime.parse(json['release_date']),
      singers: singers
    );
  }
}
