import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/recipe.dart';
import '../services/reward_service.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetail({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection('Ingredients', _buildIngredients(context)),
            const SizedBox(height: 24),
            _buildSection('Procedure', _buildProcedure()),
            const SizedBox(height: 24),
            _buildMakeButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(recipe.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${recipe.cookTimeMinutes} min'),
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(recipe.difficulty),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildIngredients(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, _) {
        return Column(
          children: recipe.ingredients
              .map((ing) {
            bool available = inventoryProvider.items.any((item) =>
                item.name.toLowerCase().contains(ing.name.toLowerCase()) &&
                item.quantity >= ing.quantity &&
                !item.isExpired);

            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: available ? Colors.green[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: available ? Colors.green : Colors.orange),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ing.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${ing.quantity} ${ing.unit}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Icon(available ? Icons.check_circle : Icons.warning,
                      color: available ? Colors.green : Colors.orange),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildProcedure() {
    return Text(recipe.procedure);
  }

  Widget _buildMakeButton(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, _) {
        bool canMake = recipe.ingredients.every((ing) =>
            inventoryProvider.items.any((item) =>
                item.name.toLowerCase().contains(ing.name.toLowerCase()) &&
                item.quantity >= ing.quantity &&
                !item.isExpired));

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canMake ? () => _makeRecipe(context, inventoryProvider) : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
            ),
            child: const Text('Made This Dish'),
          ),
        );
      },
    );
  }

  void _makeRecipe(BuildContext context, InventoryProvider inventoryProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Mark this recipe as made? Items will be deducted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              for (var ing in recipe.ingredients) {
                for (var item in inventoryProvider.items) {
                  if (item.name.toLowerCase().contains(ing.name.toLowerCase())) {
                    await inventoryProvider.decrementQuantity(item.id, ing.quantity);
                  }
                }
              }

              await RewardService.addPoints(50);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe completed! +50 points')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Make'),
          ),
        ],
      ),
    );
  }
}
