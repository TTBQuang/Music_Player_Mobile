import 'package:music_player/layers/domain/entity/paginated_response.dart';

import '../entity/playlist.dart';

abstract class PlaylistRepository{
  Future<PaginatedResponse> getGenrePlaylist(int pageNumber, int pageSize);
  Future<PaginatedResponse> getSingerPlaylist(int pageNumber, int pageSize);
  Future<Playlist> getPlaylistBySingerId(int singerId);
}