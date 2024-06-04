import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/widget/playlist_item.dart';
import 'package:music_player/layers/presentation/main_page/widget/song_item_main.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../../../utils/list_factory.dart';
import '../../../domain/entity/playlist.dart';
import '../../../domain/entity/song.dart';
import '../../../domain/entity/user.dart';
import '../../playlist_detail_page/playlist_detail_screen.dart';

enum ListType {
  newReleaseSong,
  listenRecentlySong,
  popularSong,
  genrePlaylist,
  singerPlaylist,
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    User? user = loginViewModel.user;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            _buildList(
                context, Strings.newRelease, ListType.newReleaseSong, user?.id),
            if (user != null)
              _buildList(context, Strings.listenRecently,
                  ListType.listenRecentlySong, user.id),
            _buildList(
                context, Strings.popular, ListType.popularSong, user?.id),
            _buildList(
                context, Strings.genre, ListType.genrePlaylist, user?.id),
            _buildList(
                context, Strings.singer, ListType.singerPlaylist, user?.id),
          ],
        ),
      )),
    );
  }

  Widget _buildList(
      BuildContext context, String title, ListType listType, int? userId) {

    ListFactory listFactory = Provider.of<ListFactory>(context, listen: false);
    Future<PaginatedResponse> futureResponse = listFactory.getList(
        listType, 0, Constants.pageSizeMainHomeView, userId);

    return FutureBuilder<PaginatedResponse>(
      future: futureResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const SizedBox.shrink();
        } else {
          PaginatedResponse response = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(AllItemScreen.route(title, listType));
                  },
                  borderRadius: BorderRadius.circular(0),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: response.items.length,
                    itemBuilder: (context, index) {
                      dynamic item = response.items[index];
                      if (item is Song) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SongItemMain(
                            song: item,
                            onItemClick: () {},
                          ),
                        );
                      } else if (item is Playlist) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: PlaylistItem(
                              playlist: item,
                              onItemClick: () {
                                Navigator.of(context)
                                    .push(PlaylistDetailScreen.route(item));
                              }),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
