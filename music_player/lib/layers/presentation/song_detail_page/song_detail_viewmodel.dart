import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';

import '../../domain/entity/playlist.dart';
import '../../domain/entity/song.dart';
import '../../domain/repository/song_repository.dart';

class SongDetailViewModel extends ChangeNotifier {
  late Song song;
  Playlist? playlist;
  SongRepository songRepository;

  SongDetailViewModel(this.songRepository);

  Future<void> getALlSongsInPlaylist(Playlist? pl) async {
    if (pl != null) {
      List<Song> songs = await songRepository.getSongsInPlaylist(
          pl.id, 0, pl.totalItems);
      playlist = pl.clone();
      playlist?.songList.clear();
      playlist?.songList.addAll(songs);
    }
  }
}
