class FavoriteModel {
  final String title;
  final String price;
  final String location;
  final String condition;
  final String imageUrl;
  final bool isFavorite;

  FavoriteModel({
    required this.title,
    required this.price,
    required this.location,
    required this.condition,
    required this.imageUrl,
    this.isFavorite = true,
  });
}
