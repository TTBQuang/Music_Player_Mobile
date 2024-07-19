import 'package:music_player/layers/data/dto/genre_dto.dart';

abstract class GenreNetwork{
  Future<List<GenreDto>> getAllGenres();
}