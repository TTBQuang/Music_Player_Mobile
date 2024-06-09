import '../../data/dto/paginated_response_dto.dart';
import '../entity/playlist.dart';

abstract class PlaylistRepository{
  Future<PaginatedResponseDto> getGenrePlaylist(int pageNumber, int pageSize);
  Future<PaginatedResponseDto> getSingerPlaylist(int pageNumber, int pageSize);
  Future<Playlist> getPlaylistBySingerId(int singerId);
}