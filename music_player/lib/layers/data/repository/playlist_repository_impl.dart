import 'package:music_player/layers/data/dto/paginated_response_dto.dart';
import 'package:music_player/layers/data/dto/playlist_dto.dart';
import 'package:music_player/layers/data/source/network/playlist_network.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';

import '../../domain/entity/paginated_response.dart';

class PlaylistRepositoryImpl extends PlaylistRepository{
  PlaylistNetwork playlistNetwork;

  PlaylistRepositoryImpl(this.playlistNetwork);

  @override
  Future<PaginatedResponse> getGenrePlaylist(int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto = await playlistNetwork.getGenrePlaylist(pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }

  @override
  Future<PaginatedResponse> getSingerPlaylist(int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto = await playlistNetwork.getSingerPlaylist(pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }

  @override
  Future<Playlist> getPlaylistBySingerId(int singerId) async {
    PlaylistDto playlistDto = await playlistNetwork.getPlaylistBySingerId(singerId);
    return Playlist.fromPlaylistDto(playlistDto);
  }
}