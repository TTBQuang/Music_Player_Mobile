import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_viewmodel.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/main_page/widget/playlist_item.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../utils/list_factory.dart';
import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';
import '../login_page/login_viewmodel.dart';
import '../main_page/widget/main_home_screen.dart';
import '../main_page/widget/song_item_main.dart';
import '../playlist_detail_page/playlist_detail_screen.dart';
import '../playlist_detail_page/widget/navigation_bottom_bar.dart';

class AllItemScreen extends StatefulWidget {
  final String title;
  final ListType listType;

  const AllItemScreen({super.key, required this.title, required this.listType});

  static Route<void> route(String name, ListType listType) {
    return MaterialPageRoute(
      builder: (context) {
        return AllItemScreen(
          title: name,
          listType: listType,
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
              ListFactory listFactory =
                  Provider.of<ListFactory>(context, listen: false);

              Future<PaginatedResponse> futureResponse = listFactory.getList(
                  widget.listType, pageNumber - 1, nRow * nCol, user?.id);

              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(widget.title),
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
                                      return SongItemMain(
                                        song: item,
                                        onItemClick: () {},
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
                                        viewModel
                                            .fetchNewPage(widget.listType,
                                                pageNumber, user?.id)
                                            .then((value) => setState(() {}));
                                      }
                                    },
                                    onNextClick: () {
                                      if (pageNumber < maxPage) {
                                        pageNumber++;
                                        viewModel
                                            .fetchNewPage(widget.listType,
                                                pageNumber, user?.id)
                                            .then((value) => setState(() {}));
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
