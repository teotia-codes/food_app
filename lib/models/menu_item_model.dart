class MenuItemModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final bool isAvailable;
  final String imageBase64;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.isAvailable,
    required this.imageBase64,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map, String id) {
  return MenuItemModel(
    id: id,
    name: map["name"] ?? "",
    price: (map["price"] as num?)?.toDouble() ?? 0,
    description: map["description"] ?? "",
    category: map["category"] ?? "",
    isAvailable: map["isAvailable"] ?? true,
    imageBase64: map["imageBase64"] ?? "",
  );
}

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "description": description,
      "category": category,
      "isAvailable": isAvailable,
      "imageBase64": imageBase64,
    };
  }
}