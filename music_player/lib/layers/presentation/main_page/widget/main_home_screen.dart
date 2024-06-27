import 'package:flutter/material.dart';
import 'package:music_player/layers/data/dto/playlist_dto.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_screen.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/widget/playlist_item.dart';
import 'package:music_player/layers/presentation/main_page/widget/vertical_song_item.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../utils/playlist_factory.dart';
import '../../../data/dto/song_dto.dart';
import '../../../domain/entity/playlist.dart';
import '../../../domain/entity/song.dart';
import '../../../domain/entity/user.dart';
import '../../playlist_detail_page/playlist_detail_screen.dart';
import '../../song_detail_page/song_detail_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainHomeState();
  }
}

class _MainHomeState extends State<MainHomeScreen> {
  PlaylistFactory? listFactory;
  Future<PaginatedResponse>? responseListenRecentlySong;
  Future<PaginatedResponse>? responsePopularSong;
  Future<PaginatedResponse>? responseNewReleaseSong;
  Future<PaginatedResponse>? responseGenrePlaylist;
  Future<PaginatedResponse>? responseSingerPlaylist;
  User? user;

  // reload recently listen songs list
  Future<void> _refresh() async {
    responseListenRecentlySong = listFactory?.getList(
        playListType: PlayListType.listenRecentlySong,
        pageNumber: 0,
        pageSize: Constants.pageSizeMainHomeView,
        userId: user?.id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);

    user = loginViewModel.user;

    // load song lists
    listFactory = Provider.of<PlaylistFactory>(context, listen: false);
    responseListenRecentlySong = listFactory?.getList(
        playListType: PlayListType.listenRecentlySong,
        pageNumber: 0,
        pageSize: Constants.pageSizeMainHomeView,
        userId: user?.id);
    responsePopularSong = listFactory?.getList(
        playListType: PlayListType.popularSong,
        pageNumber: 0,
        pageSize: Constants.pageSizeMainHomeView,
        userId: user?.id);
    responseNewReleaseSong = listFactory?.getList(
        playListType: PlayListType.newReleaseSong,
        pageNumber: 0,
        pageSize: Constants.pageSizeMainHomeView,
        userId: user?.id);
    responseGenrePlaylist = listFactory?.getList(
        playListType: PlayListType.genrePlaylist,
        pageNumber: 0,
        pageSize: Constants.pageSizeMainHomeView,
        userId: user?.id);
    responseSingerPlaylist = listFactory?.getList(
        playListType: PlayListType.singerPlaylist,
        pageNumber: 0,
        pageSize: Constants.pageSizeMainHomeView,
        userId: user?.id);

    return BaseScreen(() => RefreshIndicator(
        onRefresh: _refresh,
        child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                if (user != null)
                  _buildList(responseListenRecentlySong!,
                      PlayListType.listenRecentlySong),
                _buildList(responsePopularSong!, PlayListType.popularSong),
                _buildList(
                    responseNewReleaseSong!, PlayListType.newReleaseSong),
                _buildList(responseGenrePlaylist!, PlayListType.genrePlaylist),
                _buildList(
                    responseSingerPlaylist!, PlayListType.singerPlaylist),
              ],
            ),
          )),
        )));
  }

  // build UI of title and a list
  Widget _buildList(
      Future<PaginatedResponse> futureResponse, PlayListType playListType) {
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
          if (response.totalItems <= 0) {
            return const SizedBox.shrink();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(AllItemScreen.route(playListType));
                    },
                    borderRadius: BorderRadius.circular(0),
                    child: Row(
                      children: [
                        Text(
                          playListType.title,
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
                        if (item is SongDto) {
                          Song song = Song.fromSongDto(item, user?.id);
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: VerticalSongItem(
                              song: song,
                              onItemClick: () async {
                                // get full playlist of current PlaylistType to use in SongDetailScreen
                                Playlist? playlist = await listFactory
                                    ?.getPlaylistByPlayListType(
                                        playListType, user?.id);

                                if (context.mounted) {
                                  Navigator.of(context).push(
                                      SongDetailScreen.route(
                                          song: song, playlist: playlist));
                                }
                              },
                            ),
                          );
                        } else if (item is PlaylistDto) {
                          Playlist playlist = Playlist.fromPlaylistDto(item);
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: PlaylistItem(
                                playlist: playlist,
                                onItemClick: () {
                                  Navigator.of(context).push(
                                      PlaylistDetailScreen.route(playlist));
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
        }
      },
    );
  }
}
