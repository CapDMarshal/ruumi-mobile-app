import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../../../core/storage/local_storage_service.dart';

class ListingAmenitiesPage extends ConsumerStatefulWidget {
  const ListingAmenitiesPage({super.key});

  @override
  ConsumerState<ListingAmenitiesPage> createState() => _ListingAmenitiesPageState();
}

class _ListingAmenitiesPageState extends ConsumerState<ListingAmenitiesPage> {
  late final Set<String> _selected;
  final Map<String, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    _selected = Set.from(ref.read(listingDraftProvider).amenities);
  }

  final Map<String, List<String>> _sections = const {
    'Essential Amenities': [
      'WiFi',
      'Air Conditioning',
      'Kitchen',
      'Dedicated Workspace',
      'TV',
    ],
    'Building Facilities': [
      'Swimming Pool',
      'Gym',
      'Free Parking',
      'Elevator',
      'Security 24/7',
    ],
    'Safety': [
      'Smoke Alarm',
      'Fire Extinguisher',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-4'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tell guests what your place has\nto offer',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You can add more amenities after you publish\nyour listing.',
                      style: TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 20),
                    ..._sections.entries.map((entry) {
                      _expanded.putIfAbsent(entry.key, () => false);
                      return _AmenitySection(
                        title: entry.key,
                        items: entry.value,
                        selected: _selected,
                        onToggle: _toggleAmenity,
                        expanded: _expanded[entry.key] ?? false,
                        onToggleExpand: () => _toggleExpand(entry.key),
                      );
                    }),
                    const SizedBox(height: 16),
                    const StepProgressBar(currentStep: 5, totalSteps: 12),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF25C2A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _submitAndNext,
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleAmenity(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  void _toggleExpand(String key) {
    setState(() {
      _expanded[key] = !(_expanded[key] ?? false);
    });
  }

  Future<void> _submitAndNext() async {
    await ref.read(listingDraftProvider.notifier).setAmenities(_selected.toList());
    final storage = ref.read(localStorageServiceProvider);
    final id = ref.read(listingDraftProvider).listingId;
    if (id != null) await storage.saveDraft(id, 6);
    if (mounted) context.go('/create-listing/step-6');
  }
}

class _AmenitySection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final bool expanded;
  final VoidCallback onToggleExpand;

  const _AmenitySection({
    required this.title,
    required this.items,
    required this.selected,
    required this.onToggle,
    required this.expanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final visibleItems = expanded ? items : items.take(4).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: visibleItems.map((label) {
              final isSelected = selected.contains(label);
              return _AmenityChip(
                label: label,
                selected: isSelected,
                onTap: () => onToggle(label),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onToggleExpand,
            child: Text(
              expanded ? 'Show less' : 'Show more',
              style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AmenityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0);
    final textColor = selected ? const Color(0xFFF25C2A) : const Color(0xFF333333);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ),
    );
  }
}
