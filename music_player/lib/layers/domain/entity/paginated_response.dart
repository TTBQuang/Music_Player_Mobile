import 'package:music_player/layers/data/dto/paginated_response_dto.dart';

class PaginatedResponse{
  List<dynamic> items;
  int totalItems;

  PaginatedResponse({required this.items, required this.totalItems});

  factory PaginatedResponse.fromPaginatedResponseDto(PaginatedResponseDto responseDto) {
    return PaginatedResponse(
      items: responseDto.items,
      totalItems: responseDto.totalItems,
    );
  }
}