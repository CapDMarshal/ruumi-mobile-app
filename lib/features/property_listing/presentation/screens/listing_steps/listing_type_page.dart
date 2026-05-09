import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../data/models/listing_models.dart';

// ---------------------------------------------------------------------------
// Known property types — hardcoded with real UUIDs from the API
// ---------------------------------------------------------------------------

/// Returns the asset path for a listing's thumbnail based on its propertyTypeId.
/// Falls back to property-apartment.jpeg for unknown types.
String propertyImageFor(String? propertyTypeId) {
  switch (propertyTypeId) {
    case '26de70d9-9134-4a24-88ab-2130df6507b6': // Apartment
      return 'assets/images/property-apartment.jpeg';
    case '4a9ee4a9-91c6-478d-861b-f47e44e6d46f': // Villa
      return 'assets/images/property-villa.jpeg';
    case 'fa54fc43-9627-41b6-833b-83d0e93a2c5b': // House
      return 'assets/images/property-house.jpeg';
    case '6c823f97-0ff8-4a13-8cf4-065eca191b8a': // Hotel
      return 'assets/images/property-hotel.jpeg';
    case '4e841f5f-ff3c-4c0c-b944-86c918dd5758': // Cabin
      return 'assets/images/property-cabin.jpeg';
    default:
      return 'assets/images/property-apartment.jpeg';
  }
}
const kKnownTypes = [
  KnownType(
    id: '26de70d9-9134-4a24-88ab-2130df6507b6',
    name: 'Apartment',
    icon: Icons.apartment_rounded,
  ),
  KnownType(
    id: '4a9ee4a9-91c6-478d-861b-f47e44e6d46f',
    name: 'Villa',
    icon: Icons.villa_outlined,
  ),
  KnownType(
    id: 'fa54fc43-9627-41b6-833b-83d0e93a2c5b',
    name: 'House',
    icon: Icons.house_outlined,
  ),
  KnownType(
    id: '6c823f97-0ff8-4a13-8cf4-065eca191b8a',
    name: 'Hotel',
    icon: Icons.hotel_outlined,
  ),
  KnownType(
    id: '4e841f5f-ff3c-4c0c-b944-86c918dd5758',
    name: 'Cabin',
    icon: Icons.cabin_outlined,
  ),
];

// Types that exist in the UI but are not yet in the API
const _kComingSoon = [
  _ComingSoonItem(label: 'Condo',        icon: Icons.apartment_outlined),
  _ComingSoonItem(label: 'Townhouse',    icon: Icons.home_work_outlined),
  _ComingSoonItem(label: 'Land',         icon: Icons.terrain_outlined),
  _ComingSoonItem(label: 'Shophouse',    icon: Icons.storefront_outlined),
  _ComingSoonItem(label: 'Retail space', icon: Icons.store_mall_directory_outlined),
  _ComingSoonItem(label: 'Office',       icon: Icons.business_center_outlined),
  _ComingSoonItem(label: 'Warehouse',    icon: Icons.warehouse_outlined),
];

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class ListingTypePage extends ConsumerStatefulWidget {
  const ListingTypePage({super.key});

  @override
  ConsumerState<ListingTypePage> createState() => _ListingTypePageState();
}

class _ListingTypePageState extends ConsumerState<ListingTypePage> {
  /// The selected known type (null = nothing selected yet)
  KnownType? _selected;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Restore previously selected label
    final savedLabel = ref.read(listingDraftProvider).propertyTypeLabel;
    if (savedLabel != null) {
      _selected = kKnownTypes.where(
        (t) => t.name.toLowerCase() == savedLabel.toLowerCase(),
      ).firstOrNull;
    }
  }

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Available types ────────────────────────────────
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: kKnownTypes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.2,
                        ),
                        itemBuilder: (context, index) {
                          final t = kKnownTypes[index];
                          final isSelected = _selected?.id == t.id;
                          return _TypeCard(
                            label: t.name,
                            icon: t.icon,
                            selected: isSelected,
                            onTap: () => setState(() => _selected = t),
                          );
                        },
                      ),

                      // ── Coming soon section ────────────────────────────
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Text(
                            'Coming soon',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Divider(color: Color(0xFFE0E0E0)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _kComingSoon.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.2,
                        ),
                        itemBuilder: (context, index) {
                          return _ComingSoonCard(item: _kComingSoon[index]);
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const StepProgressBar(currentStep: 1, totalSteps: 12),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selected == null
                        ? const Color(0xFFBDBDBD)
                        : const Color(0xFFF25C2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (_selected == null || _isSubmitting) ? null : _onNext,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onNext() async {
    final type = _selected;
    if (type == null) return;
    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(listingDraftProvider.notifier)
          .setPropertyTypeLabel(type.name);

      final draftState = ref.read(listingDraftProvider);

      if (draftState.listingId != null) {
        // Draft already exists — update the property type if it changed
        final currentTypeId = draftState.listingData?.propertyTypeId;
        if (currentTypeId != type.id) {
          await ref.read(listingDraftProvider.notifier).updateDraft(
            ListingUpdate(propertyTypeId: type.id),
            draftState.currentStep,
          );
        }
        if (mounted) context.go('/create-listing/step-2');
        return;
      }

      // No draft yet — create a new one
      await ref.read(listingDraftProvider.notifier).createDraft(
        type.id,
        'ENTIRE_PLACE',
      );

      if (mounted) context.go('/create-listing/step-2');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Selectable type card (API types)
// ---------------------------------------------------------------------------

class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF5F0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                color: selected
                    ? const Color(0xFFF25C2A)
                    : const Color(0xFF333333),
                size: 18),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Coming soon card (greyed out, non-selectable)
// ---------------------------------------------------------------------------

class _ComingSoonCard extends StatelessWidget {
  final _ComingSoonItem item;

  const _ComingSoonCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, color: const Color(0xFFBDBDBD), size: 18),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Soon',
                  style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonItem {
  final String label;
  final IconData icon;

  const _ComingSoonItem({required this.label, required this.icon});
}

class KnownType {
  final String id;
  final String name;
  final IconData icon;

  const KnownType({required this.id, required this.name, required this.icon});
}
