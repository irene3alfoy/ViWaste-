import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pantry_item.dart';

class InventoryProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<PantryItem> _items = [];
  bool _isLoading = false;

  List<PantryItem> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final uid = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('pantry_items')
          .orderBy('addedDate', descending: true)
          .get();

      _items = snapshot.docs.map((doc) => PantryItem.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error loading items: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(PantryItem item) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('pantry_items')
          .doc(item.id)
          .set(item.toMap());

      _items.insert(0, item);
      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Future<void> updateItem(PantryItem item) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('pantry_items')
          .doc(item.id)
          .update(item.toMap());

      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('pantry_items')
          .doc(id)
          .delete();

      _items.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  List<PantryItem> getExpiringItems() {
    return _items
        .where((item) => item.daysUntilExpiry <= 7 && item.daysUntilExpiry > 0)
        .toList();
  }

  List<PantryItem> getExpiredItems() {
    return _items.where((item) => item.isExpired).toList();
  }

  Future<void> decrementQuantity(String itemId, int quantity) async {
    final item = _items.firstWhere((i) => i.id == itemId);
    item.quantity -= quantity;

    if (item.quantity <= 0) {
      await deleteItem(itemId);
    } else {
      await updateItem(item);
    }
  }
}
