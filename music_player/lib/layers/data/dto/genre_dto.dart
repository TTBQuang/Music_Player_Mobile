class GenreDto {
  int id;
  String name;
  String image;

  GenreDto({required this.id, required this.name, required this.image});

  factory GenreDto.fromJson(Map<String, dynamic> json) {
    return GenreDto(
        id: json['id'],
        name: json['name'],
        image: json['image']
    );
  }
}