import 'package:music_player/layers/data/dto/playlist_dto.dart';

abstract class PlaylistNetwork{
  Future<List<PlaylistDto>> getGenrePlaylist(int pageNumber, int pageSize);
  Future<List<PlaylistDto>> getSingerPlaylist(int pageNumber, int pageSize);
}