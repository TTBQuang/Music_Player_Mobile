import 'package:music_player/layers/data/dto/paginated_response_dto.dart';
import 'package:music_player/layers/data/source/network/playlist_network.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';

class PlaylistRepositoryImpl extends PlaylistRepository{
  PlaylistNetwork playlistNetwork;

  PlaylistRepositoryImpl(this.playlistNetwork);

  @override
  Future<PaginatedResponseDto> getGenrePlaylist(int pageNumber, int pageSize) {
    return playlistNetwork.getGenrePlaylist(pageNumber, pageSize);
  }

  @override
  Future<PaginatedResponseDto> getSingerPlaylist(int pageNumber, int pageSize) {
    return playlistNetwork.getSingerPlaylist(pageNumber, pageSize);
  }
}