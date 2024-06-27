import '../../domain/entity/paginated_response.dart';

class PaginatedResponseDto {
  List<dynamic> items;
  int totalItems;

  PaginatedResponseDto({required this.items, required this.totalItems});

  factory PaginatedResponseDto.fromJson(Map<String, dynamic> json) {
    return PaginatedResponseDto(
      items: List<dynamic>.from(json['items']),
      totalItems: json['total_items'],
    );
  }
}
