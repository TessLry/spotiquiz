class Album {
  final String id;
  final String name;
  final String? image;
  final String releaseDate;

  Album(
      {required this.id,
      required this.name,
      this.image,
      required this.releaseDate});
}
