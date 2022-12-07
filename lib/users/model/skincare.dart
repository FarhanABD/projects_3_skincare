class Skincare{
  int? item_id;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? varians;
  List<String>? sizes;
  String? description;
  String? image;

  Skincare({
    this.item_id,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.varians,
    this.sizes,
    this.description,
    this.image,
  });

  factory Skincare.fromJson(Map<String, dynamic> json) => Skincare(
    item_id: int.parse(json["item_id"]),
    name: json["name"],
    rating: double.parse(json["rating"]),
    tags: json["tags"].toString().split(", "),
    price: double.parse(json["price"]),
    varians: json["varians"].toString().split(", "),
    sizes: json["sizes"].toString().split(", "),
    description: json["description"],
    image: json["image"],
  );
}