import 'package:music_player/layers/data/source/network/song_network.dart';
import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';

class SongRepositoryImpl extends SongRepository{
  final SongNetwork songNetwork;

  SongRepositoryImpl(this.songNetwork);

  @override
  Future<List<Song>> getNewSongs(int pageNumber, int pageSize) {
    return songNetwork.getNewSongs(pageNumber, pageSize);
  }

  @override
  Future<List<Song>> getPopularSongs(int pageNumber, int pageSize) {
    return songNetwork.getPopularSongs(pageNumber, pageSize);
  }

  @override
  Future<List<Song>> getRecentListenSongs(int userId, int pageNumber, int pageSize) {
    return songNetwork.getRecentListenSongs(userId, pageNumber, pageSize);
  }
}