import 'package:music_player/layers/domain/entity/genre.dart';

abstract class GenreRepository{
  Future<List<Genre>> getAllGenres();
}