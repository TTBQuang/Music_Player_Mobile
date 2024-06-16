import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/layers/domain/entity/user.dart';

class ListenHistory {
  int? id;
  User user;
  Song song;
  DateTime time;

  ListenHistory({required this.id, required this.user, required this.song, required this.time});
}