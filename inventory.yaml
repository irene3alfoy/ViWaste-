import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/pantry_item.dart';
import 'item_detail.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({super.key});

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<InventoryProvider>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_item'),
        child: const Icon(Icons.add),
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, inventoryProvider, _) {
          List<PantryItem> displayItems = _getFilteredItems(
              inventoryProvider.items, _filterType);

          if (inventoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildFilterTabs(),
                _buildStatsCards(inventoryProvider),
                displayItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.inbox,
                                size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text('No items found'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: displayItems.length,
                        itemBuilder: (context, index) {
                          PantryItem item = displayItems[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemDetail(item: item),
                              ),
                            ),
                            child: _buildItemCard(item),
                          );
                        },
                      ),
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

  Widget _buildStatsCards(InventoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStatCard('Total', provider.items.length.toString(), Colors.blue),
          const SizedBox(width: 12),
          _buildStatCard('Expiring', provider.getExpiringItems().length.toString(),
              Colors.orange),
          const SizedBox(width: 12),
          _buildStatCard('Expired', provider.getExpiredItems().length.toString(),
              Colors.red),
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
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(PantryItem item) {
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
                  Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Qty: ${item.quantity} ${item.unit}',
                      style: const TextStyle(fontSize: 12)),
                  Text(item.location,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
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
      ),
    );
  }

  List<PantryItem> _getFilteredItems(List<PantryItem> items, String filter) {
    switch (filter) {
      case 'expiring':
        return items
            .where((i) => i.daysUntilExpiry <= 7 && i.daysUntilExpiry > 0)
            .toList();
      case 'expired':
        return items.where((i) => i.isExpired).toList();
      default:
        return items;
    }
  }
}
