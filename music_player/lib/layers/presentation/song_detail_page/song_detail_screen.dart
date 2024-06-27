import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/listen_history.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/audio_progress_bar.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/authors_name.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/comment_bottom_sheet.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/like_icon_button.dart';
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
import '../../../utils/file_utils.dart';
import '../../../utils/playlist_factory.dart';
import '../../../utils/size_config.dart';
import '../../../utils/strings.dart';
import '../../domain/entity/playlist.dart';
import '../../domain/entity/song.dart';
import '../base_screen.dart';
import '../login_page/login_screen.dart';

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

class _SongDetailState extends State<SongDetailScreen> {
  late final AudioManager _audioManager;
  SongDetailViewModel? songDetailViewModel;
  LoginViewModel? loginViewModel;

  @override
  void initState() {
    super.initState();

    _audioManager = Provider.of<AudioManager>(context, listen: false);
    // save listen history when listen new song
    _audioManager.saveListenHistory = saveListenHistory;
    // reload like, save when listen new song
    _audioManager.loadSong = loadSong;

    loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    // add listener when user login in this screen
    loginViewModel?.addListener(_onUserChange);

    // if user listen new song, load data
    if (_audioManager.playlistIdNotifier.value != widget.playlist?.id ||
        _audioManager.songIdNotifier.value != widget.song.id) {
      _initAsync();
    }
  }

  // save listen history of this song to database
  void saveListenHistory(int songId) {
    final viewModel = Provider.of<SongDetailViewModel>(context, listen: false);

    if (loginViewModel?.user != null) {
      viewModel.saveListenHistory(ListenHistory(
          id: null,
          user: loginViewModel!.user!,
          song: Song(
              id: songId,
              name: null,
              image: null,
              linkSong: null,
              releaseDate: null,
              singers: null,
              isLiked: null,
              isSaved: null,
              numberOfUserLike: null),
          time: DateTime.now()));
    }
  }

  // load info of a song
  Future<void> loadSong(int songId) async {
    songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    Song? song = await songDetailViewModel?.getSongById(
        _audioManager.songIdNotifier.value, loginViewModel!.user?.id);
    _audioManager.isSongSavedNotifier.value = song?.isSaved ?? false;
    _audioManager.isSongLikedNotifier.value = song?.isLiked ?? false;
    _audioManager.numberOfLikesNotifier.value = song?.numberOfUserLike ?? 0;
  }

  // load data
  Future<void> _initAsync() async {
    songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);

    // reset playlist when user listen to new song
    songDetailViewModel?.playlist = null;

    if (!PlayListType.values
        .any((type) => type.id != null && type.id == widget.playlist?.id)) {
      // if user don't choose song in three category in main screen
      if (widget.playlist?.id == Constants.favoriteSongsPlaylistId) {
        // if user choose song in favorite song page
        songDetailViewModel?.playlist = widget.playlist?.clone();
      } else {
        await songDetailViewModel?.getALlSongsInPlaylist(widget.playlist);
      }
    } else {
      // if user choose song in three category in main screen
      songDetailViewModel?.playlist = widget.playlist?.clone();
    }

    // Create MediaItems
    final mediaItems = (songDetailViewModel?.playlist?.songList
            .map((song) => MediaItem(
                  id: song.id.toString(),
                  title: song.name ?? '',
                  artist: song.getSingerNames(),
                  artUri:
                      Uri.parse(song.image ?? Constants.defaultNetworkImage),
                  album: songDetailViewModel?.playlist?.name,
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
    if (songDetailViewModel?.playlist == null) {
      playSelectedSong(0);
    } else {
      int index = songDetailViewModel?.playlist!.songList
              .indexWhere((item) => item.id == widget.song.id) ??
          0;
      playSelectedSong(index);
    }
  }

  @override
  void dispose() {
    loginViewModel?.removeListener(_onUserChange);
    super.dispose();
  }

  void _onUserChange() {
    // load song to update like and save of song
    if (loginViewModel?.user != null) {
      loadSong(_audioManager.songIdNotifier.value);
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
                  ValueListenableBuilder<bool>(
                    valueListenable: _audioManager.isSongSavedNotifier,
                    builder: (context, isSaved, _) {
                      return PopupMenuButton<int>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (item) => _onSelected(context, item),
                        itemBuilder: (context) => [
                          const PopupMenuItem<int>(
                            value: Constants.downloadOption,
                            child: Text(Strings.download),
                          ),
                          PopupMenuItem<int>(
                            value: Constants.saveFavoriteOption,
                            child: Text(isSaved
                                ? Strings.removeFromFavorites
                                : Strings.addToFavorites),
                          ),
                          const PopupMenuItem<int>(
                            value: Constants.seeCommentOption,
                            child: Text(Strings.seeComment),
                          ),
                        ],
                      );
                    },
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
                              LikeIconButton(
                                iconSize: iconSize,
                                updateLikeDatabase: () {
                                  if (loginViewModel!.user?.id != null) {
                                    likeOrUnlikeSong(viewModel);
                                  } else {
                                    Navigator.of(context).push(
                                      LoginScreen.route(canNavigateBack: true),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              ));
        }));
  }

  void likeOrUnlikeSong(SongDetailViewModel viewModel) {
    _audioManager.isSongLikedNotifier.value =
        !_audioManager.isSongLikedNotifier.value;

    // increase or decrease the number of users who like this song
    if (_audioManager.isSongLikedNotifier.value) {
      _audioManager.numberOfLikesNotifier.value++;
    } else {
      _audioManager.numberOfLikesNotifier.value--;
    }

    // update databse
    if (_audioManager.isSongLikedNotifier.value) {
      viewModel.likeSong(
          _audioManager.songIdNotifier.value, loginViewModel!.user!.id);
    } else {
      viewModel.unlikeSong(
          _audioManager.songIdNotifier.value, loginViewModel!.user!.id);
    }
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
      case Constants.downloadOption:
        String url = _audioManager.songUrlNotifier.value;
        String name = _audioManager.songNameNotifier.value;
        FileUtils.startDownload(url, name, context);
        break;
      case Constants.saveFavoriteOption:
        if (loginViewModel!.user?.id != null) {
          saveOrRemoveSong();
        } else {
          Navigator.of(context).push(
            LoginScreen.route(canNavigateBack: true),
          );
        }
        break;
      case Constants.seeCommentOption:
        // show comment bottom sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.8, //The height covers 80% of the screen
              child: CommentBottomSheet(songId: _audioManager.songIdNotifier.value,),
            );
          },
        );
        break;
    }
  }

  // save or remove song from favorite
  void saveOrRemoveSong() {
    _audioManager.isSongSavedNotifier.value =
        !_audioManager.isSongSavedNotifier.value;

    if (_audioManager.isSongSavedNotifier.value) {
      songDetailViewModel?.saveSong(
          _audioManager.songIdNotifier.value, loginViewModel!.user!.id);
    } else {
      songDetailViewModel?.removeSongFromFavorite(
          _audioManager.songIdNotifier.value, loginViewModel!.user!.id);
    }
  }
}
