import 'package:music_player/layers/data/source/network/singer_network.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/repository/singer_repository.dart';

class SingerRepositoryImpl extends SingerRepository{
  final SingerNetwork singerNetwork;

  SingerRepositoryImpl(this.singerNetwork);

  @override
  Future<PaginatedResponse> getSingerByName(String name, int pageNumber, int pageSize) {
    return singerNetwork.getSingerByName(name, pageNumber, pageSize);
  }
}