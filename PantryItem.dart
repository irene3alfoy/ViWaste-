import 'package:uuid/uuid.dart';

class PantryItem {
  final String id;
  final String name;
  final String category;
  int quantity;
  final String unit;
  DateTime expiryDate;
  String location;
  final DateTime addedDate;
  final String? imageUrl;
  final double? price;

  PantryItem({
    String? id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.location,
    DateTime? addedDate,
    this.imageUrl,
    this.price,
  })  : id = id ?? const Uuid().v4(),
        addedDate = addedDate ?? DateTime.now();

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'expiryDate': expiryDate.toIso8601String(),
      'location': location,
      'addedDate': addedDate.toIso8601String(),
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory PantryItem.fromMap(Map<String, dynamic> map) {
    return PantryItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'Other',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? 'pcs',
      expiryDate: DateTime.parse(map['expiryDate'] ?? DateTime.now().toIso8601String()),
      location: map['location'] ?? 'General',
      addedDate: DateTime.parse(map['addedDate'] ?? DateTime.now().toIso8601String()),
      imageUrl: map['imageUrl'],
      price: map['price']?.toDouble(),
    );
  }

  PantryItem copyWith({
    String? name,
    int? quantity,
    DateTime? expiryDate,
    String? location,
  }) {
    return PantryItem(
      id: id,
      name: name ?? this.name,
      category: category,
      quantity: quantity ?? this.quantity,
      unit: unit,
      expiryDate: expiryDate ?? this.expiryDate,
      location: location ?? this.location,
      addedDate: addedDate,
      imageUrl: imageUrl,
      price: price,
    );
  }
}
