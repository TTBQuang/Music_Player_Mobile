import 'package:music_player/layers/data/dto/listen_history_dto.dart';

abstract class ListenHistoryNetwork {
  Future<void> saveListenHistory(ListenHistoryDto listenHistory);
}