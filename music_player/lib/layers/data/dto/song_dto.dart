import 'package:music_player/layers/data/dto/singer_dto.dart';
import 'package:music_player/layers/data/dto/user_dto.dart';

import '../../domain/entity/song.dart';

class SongDto {
  int? id;
  String? name;
  String? image;
  String? linkSong;
  DateTime? releaseDate;
  List<SingerDto>? singers;
  List<UserDto>? usersLike;
  List<UserDto>? usersSaved;

  SongDto(
      {required this.id,
      required this.name,
      required this.image,
      required this.linkSong,
      required this.releaseDate,
      required this.usersLike,
      required this.usersSaved,
      required this.singers});

  factory SongDto.fromJson(Map<String, dynamic> json) {
    List<SingerDto> singers = [];
    if (json['singers'] != null) {
      List<dynamic> singerJsonList = json['singers'] as List<dynamic>;
      singers = singerJsonList.map((singerJson) => SingerDto.fromJson(singerJson)).toList();
    }

    List<UserDto> usersLike = [];
    if (json['users_like'] != null) {
      List<dynamic> usersLikeJsonList = json['users_like'] as List<dynamic>;
      usersLike = usersLikeJsonList.map((userJson) => UserDto.fromJson(userJson)).toList();
    }

    List<UserDto> usersSave = [];
    if (json['users_save'] != null) {
      List<dynamic> usersSaveJsonList = json['users_save'] as List<dynamic>;
      usersSave = usersSaveJsonList.map((userJson) => UserDto.fromJson(userJson)).toList();
    }

    return SongDto(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        linkSong: json['link_song'],
        releaseDate: DateTime.parse(json['release_date']),
        usersLike: usersLike,
        usersSaved: usersSave,
        singers: singers);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'link_song': linkSong,
      'release_date': releaseDate?.toIso8601String(),
    };
  }

  factory SongDto.fromSong(Song song) {
    List<SingerDto> singerDtoList =
        song.singers?.map((singer) => SingerDto.fromSinger(singer)).toList() ??
            [];

    return SongDto(
        id: song.id,
        name: song.name,
        image: song.image,
        linkSong: song.linkSong,
        releaseDate: song.releaseDate,
        singers: singerDtoList,
        usersLike: [],
        usersSaved: []);
  }
}
