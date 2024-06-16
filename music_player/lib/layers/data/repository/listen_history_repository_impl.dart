import 'package:music_player/layers/data/dto/listen_history_dto.dart';
import 'package:music_player/layers/data/source/network/listen_history_network.dart';
import 'package:music_player/layers/domain/entity/listen_history.dart';
import 'package:music_player/layers/domain/repository/listen_history_repository.dart';

class ListenHistoryRepositoryImpl extends ListenHistoryRepository {
  final ListenHistoryNetwork listenHistoryNetwork;

  ListenHistoryRepositoryImpl(this.listenHistoryNetwork);

  @override
  Future<void> saveListenHistory(ListenHistory listenHistory) async {
    listenHistoryNetwork
        .saveListenHistory(ListenHistoryDto.fromListenHistory(listenHistory));
  }
}
