import '../../data/dto/genre_dto.dart';

class Genre{
  int id;
  String name;
  String image;

  Genre({required this.id, required this.name, required this.image});

  factory Genre.fromGenreDto(GenreDto genreDto) {
    return Genre(
      id: genreDto.id,
      image: genreDto.image,
      name: genreDto.name,
    );
  }
}