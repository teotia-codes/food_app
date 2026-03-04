import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../services/firestore_service.dart';

class MenuProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<MenuItemModel>> get menuStream => _service.getMenuStream();

  Future<void> addItem(MenuItemModel item) async {
    await _service.addMenuItem(item);
  }

  Future<void> toggleItem(String id, bool value) async {
    await _service.toggleAvailability(id, value);
  }
}