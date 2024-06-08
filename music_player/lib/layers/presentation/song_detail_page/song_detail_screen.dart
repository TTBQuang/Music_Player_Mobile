import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_viewmodel.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/toast_util.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import '../../../utils/strings.dart';
import '../../domain/entity/song.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  static Route<void> route(Song song) {
    return MaterialPageRoute(
      builder: (context) {
        return SongDetailScreen(song: song);
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
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  List<Color> backgroundColors = [Colors.white, Colors.black];
  bool isDarkBackground = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();

    final viewModel = Provider.of<SongDetailViewModel>(context, listen: false);
    viewModel.song = widget.song;

    // Disk rotation animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // play music
    _audioPlayer = AudioPlayer();
    //_audioPlayer.play(UrlSource(viewModel.song.linkSong));

    // update duration of audio when user play a new audio file
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    // update current position in slider of audio
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _updatePalette();
  }

  // Skip the song to a certain position
  void _seekToPosition(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
  }

  // update palette of current screen base on image of song
  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.song.image),
    );

    setState(() {
      backgroundColors = paletteGenerator.colors.take(2).toList();
      isDarkBackground = backgroundColors.first.computeLuminance() < 0.5;
    });
  }

  // play or pause music
  void _togglePlayPause(String link) {
    if (isPlaying) {
      _audioPlayer.pause();
      _controller.stop();
    } else {
      _audioPlayer.play(UrlSource(link));
      _controller.repeat();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = SizeConfig.screenWidth / 15;

    return BaseScreen(() =>
        Consumer<SongDetailViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: isDarkBackground ? Colors.white : Colors.black,
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  'Hatsune Miku',
                  style: TextStyle(
                    color: isDarkBackground ? Colors.white : Colors.black,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  PopupMenuButton<int>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDarkBackground ? Colors.white : Colors.black,
                    ),
                    onSelected: (item) => _onSelected(context, item),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                          value: 0, child: Text(Strings.addToFavorites)),
                      const PopupMenuItem<int>(
                          value: 1, child: Text(Strings.download)),
                      const PopupMenuItem<int>(
                          value: 2, child: Text(Strings.seePlaylist)),
                      const PopupMenuItem<int>(
                          value: 3, child: Text(Strings.seeSinger)),
                    ],
                  ),
                ],
              ),
              extendBodyBehindAppBar: true,
              body: Container(
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
                        RotationTransition(
                          turns: _controller,
                          child: Container(
                            width: SizeConfig.screenWidth * 3 / 4,
                            height: SizeConfig.screenWidth * 3 / 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(viewModel.song.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          viewModel.song.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.w,
                            color:
                                isDarkBackground ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Hatsune Miku',
                          style: TextStyle(
                            fontSize: 12.w,
                            color:
                                isDarkBackground ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15),
                              child: Text(
                                '${_position.inMinutes}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')} '
                                '/ ${_duration.inMinutes}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: isDarkBackground
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: isDarkBackground
                                    ? Colors.white
                                    : Colors.black,
                                inactiveColor: Colors.grey,
                                value: _position.inSeconds.toDouble(),
                                min: 0.0,
                                max: _duration.inSeconds.toDouble(),
                                onChanged: (double value) {
                                  setState(() {
                                    _seekToPosition(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.list),
                              //icon: const Icon(Icons.loop),
                              //icon: const Icon(Icons.shuffle),
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
                              iconSize: iconSize,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
                              iconSize: iconSize,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
                              iconSize: iconSize,
                              onPressed: () =>
                                  _togglePlayPause(viewModel.song.linkSong),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
                              iconSize: iconSize,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              color: isDarkBackground
                                  ? Colors.white
                                  : Colors.black,
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
                                      backgroundImage:
                                          AssetImage('assets/image/person.png'),
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
                  )));
        }));
  }

  // select an item in popup menu
  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        ToastUtil.showToast(0.toString());
        break;
      case 1:
        ToastUtil.showToast(1.toString());
        break;
      case 2:
        ToastUtil.showToast(2.toString());
        break;
      case 3:
        ToastUtil.showToast(3.toString());
        break;
    }
  }
}
