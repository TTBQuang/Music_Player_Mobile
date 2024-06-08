import 'package:music_player/layers/data/source/network/song_network.dart';
import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';

import '../../domain/entity/paginated_response.dart';

class SongRepositoryImpl extends SongRepository{
  final SongNetwork songNetwork;

  SongRepositoryImpl(this.songNetwork);

  @override
  Future<PaginatedResponse> getNewSongs(int pageNumber, int pageSize) {
    return songNetwork.getNewSongs(pageNumber, pageSize);
  }

  @override
  Future<PaginatedResponse> getPopularSongs(int pageNumber, int pageSize) {
    return songNetwork.getPopularSongs(pageNumber, pageSize);
  }

  @override
  Future<PaginatedResponse> getRecentListenSongs(int userId, int pageNumber, int pageSize) {
    return songNetwork.getRecentListenSongs(userId, pageNumber, pageSize);
  }

  @override
  Future<List<Song>> getSongsInPlaylist(int playlistId, int pageNumber, int pageSize) {
    return songNetwork.getSongsInPlaylist(playlistId, pageNumber, pageSize);
  }

  @override
  Future<PaginatedResponse> getSongByName(String name, int pageNumber, int pageSize) {
    return songNetwork.getSongByName(name, pageNumber, pageSize);
  }
}