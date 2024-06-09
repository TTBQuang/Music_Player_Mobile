import '../../dto/paginated_response_dto.dart';

abstract class SingerNetwork{
  Future<PaginatedResponseDto> getSingerByName(String name, int pageNumber, int pageSize);
}