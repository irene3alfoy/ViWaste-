import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/pantry_item_model.dart';
import 'add_item_screen.dart';
import 'item_detail_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreenState> createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddItemScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Consumer2<InventoryProvider, AuthProvider>(
        builder: (context, inventoryProvider, authProvider, _) {
          List<PantryItemModel> displayItems = _getFilteredItems(inventoryProvider);

          if (inventoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildFilterTabs(),
                _buildStatsCards(inventoryProvider),
                _buildItemsList(displayItems, authProvider.user!.uid),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Expiring Soon', 'expiring'),
            const SizedBox(width: 8),
            _buildFilterChip('Expired', 'expired'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String type) {
    return FilterChip(
      label: Text(label),
      selected: _filterType == type,
      onSelected: (bool selected) {
        setState(() => _filterType = type);
      },
    );
  }

  Widget _buildStatsCards(InventoryProvider inventoryProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStatCard(
            'Total Items',
            inventoryProvider.items.length.toString(),
            Colors.blue,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Expiring Soon',
            inventoryProvider.getExpiringItems().length.toString(),
            Colors.orange,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Expired',
            inventoryProvider.getExpiredItems().length.toString(),
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(List<PantryItemModel> items, String userId) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No items found'),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        PantryItemModel item = items[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemDetailScreen(item: item, userId: userId),
            ),
          ),
          child: _buildItemCard(item),
        );
      },
    );
  }

  Widget _buildItemCard(PantryItemModel item) {
    Color statusColor = item.isExpired
        ? Colors.red
        : item.daysUntilExpiry <= 3
            ? Colors.orange
            : item.daysUntilExpiry <= 7
                ? Colors.amber
                : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Qty: ${item.quantity} ${item.unit}', style: const TextStyle(fontSize: 12)),
                  Text(item.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    border: Border.all(color: statusColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.isExpired ? 'Expired' : '${item.daysUntilExpiry}d left',
                    style: TextStyle(fontSize: 11, color: statusColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PantryItemModel> _getFilteredItems(InventoryProvider provider) {
    switch (_filterType) {
      case 'expiring':
        return provider.getExpiringItems();
      case 'expired':
        return provider.getExpiredItems();
      default:
        return provider.items;
    }
  }
}
