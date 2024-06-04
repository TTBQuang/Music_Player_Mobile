import '../../domain/entity/paginated_response.dart';

class PaginatedResponseDto extends PaginatedResponse {
  PaginatedResponseDto({required super.items, required super.totalItems});

  factory PaginatedResponseDto.fromJson(Map<String, dynamic> json) {
    return PaginatedResponseDto(
      items: List<dynamic>.from(json['items']),
      totalItems: json['total_items'],
    );
  }
}
