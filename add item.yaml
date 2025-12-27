import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/pantry_item.dart';

class AddItem extends StatefulWidget {
  final String? suggestedName;

  const AddItem({super.key, this.suggestedName});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  String _selectedCategory = 'Vegetables';
  String _selectedUnit = 'pcs';
  String _selectedLocation = 'General';
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 30));

  final List<String> categories = [
    'Vegetables',
    'Fruits',
    'Dairy',
    'Grains',
    'Spices',
    'Oils',
    'Other'
  ];
  final List<String> units = ['pcs', 'kg', 'g', 'ml', 'l', 'tbsp', 'tsp', 'cup'];
  final List<String> locations = ['General', 'Fridge', 'Freezer', 'Pantry', 'Counter'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.suggestedName ?? '');
    _quantityController = TextEditingController(text: '1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Item Name', _nameController, Icons.shopping_bag),
            const SizedBox(height: 16),
            _buildDropdown('Category', categories, _selectedCategory, (v) {
              setState(() => _selectedCategory = v ?? _selectedCategory);
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child:
                      _buildTextField('Quantity', _quantityController, Icons.numbers),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown('Unit', units, _selectedUnit, (v) {
                    setState(() => _selectedUnit = v ?? _selectedUnit);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdown('Location', locations, _selectedLocation, (v) {
              setState(() => _selectedLocation = v ?? _selectedLocation);
            }),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addItem,
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          keyboardType: label == 'Quantity' ? TextInputType.number : TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String current,
      Function(String?) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: current,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChange,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expiry Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _expiryDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _expiryDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text('${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addItem() async {
    if (_nameController.text.isEmpty || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final provider = Provider.of<InventoryProvider>(context, listen: false);

    PantryItem newItem = PantryItem(
      name: _nameController.text,
      category: _selectedCategory,
      quantity: int.parse(_quantityController.text),
      unit: _selectedUnit,
      expiryDate: _expiryDate,
      location: _selectedLocation,
    );

    await provider.addItem(newItem);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Item added successfully')));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
