import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/presentation/main_page/widget/main_home_screen.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/playlist_factory.dart';

import '../../../utils/size_config.dart';

class AllItemViewModel extends ChangeNotifier {
  List<dynamic> items = [];
  PlaylistFactory listFactory;

  AllItemViewModel(this.listFactory);

  Future<void> fetchNewPage(PlayListType playListType, int pageNumber, int? userId) async {
    int nRow = Constants.rowPerPageAllItemScreen;
    int nCol = (SizeConfig.screenWidth / 175).floor();

    listFactory
        .getList(playListType: playListType, pageNumber: pageNumber - 1, pageSize: nRow * nCol, userId: userId)
        .then((value) => {_addItems(value.items)});

    notifyListeners();
  }

  void _addItems(List<dynamic> newItems) {
    items.clear();
    items.addAll(newItems);
  }
}
