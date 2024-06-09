import '../entity/paginated_response.dart';

abstract class SingerRepository{
  Future<PaginatedResponse> getSingerByName(String name, int pageNumber, int pageSize);
}