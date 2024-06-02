import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/playlist_detail/playlist_detail_screen.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/playlist.dart';
import '../../../domain/entity/song.dart';
import '../../../domain/entity/user.dart';
import '../main_viewmodel.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel = Provider.of<MainViewModel>(context);
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    User? user = loginViewModel.user;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            _buildList(context, Strings.newRelease,
                mainViewModel.getNewSongs(0, Constants.pageSizeMainHomeView)),
            if (user != null)
              _buildList(
                  context,
                  Strings.listenRecently,
                  mainViewModel.getRecentListenSongs(
                      user.id, 0, Constants.pageSizeMainHomeView)),
            _buildList(context, Strings.popular,
                mainViewModel.getPopularSongs(0, Constants.pageSizeMainHomeView)),
            _buildList(context, Strings.genre,
                mainViewModel.getGenrePlaylist(0, Constants.pageSizeMainHomeView)),
            _buildList(context, Strings.singer,
                mainViewModel.genSingerPlaylist(0, Constants.pageSizeMainHomeView)),
          ],
        ),
      )),
    );
  }

  Widget _buildList(
      BuildContext context, String title, Future<List<dynamic>> futureItems) {
    return FutureBuilder<List<dynamic>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        } else {
          List<dynamic> items = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: InkWell(
                  onTap: () {},
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
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      dynamic item = items[index];
                      if (item is Song) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: buildSongItem(context, item),
                        );
                      } else if (item is Playlist) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: buildPlaylistItem(context, item),
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

  Widget buildSongItem(BuildContext context, Song item) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Image.network(
            item.image,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: 150,
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.w,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPlaylistItem(BuildContext context, Playlist item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PlaylistDetailScreen.route(item));
      },
      child: Column(
        children: [
          Image.network(
            item.image,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: 150,
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.w,
              ),
            ),
          )
        ],
      ),
    );
  }
}
