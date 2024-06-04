import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/presentation/main_page/widget/main_home_screen.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/list_factory.dart';

import '../../../utils/size_config.dart';

class AllItemViewModel extends ChangeNotifier {
  List<dynamic> items = [];
  ListFactory listFactory;

  AllItemViewModel(this.listFactory);

  Future<void> fetchNewPage(ListType listType, int pageNumber, int? userId) async {
    int nRow = Constants.rowPerPageAllItemScreen;
    int nCol = (SizeConfig.screenWidth / 175).floor();

    listFactory
        .getList(listType, pageNumber - 1, nRow * nCol, userId)
        .then((value) => {_addItems(value.items)});
  }

  void _addItems(List<dynamic> newItems) {
    items.clear();
    items.addAll(newItems);
  }
}
