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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}