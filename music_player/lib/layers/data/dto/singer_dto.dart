import '../../domain/entity/singer.dart';

class SingerDto {
  int id;
  String name;
  String image;

  SingerDto({required this.id, required this.name, required this.image});

  factory SingerDto.fromJson(Map<String, dynamic> json) {
    return SingerDto(
      id: json['id'],
      name: json['name'],
      image: json['image']
    );
  }

  factory SingerDto.fromSinger(Singer singer) {
    return SingerDto(
        id: singer.id,
        name: singer.name,
        image: singer.image
    );
  }
}