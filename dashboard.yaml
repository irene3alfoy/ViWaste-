import 'package:flutter/material.dart';
import '../ocr/bill_scanner.dart';
import '../inventory/add_item.dart';
import '../inventory/inventory_list.dart';
import '../recipes/recipes_page.dart';
import '../rewards/rewards_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Widget tile(BuildContext c, String t, Widget p) {
    return GestureDetector(
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => p)),
      child: Card(
        elevation: 4,
        child: Center(child: Text(t, style: const TextStyle(fontSize: 16))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pantry Inventory")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          tile(context, "Scan Bill", const BillScanner()),
          tile(context, "Add Item", const AddItem()),
          tile(context, "Inventory", const InventoryList()),
          tile(context, "AI Recipes", const RecipesPage()),
          tile(context, "Rewards", const RewardsPage()),
        ],
      ),
    );
  }
}
