import 'package:uuid/uuid.dart';

class PantryItemModel {
  final String id;
  final String userId;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final DateTime expiryDate;
  final String location;
  final DateTime addedDate;
  final String? imageUrl;
  final double? price;
  final String? barcode;

  PantryItemModel({
    String? id,
    required this.userId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.location,
    DateTime? addedDate,
    this.imageUrl,
    this.price,
    this.barcode,
  })  : id = id ?? const Uuid().v4(),
        addedDate = addedDate ?? DateTime.now();

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  int get daysUntilExpiry {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'expiryDate': expiryDate.toIso8601String(),
      'location': location,
      'addedDate': addedDate.toIso8601String(),
      'imageUrl': imageUrl,
      'price': price,
      'barcode': barcode,
    };
  }

  factory PantryItemModel.fromMap(Map<String, dynamic> map) {
    return PantryItemModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'Other',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? 'pcs',
      expiryDate: DateTime.parse(map['expiryDate'] ?? DateTime.now().toIso8601String()),
      location: map['location'] ?? 'General',
      addedDate: DateTime.parse(map['addedDate'] ?? DateTime.now().toIso8601String()),
      imageUrl: map['imageUrl'],
      price: map['price']?.toDouble(),
      barcode: map['barcode'],
    );
  }

  PantryItemModel copyWith({
    String? name,
    int? quantity,
    String? unit,
    DateTime? expiryDate,
    String? location,
    String? imageUrl,
    double? price,
  }) {
    return PantryItemModel(
      id: id,
      userId: userId,
      name: name ?? this.name,
      category: category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      location: location ?? this.location,
      addedDate: addedDate,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      barcode: barcode,
    );
  }
}
