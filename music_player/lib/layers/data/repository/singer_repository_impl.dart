import 'package:music_player/layers/data/dto/paginated_response_dto.dart';
import 'package:music_player/layers/data/source/network/singer_network.dart';
import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/repository/singer_repository.dart';

class SingerRepositoryImpl extends SingerRepository{
  final SingerNetwork singerNetwork;

  SingerRepositoryImpl(this.singerNetwork);

  @override
  Future<PaginatedResponse> getSingerByName(String name, int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto = await singerNetwork.getSingerByName(name, pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }
}