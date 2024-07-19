import '../entity/paginated_response.dart';
import '../entity/singer.dart';

abstract class SingerRepository{
  Future<PaginatedResponse> getSingerByName(String name, int pageNumber, int pageSize);
  Future<List<Singer>> getAllSingers();
}