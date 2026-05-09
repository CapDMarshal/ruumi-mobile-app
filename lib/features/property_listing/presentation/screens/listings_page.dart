import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/listing_repository.dart';
import '../../data/models/listing_models.dart';
import '../providers/listing_draft_provider.dart';
import 'listing_steps/listing_type_page.dart' show propertyImageFor;

part 'listings_page.g.dart';

// ---------------------------------------------------------------------------
// Property types provider (cached for the session)
// ---------------------------------------------------------------------------

@riverpod
Future<List<PropertyTypeResponse>> propertyTypes(Ref ref) async {
  return ref.watch(listingRepositoryProvider).getPropertyTypes();
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class ListingsPage extends ConsumerStatefulWidget {
  const ListingsPage({super.key});

  @override
  ConsumerState<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends ConsumerState<ListingsPage> {
  String? _activeFilterId;
  String? _activeFilterLabel;
  int _pageSize = 10;
  int _currentPage = 0;

  int get _offset => _currentPage * _pageSize;

  void _goToPage(int page) => setState(() => _currentPage = page);
  void _setPageSize(int size) => setState(() {
        _pageSize = size;
        _currentPage = 0;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _ListingsHeader(
              activeFilterLabel: _activeFilterLabel,
              onFilter: _showFilterSheet,
              onAdd: () async {
                await ref.read(listingDraftProvider.notifier).startFresh();
                if (context.mounted) context.go('/listing-intro');
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _ListingsBody(
                activeFilterId: _activeFilterId,
                limit: _pageSize,
                offset: _offset,
                currentPage: _currentPage,
                pageSize: _pageSize,
                onPageChanged: _goToPage,
                onPageSizeChanged: _setPageSize,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _FilterSheetWrapper(
        activeFilterId: _activeFilterId,
        onSelect: (id, label) {
          setState(() {
            _activeFilterId = id;
            _activeFilterLabel = label;
          });
          Navigator.of(ctx).pop();
        },
        onClear: () {
          setState(() {
            _activeFilterId = null;
            _activeFilterLabel = null;
          });
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _ListingsHeader extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onFilter;
  final String? activeFilterLabel;

  const _ListingsHeader({
    required this.onAdd,
    required this.onFilter,
    required this.activeFilterLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isFiltered = activeFilterLabel != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your listings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              if (isFiltered)
                Text(
                  'Filtered: $activeFilterLabel',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFFF25C2A)),
                ),
            ],
          ),
          Row(
            children: [
              _IconCircle(
                icon: Icons.filter_list_rounded,
                onTap: onFilter,
                active: isFiltered,
              ),
              const SizedBox(width: 12),
              _IconCircle(icon: Icons.add, onTap: onAdd),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _IconCircle({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF0EB) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(18),
          border: active
              ? Border.all(color: const Color(0xFFF25C2A), width: 1.5)
              : null,
        ),
        child: Icon(icon, size: 20,
            color: active ? const Color(0xFFF25C2A) : const Color(0xFF333333)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body — async listings list
// ---------------------------------------------------------------------------

class _ListingsBody extends ConsumerWidget {
  final String? activeFilterId;
  final int limit;
  final int offset;
  final int currentPage;
  final int pageSize;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  const _ListingsBody({
    required this.activeFilterId,
    required this.limit,
    required this.offset,
    required this.currentPage,
    required this.pageSize,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(
      listingsProvider(limit: limit, offset: offset),
    );

    return listingsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFF25C2A)),
      ),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_outlined, size: 48, color: Color(0xFFBDBDBD)),
              const SizedBox(height: 12),
              const Text(
                'Could not load listings',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                err.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF25C2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => ref.invalidate(listingsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (allListings) {
        final listings = activeFilterId == null
            ? allListings
            : allListings
                .where((l) => l.propertyTypeId == activeFilterId)
                .toList();

        final hasNextPage = allListings.length == limit;
        final hasPrevPage = currentPage > 0;

        if (listings.isEmpty && currentPage == 0) {
          return activeFilterId != null
              ? const _EmptyFilterState()
              : const _EmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFF25C2A),
                onRefresh: () async =>
                    ref.invalidate(listingsProvider),
                child: listings.isEmpty
                    ? const _EmptyFilterState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                        itemCount: listings.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _ListingCard(listing: listings[index]),
                      ),
              ),
            ),
            _PaginationBar(
              currentPage: currentPage,
              pageSize: pageSize,
              hasNext: hasNextPage,
              hasPrev: hasPrevPage,
              onPrev: hasPrevPage
                  ? () => onPageChanged(currentPage - 1)
                  : null,
              onNext: hasNextPage
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              onPageSizeChanged: onPageSizeChanged,
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Listing card
// ---------------------------------------------------------------------------

class _ListingCard extends ConsumerWidget {
  final ListingResponse listing;

  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDraft = listing.status == 'DRAFT';
    final savedListingId = ref.watch(
      listingDraftProvider.select((s) => s.listingId),
    );
    final savedStep = ref.watch(
      listingDraftProvider.select((s) => s.currentStep),
    );

    // Determine the step to resume: use persisted step if this is the active
    // draft, otherwise fall back to step 2 (first editable step).
    final resumeStep =
        (savedListingId == listing.id) ? savedStep : 2;

    return InkWell(
      onTap: isDraft
          ? () async {
              await ref
                  .read(listingDraftProvider.notifier)
                  .resumeDraft(listing.id, resumeStep);
              if (context.mounted) {
                context.go(_stepRoute(resumeStep));
              }
            }
          : listing.status == 'PUBLISHED'
              ? () {
                  ref
                      .read(listingDraftProvider.notifier)
                      .loadForEdit(listing);
                  context.go('/create-listing/step-12');
                }
              : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDraft
                ? const Color(0xFFFFD6C2)
                : const Color(0xFFE0E0E0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      propertyImageFor(listing.propertyTypeId),
                      fit: BoxFit.cover,
                    ),
                    // Status badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _StatusBadge(status: listing.status),
                    ),
                    // Resume chip for drafts
                    if (isDraft)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFF25C2A)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.edit_outlined,
                                  size: 12,
                                  color: Color(0xFFF25C2A)),
                              const SizedBox(width: 4),
                              Text(
                                'Continue',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFF25C2A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Edit chip for published listings
                    if (listing.status == 'PUBLISHED')
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF2E7D32)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 12, color: Color(0xFF2E7D32)),
                              SizedBox(width: 4),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Card body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title?.isNotEmpty == true
                        ? listing.title!
                        : 'Untitled listing',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: listing.title?.isNotEmpty == true
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF9E9E9E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _locationLabel(listing),
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9E9E9E)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (listing.basePrice != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'RM ${listing.basePrice!.toStringAsFixed(0)} / night',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF25C2A),
                      ),
                    ),
                  ],
                  if (isDraft) ...[
                    const SizedBox(height: 8),
                    _DraftProgressIndicator(
                        currentStep: resumeStep, totalSteps: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _locationLabel(ListingResponse l) {
    final parts = [l.city, l.addressLine1]
        .where((s) => s != null && s.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts.join(', ') : 'Location not set';
  }

  String _stepRoute(int step) {
    if (step <= 1) return '/create-listing';
    if (step > 11) return '/create-listing/step-12';
    return '/create-listing/step-$step';
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDraft = status == 'DRAFT';
    final isPublished = status == 'PUBLISHED';

    final Color bg = isDraft
        ? const Color(0xFFFFF3E0)
        : isPublished
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFF3F3F3);

    final Color fg = isDraft
        ? const Color(0xFFE65100)
        : isPublished
            ? const Color(0xFF2E7D32)
            : const Color(0xFF616161);

    final String label = isDraft
        ? 'Draft'
        : isPublished
            ? 'Published'
            : status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Draft progress mini-bar
// ---------------------------------------------------------------------------

class _DraftProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _DraftProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep - 1) / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFF2F2F2),
            color: const Color(0xFFF25C2A),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Step $currentStep of $totalSteps',
          style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pagination bar
// ---------------------------------------------------------------------------

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int pageSize;
  final bool hasNext;
  final bool hasPrev;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final ValueChanged<int> onPageSizeChanged;

  static const _pageSizeOptions = [2, 5, 10, 20, 50];

  const _PaginationBar({
    required this.currentPage,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrev,
    required this.onPrev,
    required this.onNext,
    required this.onPageSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          // Page size selector
          const Text('Show:', style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A))),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: pageSize,
              isDense: true,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)),
              items: _pageSizeOptions
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text('$s'),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onPageSizeChanged(v);
              },
            ),
          ),
          const Spacer(),
          // Page indicator
          Text(
            'Page ${currentPage + 1}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
          ),
          const SizedBox(width: 12),
          // Prev button
          _NavButton(
            icon: Icons.chevron_left,
            enabled: hasPrev,
            onTap: onPrev,
          ),
          const SizedBox(width: 8),
          // Next button
          _NavButton(
            icon: Icons.chevron_right,
            enabled: hasNext,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: enabled ? onTap : null,
      radius: 18,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFF2F2F2) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? const Color(0xFF333333) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bottom sheet wrapper — watches the provider so it rebuilds
// ---------------------------------------------------------------------------

class _FilterSheetWrapper extends ConsumerWidget {
  final String? activeFilterId;
  final void Function(String id, String label) onSelect;
  final VoidCallback onClear;

  const _FilterSheetWrapper({
    required this.activeFilterId,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(propertyTypesProvider);
    return typesAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFF25C2A)),
        ),
      ),
      error: (_, __) => SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load types'),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF25C2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => ref.invalidate(propertyTypesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (types) => _FilterSheet(
        types: types,
        activeFilterId: activeFilterId,
        onSelect: onSelect,
        onClear: onClear,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bottom sheet
// ---------------------------------------------------------------------------

class _FilterSheet extends StatelessWidget {
  final List<PropertyTypeResponse> types;
  final String? activeFilterId;
  final void Function(String id, String label) onSelect;
  final VoidCallback onClear;

  const _FilterSheet({
    required this.types,
    required this.activeFilterId,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by type',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              if (activeFilterId != null)
                GestureDetector(
                  onTap: onClear,
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFF25C2A),
                        fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: types.map((t) {
              final isActive = t.id == activeFilterId;
              return GestureDetector(
                onTap: () => onSelect(t.id, t.name),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFFFF0EB)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFFF25C2A)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Text(
                    t.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? const Color(0xFFF25C2A)
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty filter state
// ---------------------------------------------------------------------------

class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFBDBDBD)),
            SizedBox(height: 12),
            Text(
              'No listings match this filter',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'Try a different property type.',
              style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _EmptyIllustration(),
          const SizedBox(height: 24),
          const Text(
            'No listings yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + to create your first listing.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Image.asset(
        'assets/images/listings.png',
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom nav
// ---------------------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      selectedItemColor: const Color(0xFFF25C2A),
      unselectedItemColor: const Color(0xFF9E9E9E),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.today_outlined),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment_outlined),
          label: 'Listings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }
}
