import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/strings.dart';
import 'download_song_item.dart';

class DownloadSongList extends StatefulWidget {
  const DownloadSongList({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadSongListState();
}

class _DownloadSongListState extends State<DownloadSongList>
    with WidgetsBindingObserver {
  List<SongModel> _songs = [];
  bool _shouldRequestPermission = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_shouldRequestPermission) {
      _requestPermission();
      _shouldRequestPermission = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldRequestPermission) {
      _requestPermission();
      _shouldRequestPermission = false;
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.audio.request();
    if (status.isGranted) {
      _loadSongs();
    }
  }

  Future<void> _loadSongs() async {
    List<SongModel> songs = await OnAudioQuery().querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
    );
    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Permission.audio.status,
      builder: (context, AsyncSnapshot<PermissionStatus> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isGranted) {
          if (_songs.isEmpty) {
            _loadSongs(); // Reload songs if permission is granted
          }
          return RefreshIndicator(
            onRefresh: _requestPermission,
            child: _songs.isEmpty
                ? const Center(child: Text("No songs found"))
                : ListView.builder(
                    itemCount: _songs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: DownloadSongItem(
                          name: _songs[index].title,
                          author: _songs[index].artist ?? Strings.appName,
                        ),
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
              _shouldRequestPermission = true;
            },
            child: const Text(Strings.goToSetting),
          ),
        ],
      ),
    );
  }
}
