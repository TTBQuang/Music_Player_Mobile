import 'package:music_player/layers/domain/entity/user.dart';

class SearchHistory {
  int? id;
  User user;
  String query;
  DateTime time;

  SearchHistory({required this.id, required this.user, required this.query, required this.time});
}