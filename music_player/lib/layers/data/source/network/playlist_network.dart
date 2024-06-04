import 'package:music_player/layers/data/dto/paginated_response_dto.dart';
import 'package:music_player/layers/data/dto/playlist_dto.dart';

abstract class PlaylistNetwork{
  Future<PaginatedResponseDto> getGenrePlaylist(int pageNumber, int pageSize);
  Future<PaginatedResponseDto> getSingerPlaylist(int pageNumber, int pageSize);
}