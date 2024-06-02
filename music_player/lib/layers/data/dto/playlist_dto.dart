import '../../domain/entity/playlist.dart';

class PlaylistDto extends Playlist {
  PlaylistDto({
    required super.id,
    required super.name,
    required super.image,
    required super.size,
  });

  factory PlaylistDto.fromJson(Map<String, dynamic> json) {
    return PlaylistDto(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'size': size,
    };
  }
}