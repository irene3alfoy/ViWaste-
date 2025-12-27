import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/inventory_provider.dart';
import '../inventory/inventory_screen.dart';
import '../scanner/scanner_screen.dart';
import '../recipes/recipe_screen.dart';
import '../rewards/rewards_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
      if (authProvider.user != null) {
        inventoryProvider.loadItems(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ScannerScreen(),
      const InventoryScreen(),
      const RecipeScreen(),
      const RewardsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viligo Pantry'),
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showProfileMenu(context, authProvider),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text(
                            (authProvider.user?.name ?? 'U').substring(0, 1).toUpperCase(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.user?.name ?? '',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              '⭐ ${authProvider.user?.rewardPoints ?? 0}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  authProvider.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
