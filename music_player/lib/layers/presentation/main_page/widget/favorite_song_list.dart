import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/widget/favorite_song_item.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_screen.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';
import '../../../../utils/constants.dart';
import '../../../domain/entity/playlist.dart';
import '../../../domain/entity/song.dart';
import '../main_viewmodel.dart';

class FavoriteSongList extends StatefulWidget {
  const FavoriteSongList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FavoriteSongListState();
  }
}

class _FavoriteSongListState extends State<FavoriteSongList> {
  Playlist? playlist;
  List<Song> _songs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavoriteSongs();
  }

  Future<void> _loadFavoriteSongs() async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    if (loginViewModel.user != null) {
      try {
        // load favorite songs
        var songs =
            await mainViewModel.getFavoriteSongs(loginViewModel.user!.id);
        setState(() {
          _songs = songs;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final AudioManager audioManager =
        Provider.of<AudioManager>(context, listen: false);

    // show UI to ask user to login to use this function
    if (loginViewModel.user == null) {
      return Center(
        child: Text(
          Strings.requireLogin,
          style: TextStyle(fontSize: 15.w),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_songs.isEmpty) {
      return Center(
        child: Text(
          Strings.noFavoriteSongs,
          style: TextStyle(fontSize: 15.w),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavoriteSongs,
      child: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ValueListenableBuilder<int>(
              valueListenable: audioManager.playlistIdNotifier,
              builder: (_, playlistId, __) {
                return ValueListenableBuilder(
                  valueListenable: audioManager.songIdNotifier,
                  builder: (_, songId, __) {
                    return InkWell(
                      child: FavoriteSongItem(
                        song: _songs[index],
                        isPlaying: (songId == _songs[index].id &&
                            playlistId == Constants.favoriteSongsPlaylistId),
                        onRemoveFromFavorite: (songId) async {
                          // remove song from favorite in database,
                          // then remove that song from the list
                          final mainViewModel = Provider.of<MainViewModel>(
                              context,
                              listen: false);
                          await mainViewModel.removeSongFromFavorite(
                              songId, loginViewModel.user!.id);
                          setState(() {
                            _songs.removeWhere((song) => song.id == songId);
                          });
                        },
                      ),
                      onTap: () {
                        _navigateToSongDetailScreen(context, index);
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // create a playlist contain all favorite song, then navigate to SongDetailScreen
  Future<void> _navigateToSongDetailScreen(
      BuildContext context, int index) async {
    playlist = Playlist(
      id: Constants.favoriteSongsPlaylistId,
      name: Strings.favoriteSong,
      image: '',
      totalItems: _songs.length,
    );

    for (Song song in _songs) {
      playlist?.songList.add(song);
    }

    await Navigator.of(context)
        .push(SongDetailScreen.route(song: _songs[index], playlist: playlist));

    _loadFavoriteSongs();
    setState(() {});
  }
}
