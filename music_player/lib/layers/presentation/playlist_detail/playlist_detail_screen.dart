import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/presentation/playlist_detail/playlist_detail_viewmodel.dart';
import 'package:music_player/layers/presentation/playlist_detail/widget/song_item.dart';
import 'package:music_player/layers/presentation/playlist_detail/widget/blurred_header.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../base_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  static Route<void> route(Playlist playlist) {
    return MaterialPageRoute(
      builder: (context) {
        return PlaylistDetailScreen(playlist: playlist);
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _PlaylistDetailState();
  }
}

class _PlaylistDetailState extends State<PlaylistDetailScreen> {
  late Future<void> _loadSongsFuture;

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<PlaylistDetailViewModel>(context, listen: false);
    viewModel.playlist = widget.playlist;
    _loadSongsFuture = viewModel.getSongsInPlaylist().then((value) {
      viewModel.playlist?.songList.clear();
      viewModel.playlist?.songList.addAll(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(() => Consumer<PlaylistDetailViewModel>(
          builder: (context, viewModel, child) {
            final headerHeight = SizeConfig.screenHeight / 4 +
                MediaQuery.of(context).padding.top +
                50;

            final int maxPage = (viewModel.playlist!.size /
                    Constants.pageSizePlaylistDetailView)
                .ceil();

            return Scaffold(
              body: FutureBuilder<void>(
                future: _loadSongsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: headerHeight,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: BlurredHeader(viewModel.playlist!),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    viewModel.playlist?.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14.w),
                                  ),
                                ),
                                // width of IconButton to balance Row
                                const SizedBox(width: 48),
                              ],
                            ),
                            centerTitle: true,
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final song =
                                    viewModel.playlist?.songList[index];
                                if (song != null) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SongItem(song),
                                  );
                                }
                                return null;
                              },
                              childCount:
                                  viewModel.playlist?.songList.length ?? 0,
                            ),
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (viewModel.pageNumber > 1) {
                                        viewModel.pageNumber--;
                                        viewModel
                                            .fetchNewPage()
                                            .then((value) => setState(() {}));
                                      }
                                    },
                                    icon: const Icon(Icons.navigate_before),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: Text(
                                      viewModel.pageNumber.toString(),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (viewModel.pageNumber < maxPage) {
                                        viewModel.pageNumber++;
                                        viewModel
                                            .fetchNewPage()
                                            .then((value) => setState(() {}));
                                      }
                                    },
                                    icon: const Icon(Icons.navigate_next),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            );
          },
        ));
  }
}
