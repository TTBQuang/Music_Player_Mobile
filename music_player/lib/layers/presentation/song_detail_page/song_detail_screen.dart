import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/listen_history.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/audio_progress_bar.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/authors_name.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/next_song_btn.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/play_button.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/play_mode_button.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/play_mode_dialog.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/playlist_title.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/previous_song_btn.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/rotating_song_art.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/song_name.dart';
import 'package:music_player/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../services/audio_manager.dart';
import '../../../utils/playlist_factory.dart';
import '../../../utils/size_config.dart';
import '../../../utils/strings.dart';
import '../../../utils/toast_util.dart';
import '../../domain/entity/playlist.dart';
import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';
import '../base_screen.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;
  final Playlist? playlist;

  const SongDetailScreen(
      {super.key, required this.song, required this.playlist});

  static Route<void> route({required Song song, required Playlist? playlist}) {
    return MaterialPageRoute(
      builder: (context) {
        return SongDetailScreen(song: song, playlist: playlist);
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _SongDetailState();
  }
}

class _SongDetailState extends State<SongDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AudioManager _audioManager;
  User? user;

  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<SongDetailViewModel>(context, listen: false);
    viewModel.song = widget.song;

    _audioManager = Provider.of<AudioManager>(context, listen: false);
    _audioManager.playlist = widget.playlist;
    _audioManager.saveListenHistory = saveListenHistory;

    // if user listen new song, load data
    if (_audioManager.currentPlaylistIdNotifier.value != widget.playlist?.id ||
        _audioManager.currentSongIdNotifier.value != widget.song.id) {
      _initAsync();
    }
  }

  // save listen history of this song to database
  void saveListenHistory(int songId) {
    final viewModel = Provider.of<SongDetailViewModel>(context, listen: false);

    if (user != null) {
      viewModel.saveListenHistory(ListenHistory(
          id: null,
          user: user!,
          song: Song(
              id: songId,
              name: null,
              image: null,
              linkSong: null,
              releaseDate: null,
              singers: null),
          time: DateTime.now()));
    }
  }

  // load data
  Future<void> _initAsync() async {
    final viewModel = Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    user = loginViewModel.user;

    // reset playlist when user listen to new song
    viewModel.playlist = null;

    if (!PlayListType.values
        .any((type) => type.id != null && type.id == widget.playlist?.id)) {
      // if user don't choose song in three category in main screen
      await viewModel.getALlSongsInPlaylist(widget.playlist);
    } else {
      // if user choose song in three category in main screen
      viewModel.playlist = widget.playlist?.clone();
    }

    // Create MediaItems
    final mediaItems = (viewModel.playlist?.songList
            .map((song) => MediaItem(
                  id: song.id.toString(),
                  title: song.name ?? '',
                  artist: song.getSingerNames(),
                  artUri:
                      Uri.parse(song.image ?? Constants.defaultNetworkImage),
                  album: viewModel.playlist?.name,
                  extras: {
                    'url': song.linkSong,
                    'id_playlist': widget.playlist?.id
                  },
                ))
            .toList() ??
        [
          // if playlist null
          MediaItem(
            id: widget.song.id.toString(),
            title: widget.song.name ?? '',
            artist: widget.song.getSingerNames(),
            album: null,
            artUri:
                Uri.parse(widget.song.image ?? Constants.defaultNetworkImage),
            extras: {'url': widget.song.linkSong},
          )
        ]);

    // Stop current playback
    await _audioManager.stop();

    // Clear existing queue
    _audioManager.clearQueue();

    // reset progress bar
    _audioManager.seek(Duration.zero);

    // Add new queue items
    _audioManager.addQueueItems(mediaItems);

    // Play the selected song
    if (viewModel.playlist == null) {
      playSelectedSong(0);
    } else {
      int index = viewModel.playlist!.songList
          .indexWhere((item) => item.id == widget.song.id);
      playSelectedSong(index);
    }
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

    return BaseScreen(() =>
        Consumer<SongDetailViewModel>(builder: (context, viewModel, child) {
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
                actions: [
                  PopupMenuButton<int>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (item) => _onSelected(context, item),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                          value: 0, child: Text(Strings.addToFavorites)),
                      const PopupMenuItem<int>(
                          value: 1, child: Text(Strings.download)),
                    ],
                  ),
                ],
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
                          SizedBox(height: 30.h),
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
                                icon: const Icon(Icons.thumb_up),
                                color: Colors.white,
                                iconSize: iconSize,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    Strings.comment,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/image/person.png'),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'User Name',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'This is a comment. It looks really nice!',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
        }));
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

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        ToastUtil.showToast(0.toString());
        break;
      case 1:
        ToastUtil.showToast(1.toString());
        break;
    }
  }
}
