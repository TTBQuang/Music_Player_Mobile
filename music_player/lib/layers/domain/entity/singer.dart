import 'package:music_player/layers/data/dto/singer_dto.dart';

class Singer{
  int id;
  String name;
  String image;

  Singer({required this.id, required this.name, required this.image});

  factory Singer.fromSingerDto(SingerDto singerDto) {
    return Singer(
      id: singerDto.id,
      image: singerDto.image,
      name: singerDto.name,
    );
  }
}