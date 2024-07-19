import 'package:music_player/layers/data/dto/singer_dto.dart';

import '../../dto/paginated_response_dto.dart';

abstract class SingerNetwork{
  Future<PaginatedResponseDto> getSingerByName(String name, int pageNumber, int pageSize);
  Future<List<SingerDto>> getAllSingers();
}