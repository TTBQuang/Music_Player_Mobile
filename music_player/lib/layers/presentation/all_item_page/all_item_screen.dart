import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_viewmodel.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/main_page/widget/playlist_item.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_screen.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../utils/playlist_factory.dart';
import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';
import '../login_page/login_viewmodel.dart';
import '../main_page/widget/vertical_song_item.dart';
import '../playlist_detail_page/playlist_detail_screen.dart';
import '../playlist_detail_page/widget/navigation_bottom_bar.dart';

class AllItemScreen extends StatefulWidget {
  final PlayListType playListType;

  const AllItemScreen({super.key, required this.playListType});

  static Route<void> route(PlayListType playListType) {
    return MaterialPageRoute(
      builder: (context) {
        return AllItemScreen(
          playListType: playListType,
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _AllItemScreenState();
  }
}

class _AllItemScreenState extends State<AllItemScreen> {
  int nRow = Constants.rowPerPageAllItemScreen;
  int nCol = (SizeConfig.screenWidth / 175).floor();
  int pageNumber = 1;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        () => Consumer<AllItemViewModel>(builder: (context, viewModel, child) {
              LoginViewModel loginViewModel =
                  Provider.of<LoginViewModel>(context);
              User? user = loginViewModel.user;
              PlaylistFactory listFactory =
                  Provider.of<PlaylistFactory>(context, listen: false);

              Future<PaginatedResponse> futureResponse = listFactory.getList(
                  playListType: widget.playListType,
                  pageNumber: pageNumber - 1,
                  pageSize: nRow * nCol,
                  userId: user?.id);

              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(widget.playListType.title),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: SafeArea(
                  child: FutureBuilder<PaginatedResponse>(
                    future: futureResponse,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data available'));
                      } else {
                        PaginatedResponse response = snapshot.data!;
                        final maxPage =
                            (response.totalItems / (nRow * nCol)).ceil();
                        viewModel.items.clear();
                        viewModel.items.addAll(response.items);

                        return CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(0),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: nCol,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final item = viewModel.items[index];
                                    if (item is Playlist) {
                                      return PlaylistItem(
                                        playlist: item,
                                        onItemClick: () {
                                          Navigator.of(context).push(
                                              PlaylistDetailScreen.route(item));
                                        },
                                      );
                                    } else if (item is Song) {
                                      return VerticalSongItem(
                                        song: item,
                                        onItemClick: () async {
                                          Playlist? playlist = await listFactory
                                              .getPlaylistByPlayListType(
                                                  widget.playListType,
                                                  user?.id);

                                          if (context.mounted) {
                                            Navigator.of(context).push(
                                                SongDetailScreen.route(
                                                    song: item,
                                                    playlist: playlist));
                                          }
                                        },
                                      );
                                    }
                                    return null;
                                  },
                                  childCount: viewModel.items.length,
                                ),
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  NavigationBottomBar(
                                    onPrevClick: () {
                                      if (pageNumber > 1) {
                                        pageNumber--;
                                        viewModel.fetchNewPage(
                                            widget.playListType,
                                            pageNumber,
                                            user?.id);
                                      }
                                    },
                                    onNextClick: () {
                                      if (pageNumber < maxPage) {
                                        pageNumber++;
                                        viewModel.fetchNewPage(
                                            widget.playListType,
                                            pageNumber,
                                            user?.id);
                                      }
                                    },
                                    pageNumber: pageNumber,
                                    maxPage: maxPage,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              );
            }));
  }
}
