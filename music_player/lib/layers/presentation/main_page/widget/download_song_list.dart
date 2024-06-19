import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/utils/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';
import '../../../../utils/file_utils.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/toast_util.dart';
import '../../play_download_song_page/play_download_song_screen.dart';
import 'download_song_item.dart';

class DownloadSongList extends StatefulWidget {
  const DownloadSongList({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadSongListState();
}

class _DownloadSongListState extends State<DownloadSongList>
    with WidgetsBindingObserver {
  List<SongModel> _songs = [];
  bool _shouldReloadSongs = true;
  late final AudioManager _audioManager;
  Playlist? playlist;
  int sdk = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioManager = Provider.of<AudioManager>(context, listen: false);
    if (_shouldReloadSongs) {
      _requestPermission();
      _shouldReloadSongs = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldReloadSongs) {
      _requestPermission();
      _shouldReloadSongs = false;
    }
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      sdk = androidInfo.version.sdkInt;
    }

    if (sdk >= 33){
      final status = await Permission.audio.request();
      if (status.isGranted) {
        _loadSongs();
      }
    } else {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        _loadSongs();
      }
    }
  }

  Future<void> _loadSongs() async {
    List<SongModel> songs = await OnAudioQuery().querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
    );
    setState(() {
      _songs.clear();
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sdk >= 33 ? Permission.audio.status : Permission.storage.status,
      builder: (context, AsyncSnapshot<PermissionStatus> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isGranted) {
          _loadSongs();

          return RefreshIndicator(
            onRefresh: _requestPermission,
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ValueListenableBuilder<int>(
                      valueListenable: _audioManager.currentPlaylistIdNotifier,
                      builder: (_, playlistId, __) {
                        return ValueListenableBuilder(
                            valueListenable:
                                _audioManager.currentSongIdNotifier,
                            builder: (_, songId, __) {
                              return InkWell(
                                child: DownloadSongItem(
                                  name: _songs[index].title,
                                  author:
                                      _songs[index].artist ?? Strings.appName,
                                  uri: _songs[index].uri ?? '',
                                  isPlaying: (songId == _songs[index].id && playlistId == playlist?.id),
                                  onDelete: deleteSong, // Pass the callback
                                ),
                                onTap: () async {
                                  _navigateToPlayDownloadSongScreen(
                                      context, index);
                                },
                              );
                            });
                      }),
                );
              },
            ),
          );
        } else {
          return _buildTextExplainPermission();
        }
      },
    );
  }

  Future<void> _navigateToPlayDownloadSongScreen(
      BuildContext context, int index) async {
    playlist = Playlist(
        id: Constants.downloadSongsPlaylistId,
        name: Strings.downloadedSong,
        image: '',
        totalItems: _songs.length);

    for (SongModel song in _songs) {
      playlist?.songList.add(Song(
          id: song.id,
          name: song.title,
          image: null,
          linkSong: song.uri,
          releaseDate: null,
          singers: null));
    }

    final uri = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return PlayDownloadSongScreen(
            playlist: playlist!,
            song: Song(
                id: _songs[index].id,
                name: _songs[index].title,
                image: null,
                linkSong: _songs[index].uri ?? '',
                releaseDate: null,
                singers: null));
      },
    ));

    if (context.mounted && uri != null) {
      setState(() {
        _songs.removeWhere((song) => song.uri == uri);
      });
    }
  }

  void deleteSong(String uri) {
    FileUtils.deleteFile(uri).then((isSuccess) {
      if (isSuccess) {
        if (context.mounted) {
          setState(() {
            _songs.removeWhere((song) => song.uri == uri);
          });
        }
      } else {
        ToastUtil.showToast(Strings.deleteFail);
      }
    });
  }

  Widget _buildTextExplainPermission() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(Strings.explainAudioPermissionContent),
          TextButton(
            onPressed: () {
              openAppSettings();
              _shouldReloadSongs = true;
            },
            child: const Text(Strings.goToSetting),
          ),
        ],
      ),
    );
  }
}
