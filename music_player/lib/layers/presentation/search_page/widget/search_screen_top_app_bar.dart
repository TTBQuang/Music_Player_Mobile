import 'package:flutter/material.dart';

import '../../../../utils/strings.dart';
import '../../../domain/entity/search_history.dart';
import '../../../domain/entity/user.dart';
import '../search_viewmodel.dart';

class SearchScreenTopAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SearchScreenTopAppBar({
    super.key,
    required TextEditingController textEditingController,
    required this.user,
    required SearchViewModel searchViewModel,
  })  : _textEditingController = textEditingController,
        _searchViewModel = searchViewModel;

  final TextEditingController _textEditingController;
  final User? user;
  final SearchViewModel _searchViewModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        // if user press enter, save search text to database
        onSubmitted: (searchText) {
          if (user != null) {
            _searchViewModel.saveSearchHistory(SearchHistory(
                id: null,
                user: user!,
                query: searchText,
                time: DateTime.now()));
          }
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
