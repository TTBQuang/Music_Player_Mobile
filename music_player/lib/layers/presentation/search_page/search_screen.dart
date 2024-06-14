import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/playlist_detail_page/playlist_detail_screen.dart';
import 'package:music_player/layers/presentation/search_page/search_viewmodel.dart';
import 'package:music_player/layers/presentation/search_page/widget/horizontal_singer_item.dart';
import 'package:music_player/layers/presentation/search_page/widget/search_history_list.dart';
import 'package:music_player/layers/presentation/search_page/widget/search_screen_top_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/constants.dart';
import '../../domain/entity/singer.dart';
import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';
import '../playlist_detail_page/widget/horizontal_song_item.dart';
import '../playlist_detail_page/widget/navigation_bottom_bar.dart';
import '../song_detail_page/song_detail_screen.dart';

class SearchSongScreen extends StatefulWidget {
  const SearchSongScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return const SearchSongScreen();
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return SearchSongState();
  }
}

class SearchSongState extends State<SearchSongScreen> {
  int pageNumber = 1;
  late SearchViewModel _searchViewModel;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final _textStreamController = StreamController<String>();

  // When the TextField is focused, the onTextChanged function is called, so this variable is used to limit the number of API calls
  String oldSearchText = '';
  User? user;
  final List<SearchType> categories = [
    SearchType.song,
    SearchType.singer,
  ];
  int selectedIndex = 0; // Variable to track the selected category index

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      _textStreamController.add(_textEditingController.text);
    });

    _searchViewModel = Provider.of<SearchViewModel>(context, listen: false);
    final LoginViewModel loginViewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    user = loginViewModel.user;
    _setupDebounce(user);
  }

  // If the user doesn't type any additional words within 500ms, the API will be called
  void _setupDebounce(User? user) {
    _textStreamController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((searchText) {
      pageNumber = 1;

      // if text field contains words, call api to load new items
      if (searchText.isNotEmpty && oldSearchText != searchText) {
        _searchViewModel.getItemByName(categories[selectedIndex], searchText,
            pageNumber, Constants.pageSizeSearchSongScreen);
      } else if (oldSearchText != searchText) {
        // if text field don't contains words, switch to SearchHistoryList widget
        setState(() {});
      }
      oldSearchText = searchText;
    });
  }

  // scroll to top when switch to new page
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(() =>
        Consumer<SearchViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SearchScreenTopAppBar(
                textEditingController: _textEditingController,
                user: user,
                searchViewModel: _searchViewModel),
            body: SafeArea(
              child: _textEditingController.text.isEmpty && user != null
                  ? SearchHistoryList(
                      searchViewModel: _searchViewModel,
                      user: user,
                      textEditingController: _textEditingController)
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: categories.map((category) {
                                    int index = categories.indexOf(category);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ChoiceChip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        label: Text(category.title),
                                        selected: selectedIndex == index,
                                        onSelected: (selected) {
                                          // if user choose another category, load new items and update UI
                                          setState(() {
                                            selectedIndex = index;
                                            pageNumber = 1;
                                          });

                                          viewModel.getItemByName(
                                              SearchType.values[selectedIndex],
                                              _textEditingController.text,
                                              pageNumber,
                                              Constants
                                                  .pageSizeSearchSongScreen);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 10),
                          sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = viewModel.items[index];
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: item is Song
                                    ? HorizontalSongItem(
                                        song: item,
                                        onItemClick: () {
                                          Navigator.of(context).push(
                                              SongDetailScreen.route(song: item, playlist: null));
                                        },
                                      )
                                    : item is Singer
                                        ? HorizontalSingerItem(
                                            singer: item,
                                            onItemClick: () async {
                                              // call api to get playlist base in singerId
                                              // then navigate to PlaylistDetailScreen
                                              Playlist playlist =
                                                  await viewModel
                                                      .getPlaylistBySingerId(
                                                          item.id);
                                              if (context.mounted) {
                                                Navigator.of(context).push(
                                                    PlaylistDetailScreen.route(
                                                        playlist));
                                              }
                                            },
                                          )
                                        : null, // In case the item is neither Song nor Singer
                              );
                            },
                            childCount: viewModel.items.length,
                          )),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              NavigationBottomBar(
                                  onPrevClick: () {
                                    // switch to next page of list items
                                    if (pageNumber > 1) {
                                      pageNumber--;
                                      viewModel.getItemByName(
                                          categories[selectedIndex],
                                          _textEditingController.text,
                                          pageNumber,
                                          Constants.pageSizeSearchSongScreen);
                                      _scrollToTop();
                                    }
                                  },
                                  onNextClick: () {
                                    // switch to previous page of list items
                                    if (pageNumber < viewModel.maxPage) {
                                      pageNumber++;
                                      viewModel.getItemByName(
                                          categories[selectedIndex],
                                          _textEditingController.text,
                                          pageNumber,
                                          Constants.pageSizeSearchSongScreen);
                                      _scrollToTop();
                                    }
                                  },
                                  pageNumber: pageNumber,
                                  maxPage: viewModel.maxPage),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _textStreamController.close();
    super.dispose();
  }
}
