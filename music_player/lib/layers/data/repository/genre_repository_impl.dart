import 'package:music_player/layers/data/dto/genre_dto.dart';
import 'package:music_player/layers/data/source/network/genre_network.dart';
import 'package:music_player/layers/domain/entity/genre.dart';
import 'package:music_player/layers/domain/repository/genre_repository.dart';

class GenreRepositoryImpl extends GenreRepository {
  final GenreNetwork genreNetwork;

  GenreRepositoryImpl(this.genreNetwork);

  @override
  Future<List<Genre>> getAllGenres() async {
    List<GenreDto> list = await genreNetwork.getAllGenres();
    // convert to List<Genre>
    List<Genre> result = [];
    for (GenreDto genreDto in list) {
      result.add(Genre.fromGenreDto(genreDto));
    }
    return result;
  }
}