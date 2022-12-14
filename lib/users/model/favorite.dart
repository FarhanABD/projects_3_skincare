class Favorite
{
  int? favorite_id;
  int? user_id;
  int? item_id;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? varians;
  List<String>? sizes;
  String? description;
  String? image;
  int? stok;

  Favorite({
    this.favorite_id,
    this.user_id,
    this.item_id,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.varians,
    this.sizes,
    this.description,
    this.image,
    this.stok,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    favorite_id: int.parse(json['favorite_id']),
    user_id: int.parse(json['user_id']),
    item_id: int.parse(json['item_id']),
    name: json['name'],
    rating: double.parse(json['rating']),
    tags: json['tags'].toString().split(', '),
    price: double.parse(json['price']),
    varians: json['varians'].toString().split(', '),
    sizes: json['sizes'].toString().split(', '),
    description: json['description'],
    image: json['image'],
    stok: int.parse(json['stok']),
  );
}