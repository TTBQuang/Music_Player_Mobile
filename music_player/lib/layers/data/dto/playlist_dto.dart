import '../../domain/entity/playlist.dart';

class PlaylistDto {
  int id;
  String name;
  String image;
  int totalItems;

  PlaylistDto({
    required this.id,
    required this.name,
    required this.image,
    required this.totalItems,
  });

  factory PlaylistDto.fromJson(Map<String, dynamic> json) {
    return PlaylistDto(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      totalItems: json['totalItems'],
    );
  }
}