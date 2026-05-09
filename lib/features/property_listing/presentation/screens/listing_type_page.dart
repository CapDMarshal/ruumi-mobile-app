import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/step_progress_bar.dart';

class ListingTypePage extends StatefulWidget {
  const ListingTypePage({super.key});

  @override
  State<ListingTypePage> createState() => _ListingTypePageState();
}

class _ListingTypePageState extends State<ListingTypePage> {
  String? _selectedType;

  final List<_ListingTypeItem> _items = const [
    _ListingTypeItem(label: 'House', icon: Icons.house_outlined),
    _ListingTypeItem(label: 'Villa', icon: Icons.villa_outlined),
    _ListingTypeItem(label: 'Condo', icon: Icons.apartment_outlined),
    _ListingTypeItem(label: 'Townhouse', icon: Icons.home_work_outlined),
    _ListingTypeItem(label: 'Apartment', icon: Icons.apartment_rounded),
    _ListingTypeItem(label: 'Land', icon: Icons.terrain_outlined),
    _ListingTypeItem(label: 'Shophouse', icon: Icons.storefront_outlined),
    _ListingTypeItem(label: 'Retail space', icon: Icons.store_mall_directory_outlined),
    _ListingTypeItem(label: 'Office', icon: Icons.business_center_outlined),
    _ListingTypeItem(label: 'Hotel', icon: Icons.apartment_outlined),
    _ListingTypeItem(label: 'Warehouse', icon: Icons.warehouse_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How would you describe your\nproperty?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: _items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final selected = _selectedType == item.label;
                    return _ListingTypeCard(
                      item: item,
                      selected: selected,
                      onTap: () => setState(() => _selectedType = item.label),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              const StepProgressBar(currentStep: 1, totalSteps: 12),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedType == null ? const Color(0xFFBDBDBD) : const Color(0xFFF25C2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _selectedType == null
                      ? null
                      : () {
                          context.go('/create-listing/step-2');
                        },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListingTypeCard extends StatelessWidget {
  final _ListingTypeItem item;
  final bool selected;
  final VoidCallback onTap;

  const _ListingTypeCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0);
    final fillColor = selected ? const Color(0xFFFFF5F0) : Colors.white;
    final iconColor = selected ? const Color(0xFFF25C2A) : const Color(0xFF333333);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: iconColor, size: 18),
            const Spacer(),
            Text(
              item.label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingTypeItem {
  final String label;
  final IconData icon;

  const _ListingTypeItem({required this.label, required this.icon});
}
