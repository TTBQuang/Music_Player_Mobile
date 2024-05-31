import '../../domain/entity/song.dart';

class SongDto extends Song{
  SongDto({required super.id, required super.name, required super.image, required super.linkSong, required super.releaseDate});

  factory SongDto.fromJson(Map<String, dynamic> json) {
    return SongDto(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      linkSong: json['link_song'],
      releaseDate: DateTime.parse(json['release_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'link_song': linkSong,
      'release_date': releaseDate.toIso8601String(),
    };
  }
}