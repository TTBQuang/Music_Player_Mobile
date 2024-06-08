import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/search_song_page/search_song_viewmodel.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/constants.dart';
import '../../../utils/strings.dart';
import '../../domain/entity/search_history.dart';
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
  final TextEditingController _textEditingController = TextEditingController();
  late SearchSongViewModel _searchSongViewModel;
  final ScrollController _scrollController = ScrollController();
  final _textStreamController = StreamController<String>();
  String oldSearchText = '';
  User? user;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      _textStreamController.add(_textEditingController.text);
    });
    _searchSongViewModel =
        Provider.of<SearchSongViewModel>(context, listen: false);
    final LoginViewModel loginViewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    user = loginViewModel.user;
    _setupDebounce(user);
  }

  void _setupDebounce(User? user) {
    _textStreamController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((searchText) {
      pageNumber = 1;
      if (searchText.isNotEmpty && oldSearchText != searchText) {
        _searchSongViewModel.getSongByName(
            searchText, pageNumber, Constants.pageSizeSearchSongScreen);
      } else {
        setState(() {});
      }
      oldSearchText = searchText;
    });
  }

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
        Consumer<SearchSongViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: Strings.searchHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (searchText) {
                  if (user != null) {
                    _searchSongViewModel.saveSearchHistory(SearchHistory(
                        id: null,
                        user: user!,
                        query: searchText,
                        time: DateTime.now()));
                  }
                },
              ),
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: _textEditingController.text.isEmpty
                  ? FutureBuilder<List<SearchHistory>>(
                      future: _searchSongViewModel.getSearchHistory(
                          user!.id, 0, Constants.pageSizeSearchHistory),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Container();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Container();
                        } else {
                          final searchItems = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Strings.recentlySearch,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.w),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 5,
                                    children: searchItems.map((item) {
                                      return InkWell(
                                        onTap: () {
                                          _textEditingController.text =
                                              item.query;
                                        },
                                        borderRadius: BorderRadius.circular(15),
                                        child: Chip(
                                          label: Text(
                                            item.query,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 10),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final song = viewModel.songs[index];
                                return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: HorizontalSongItem(
                                      song: song,
                                      onItemClick: () {
                                        Navigator.of(context)
                                            .push(SongDetailScreen.route(song));
                                      },
                                    ));
                              },
                              childCount: viewModel.songs.length,
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
                                      viewModel.getSongByName(
                                          _textEditingController.text,
                                          pageNumber,
                                          Constants.pageSizeSearchSongScreen);
                                      _scrollToTop();
                                    }
                                  },
                                  onNextClick: () {
                                    if (pageNumber < viewModel.maxPage) {
                                      pageNumber++;
                                      viewModel.getSongByName(
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
