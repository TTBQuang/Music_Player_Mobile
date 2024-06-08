import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/widget/playlist_item.dart';
import 'package:music_player/layers/presentation/main_page/widget/vertical_song_item.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../../../utils/playlist_factory.dart';
import '../../../domain/entity/playlist.dart';
import '../../../domain/entity/song.dart';
import '../../../domain/entity/user.dart';
import '../../playlist_detail_page/playlist_detail_screen.dart';
import '../../song_detail_page/song_detail_screen.dart';

enum PlayListType {
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
                context, Strings.newRelease, PlayListType.newReleaseSong, user?.id),
            if (user != null)
              _buildList(context, Strings.listenRecently,
                  PlayListType.listenRecentlySong, user.id),
            _buildList(
                context, Strings.popular, PlayListType.popularSong, user?.id),
            _buildList(
                context, Strings.genre, PlayListType.genrePlaylist, user?.id),
            _buildList(
                context, Strings.singer, PlayListType.singerPlaylist, user?.id),
          ],
        ),
      )),
    );
  }

  Widget _buildList(
      BuildContext context, String title, PlayListType playListType, int? userId) {

    PlaylistFactory listFactory = Provider.of<PlaylistFactory>(context, listen: false);
    Future<PaginatedResponse> futureResponse = listFactory.getList(
        playListType, 0, Constants.pageSizeMainHomeView, userId);

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
                        .push(AllItemScreen.route(title, playListType));
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
                          child: VerticalSongItem(
                            song: item,
                            onItemClick: () {
                              Navigator.of(context).push(
                                  SongDetailScreen.route(item));
                            },
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
