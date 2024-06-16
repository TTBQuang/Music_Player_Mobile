import 'package:music_player/layers/domain/entity/listen_history.dart';

abstract class ListenHistoryRepository{
  Future<void> saveListenHistory(ListenHistory listenHistory);
}