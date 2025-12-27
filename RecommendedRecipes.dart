import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../models/pantry_item.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _allRecipes = [
    Recipe(
      name: 'Simple Tomato Pasta',
      description: 'Quick and easy tomato pasta',
      ingredients: [
        RecipeIngredient(name: 'pasta', quantity: 200, unit: 'g'),
        RecipeIngredient(name: 'tomato', quantity: 3, unit: 'pcs'),
        RecipeIngredient(name: 'garlic', quantity: 2, unit: 'cloves'),
        RecipeIngredient(name: 'oil', quantity: 2, unit: 'tbsp'),
      ],
      procedure:
          '1. Boil pasta in salted water\n2. Chop tomatoes and garlic\n3. Heat oil, add garlic\n4. Add tomatoes and simmer\n5. Mix with pasta',
      difficulty: 'Easy',
      cookTimeMinutes: 20,
    ),
    Recipe(
      name: 'Vegetable Stir Fry',
      description: 'Healthy vegetable stir fry',
      ingredients: [
        RecipeIngredient(name: 'onion', quantity: 1, unit: 'pcs'),
        RecipeIngredient(name: 'carrot', quantity: 2, unit: 'pcs'),
        RecipeIngredient(name: 'capsicum', quantity: 1, unit: 'pcs'),
        RecipeIngredient(name: 'oil', quantity: 2, unit: 'tbsp'),
      ],
      procedure:
          '1. Chop all vegetables\n2. Heat oil in pan\n3. Add onions first\n4. Add other vegetables\n5. Stir fry until tender',
      difficulty: 'Easy',
      cookTimeMinutes: 15,
    ),
    Recipe(
      name: 'Rice and Beans',
      description: 'Nutritious rice and beans combo',
      ingredients: [
        RecipeIngredient(name: 'rice', quantity: 200, unit: 'g'),
        RecipeIngredient(name: 'beans', quantity: 150, unit: 'g'),
        RecipeIngredient(name: 'onion', quantity: 1, unit: 'pcs'),
      ],
      procedure:
          '1. Soak beans overnight\n2. Boil beans until soft\n3. Cook rice separately\n4. Mix both with sauteed onions',
      difficulty: 'Medium',
      cookTimeMinutes: 45,
    ),
  ];

  List<Recipe> getRecommendedRecipes(List<PantryItem> availableItems) {
    return _allRecipes.where((recipe) {
      int matchCount = 0;
      for (var ingredient in recipe.ingredients) {
        final hasItem = availableItems.any((item) =>
            item.name.toLowerCase().contains(ingredient.name.toLowerCase()) &&
            !item.isExpired &&
            item.quantity >= ingredient.quantity);
        if (hasItem) matchCount++;
      }
      return matchCount >= (recipe.ingredients.length * 0.7);
    }).toList();
  }

  bool canMakeRecipe(Recipe recipe, List<PantryItem> availableItems) {
    for (var ingredient in recipe.ingredients) {
      final hasItem = availableItems.any((item) =>
          item.name.toLowerCase().contains(ingredient.name.toLowerCase()) &&
          !item.isExpired &&
          item.quantity >= ingredient.quantity);
      if (!hasItem) return false;
    }
    return true;
  }
}
