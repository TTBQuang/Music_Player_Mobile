import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/strings.dart';
import '../../../domain/entity/search_history.dart';
import '../../../domain/entity/user.dart';
import '../search_viewmodel.dart';

class SearchHistoryList extends StatelessWidget {
  const SearchHistoryList({
    super.key,
    required SearchViewModel searchViewModel,
    required this.user,
    required TextEditingController textEditingController,
  })  : _searchViewModel = searchViewModel,
        _textEditingController = textEditingController;

  final SearchViewModel _searchViewModel;
  final User? user;
  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchHistory>>(
      future: _searchViewModel.getSearchHistory(
          user!.id, 0, Constants.pageSizeSearchHistory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.w),
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
                          _textEditingController.text = item.query;
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Chip(
                          label: Text(
                            item.query,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
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
    );
  }
}
