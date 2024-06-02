import 'package:music_player/layers/data/dto/song_dto.dart';

abstract class SongNetwork{
  Future<List<SongDto>> getNewSongs(int pageNumber, int pageSize);
  Future<List<SongDto>> getPopularSongs(int pageNumber, int pageSize);
  Future<List<SongDto>> getRecentListenSongs(int userId, int pageNumber, int pageSize);
  Future<List<SongDto>> getSongsInPlaylist(int playlistId, int pageNumber, int pageSize);
}