import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/file_utils.dart';
import 'package:provider/provider.dart';

import '../../../services/audio_manager.dart';
import '../../../utils/constants.dart';
import '../../../utils/size_config.dart';
import '../../../utils/strings.dart';
import '../../../utils/toast_util.dart';
import '../../domain/entity/playlist.dart';
import '../../domain/entity/song.dart';
import '../song_detail_page/widget/audio_progress_bar.dart';
import '../song_detail_page/widget/authors_name.dart';
import '../song_detail_page/widget/next_song_btn.dart';
import '../song_detail_page/widget/play_button.dart';
import '../song_detail_page/widget/play_mode_button.dart';
import '../song_detail_page/widget/play_mode_dialog.dart';
import '../song_detail_page/widget/playlist_title.dart';
import '../song_detail_page/widget/previous_song_btn.dart';
import '../song_detail_page/widget/rotating_song_art.dart';
import '../song_detail_page/widget/song_name.dart';

class PlayDownloadSongScreen extends StatefulWidget {
  final Playlist playlist;
  final Song song;

  const PlayDownloadSongScreen(
      {super.key, required this.playlist, required this.song});

  @override
  State<StatefulWidget> createState() {
    return _PlayDownloadSongState();
  }
}

class _PlayDownloadSongState extends State<PlayDownloadSongScreen> {
  late final AudioManager _audioManager;

  @override
  void initState() {
    super.initState();

    _audioManager = Provider.of<AudioManager>(context, listen: false);
    _audioManager.saveListenHistory = null;

    // if user listen new song, load data
    if (_audioManager.playlistIdNotifier.value != widget.playlist.id ||
        _audioManager.songIdNotifier.value != widget.song.id) {
      _initAsync();
    }
  }

  Future<void> _initAsync() async {
    // Create MediaItems
    final mediaItems = (widget.playlist.songList
        .map((song) => MediaItem(
              id: song.id.toString(),
              title: song.name ?? '',
              artist: song.getSingerNames(),
              artUri: Uri.parse(song.image ?? Constants.defaultNetworkImage),
              album: widget.playlist.name,
              extras: {'url': song.linkSong, 'id_playlist': widget.playlist.id},
            ))
        .toList());

    // Stop current playback
    await _audioManager.stop();

    // Clear existing queue
    _audioManager.clearQueue();

    // reset progress bar
    _audioManager.seek(Duration.zero);

    // Add new queue items
    _audioManager.addQueueItems(mediaItems);

    // Play the selected song
    int index = widget.playlist.songList
        .indexWhere((item) => item.id == widget.song.id);
    playSelectedSong(index);
  }

  // Function to play a specific song from the playlist
  void playSelectedSong(int index) {
    _audioManager.skipToQueueItem(index);
    _audioManager.play();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = SizeConfig.screenWidth / 15;
    final pageManager = Provider.of<AudioManager>(context, listen: false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const PlaylistTitle(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: ValueListenableBuilder<List<Color>>(
          valueListenable: pageManager.backgroundColorNotifier,
          builder: (_, backgroundColors, __) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: backgroundColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 35.h),
                    const RotatingSongArt(),
                    SizedBox(height: 25.h),
                    SongName(15.w),
                    SizedBox(height: 5.h),
                    AuthorsName(12.w),
                    SizedBox(height: 20.h),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: AudioProgressBar(),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PlayModeButton(
                            iconSize: iconSize,
                            onTap: () => showPlayModeDialog(context)),
                        PreviousSongButton(iconSize),
                        PlayButton(iconSize),
                        NextSongButton(iconSize),
                        IconButton(
                            iconSize: iconSize,
                            color: Colors.white,
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, widget.song.linkSong!);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        ));
  }

  void _showDeleteConfirmationDialog(BuildContext context, String uri) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.deleteConfirmationTitle),
          content: const Text(Strings.deleteConfirmationContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.no),
            ),
            TextButton(
              onPressed: () {
                deleteSong(context);
                Navigator.of(context).pop();
              },
              child: const Text(Strings.yes),
            ),
          ],
        );
      },
    );
  }

  void deleteSong(BuildContext context) {
    FileUtils.deleteFile(widget.song.linkSong!).then((isSuccess) {
      if (isSuccess) {
        if (context.mounted) {
          Navigator.pop(context, widget.song.linkSong);
        }
      } else {
        ToastUtil.showToast(Strings.deleteFail);
      }
    });
  }

  void showPlayModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayModeDialog(
          onItemClick: (playMode) {
            _audioManager.changePlayMode(playMode);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
