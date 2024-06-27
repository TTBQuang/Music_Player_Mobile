import 'package:music_player/layers/domain/entity/singer.dart';

import '../../data/dto/song_dto.dart';

class Song {
  int? id;
  String? name;
  String? image;
  String? linkSong;
  DateTime? releaseDate;
  List<Singer>? singers;
  int? numberOfUserLike;
  bool? isLiked;
  bool? isSaved;

  Song(
      {required this.id,
      required this.name,
      required this.image,
      required this.linkSong,
      required this.releaseDate,
      required this.numberOfUserLike,
      required this.isLiked,
      required this.isSaved,
      required this.singers});

  String getSingerNames() {
    return singers?.map((singer) => singer.name).join(', ') ?? '';
  }

  factory Song.fromSongDto(SongDto songDto, int? userId) {
    List<Singer> singers = songDto.singers
        ?.map((singerDto) => Singer.fromSingerDto(singerDto))
        .toList() ?? [];

    bool isLike = songDto.usersLike?.any((userDto) => userDto.id == userId) ?? false;
    bool isSave = songDto.usersSaved?.any((userDto) => userDto.id == userId) ?? false;

    return Song(
      id: songDto.id,
      name: songDto.name,
      image: songDto.image,
      linkSong: songDto.linkSong,
      releaseDate: songDto.releaseDate,
      isLiked: userId != null ? isLike : null,
      isSaved: userId != null ? isSave : null,
      numberOfUserLike: songDto.usersLike?.length ?? 0,
      singers: singers,
    );
  }

}
