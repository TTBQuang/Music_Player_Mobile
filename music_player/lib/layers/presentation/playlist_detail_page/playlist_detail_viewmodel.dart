import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';

import '../../../utils/constants.dart';
import '../../domain/entity/song.dart';
import '../../domain/repository/song_repository.dart';

class PlaylistDetailViewModel extends ChangeNotifier {
  Playlist? playlist;
  SongRepository songRepository;

  PlaylistDetailViewModel({required this.songRepository});

  Future<List<Song>> getSongsInPlaylist(int pageNumber) async {
    if (playlist != null) {
      return songRepository.getSongsInPlaylist(
          playlist!.id, pageNumber - 1, Constants.pageSizePlaylistDetailView);
    } else {
      return <Song>[];
    }
  }

  Future<void> fetchNewPage(int pageNumber) async {
    List<Song> newSongs = await songRepository.getSongsInPlaylist(
        playlist!.id, pageNumber - 1, Constants.pageSizePlaylistDetailView);
    playlist?.songList.clear();
    playlist?.songList.addAll(newSongs);
  }
}
