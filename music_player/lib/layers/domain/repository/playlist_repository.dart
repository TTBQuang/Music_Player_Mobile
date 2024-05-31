import 'package:music_player/layers/domain/entity/playlist.dart';

abstract class PlaylistRepository{
  Future<List<Playlist>> getGenrePlaylist(int pageNumber, int pageSize);
  Future<List<Playlist>> getSingerPlaylist(int pageNumber, int pageSize);
}