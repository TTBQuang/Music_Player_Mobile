import '../../domain/entity/singer.dart';

class SingerDto extends Singer{
  SingerDto({required super.id, required super.name, required super.image});

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