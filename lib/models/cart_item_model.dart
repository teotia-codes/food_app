class CartItemModel {
  final String itemId;
  final String name;
  final int qty;
  final double price;

  CartItemModel({
    required this.itemId,
    required this.name,
    required this.qty,
    required this.price,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      itemId: map['itemId'],
      name: map['name'],
      qty: map['qty'],
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'qty': qty,
      'price': price,
    };
  }
}