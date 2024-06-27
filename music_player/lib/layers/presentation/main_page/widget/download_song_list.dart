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
  bool _isLoading = true;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();

    // listen to lifecycle change (to reload when user navigate to setting to grant permission)
    WidgetsBinding.instance.addObserver(this);
    _audioManager = Provider.of<AudioManager>(context, listen: false);
    _checkSdkAndRequestPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // reload if user navigate to setting
    if (state == AppLifecycleState.resumed && _shouldReloadSongs) {
      _checkSdkAndRequestPermission();
      // set this variable to false to avoid infinite reloading
      _shouldReloadSongs = false;
    }
  }

  Future<void> _checkSdkAndRequestPermission() async {
    // check sdk of android device
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      sdk = androidInfo.version.sdkInt;
    }

    _requestPermission();
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    // request permission
    PermissionStatus status;
    if (sdk >= 33) {
      status = await Permission.audio.request();
    } else {
      status = await Permission.storage.request();
    }

    // if user grant permission, load song
    if (status.isGranted) {
      _loadSongs();
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // load song order by date, then set state to show list song
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isPermissionGranted) {
      return _buildTextExplainPermission();
    }

    if (_songs.isEmpty) {
      _loadSongs();
    }

    return RefreshIndicator(
      onRefresh: _requestPermission,
      child: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ValueListenableBuilder<int>(
              valueListenable: _audioManager.playlistIdNotifier,
              builder: (_, playlistId, __) {
                return ValueListenableBuilder(
                  valueListenable: _audioManager.songIdNotifier,
                  builder: (_, songId, __) {
                    return InkWell(
                      child: DownloadSongItem(
                        name: _songs[index].title,
                        author: _songs[index].artist ?? Strings.appName,
                        uri: _songs[index].uri ?? '',
                        isPlaying: (songId == _songs[index].id &&
                            playlistId == Constants.downloadSongsPlaylistId),
                        onDelete: deleteSong, // Pass the callback
                      ),
                      onTap: () async {
                        _navigateToPlayDownloadSongScreen(context, index);
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

  Future<void> _navigateToPlayDownloadSongScreen(
      BuildContext context, int index) async {
    // create a playlist contain all mp3 file in device
    playlist = Playlist(
      id: Constants.downloadSongsPlaylistId,
      name: Strings.downloadedSong,
      image: '',
      totalItems: _songs.length,
    );

    for (SongModel song in _songs) {
      playlist?.songList.add(Song(
        id: song.id,
        name: song.title,
        image: null,
        linkSong: song.uri,
        releaseDate: null,
        singers: null,
        isLiked: null,
        isSaved: null,
        numberOfUserLike: null
      ));
    }

    // navigate to PlayDownloadSongScreen
    // if user choose delete a song in PlayDownloadSongScreen, get the uri of that song
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
            singers: null,
            isSaved: null,
            isLiked: null,
            numberOfUserLike: null
          ),
        );
      },
    ));

    // remove the deleted song from the list
    if (context.mounted && uri != null) {
      setState(() {
        _songs.removeWhere((song) => song.uri == uri);
      });
    }
  }

  // delete a song in device, then remove that song from the list
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

  // show UI to explain that user need permission to use a function
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
