import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../data/models/listing_models.dart';
import '../../providers/listing_draft_provider.dart';
import '../../widgets/step_progress_bar.dart';
import 'listing_type_page.dart' show kKnownTypes, KnownType;

class ListingReviewPage extends ConsumerStatefulWidget {
  const ListingReviewPage({super.key});

  @override
  ConsumerState<ListingReviewPage> createState() => _ListingReviewPageState();
}

class _ListingReviewPageState extends ConsumerState<ListingReviewPage> {
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    if (ref.read(listingDraftProvider).listingData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(listingDraftProvider.notifier).ensureListingDataLoaded();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(listingDraftProvider);

    if (_isPublishing) return const _UploadingScreen();

    final isEdit = draft.listingData?.status == 'PUBLISHED';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit listing' : 'Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => isEdit
              ? context.go('/')
              : context.go('/create-listing/step-11'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'Edit your listing' : 'Review your listing',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEdit
                          ? 'Changes are saved immediately to your published listing.'
                          : 'Tap Edit on any section to update it inline.',
                      style: const TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 20),

                    // ── Title ──────────────────────────────────────────────
                    _ReviewSection(
                      title: 'Title',
                      onEdit: () => _editTitle(context, draft),
                      child: _ReviewText(draft.listingData?.title ?? '—'),
                    ),

                    // ── Description ────────────────────────────────────────
                    _ReviewSection(
                      title: 'Description',
                      onEdit: () => _editDescription(context, draft),
                      child: Text(
                        draft.listingData?.description ?? '—',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // ── Property type ──────────────────────────────────────
                    _ReviewSection(
                      title: 'Property Type',
                      onEdit: () => _editPropertyType(context, draft),
                      child: _ReviewText(
                        draft.propertyTypeLabel ??
                            kKnownTypes
                                .where((t) =>
                                    t.id == draft.listingData?.propertyTypeId)
                                .firstOrNull
                                ?.name ??
                            '—',
                      ),
                    ),

                    // ── Location ───────────────────────────────────────────
                    _ReviewSection(
                      title: 'Location',
                      onEdit: () => _editLocation(context, draft),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ReviewText(draft.listingData?.addressLine1 ?? '—'),
                          if (draft.listingData?.city != null)
                            _ReviewText(draft.listingData!.city!),
                          if (draft.listingData?.postalCode != null)
                            _ReviewText(draft.listingData!.postalCode!),
                        ],
                      ),
                    ),

                    // ── Room details ───────────────────────────────────────
                    _ReviewSection(
                      title: 'Room Details',
                      onEdit: () => _editRoomDetails(context, draft),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _ReviewChip(icon: Icons.people_outline,
                              label: '${draft.listingData?.maxGuests ?? 0} guests'),
                          _ReviewChip(icon: Icons.bed_outlined,
                              label: '${draft.listingData?.bedrooms ?? 0} bedrooms'),
                          _ReviewChip(icon: Icons.bathtub_outlined,
                              label: '${draft.listingData?.bathrooms?.toInt() ?? 0} bathrooms'),
                          _ReviewChip(icon: Icons.king_bed_outlined,
                              label: '${draft.beds} beds'),
                          if (draft.listingData?.propertySize != null) ...[
                            _ReviewChip(icon: Icons.square_foot_outlined,
                                label: '${draft.listingData!.propertySize} m² total'),
                            _ReviewChip(icon: Icons.home_outlined,
                                label: '${(draft.listingData!.propertySize! / 0.092903).round()} sqft'),
                          ],
                        ],
                      ),
                    ),

                    // ── Furnished ──────────────────────────────────────────
                    const SizedBox(height: 6),
                    _ReviewSection(
                      title: 'Furnished',
                      onEdit: () => _editFurnished(context, draft),
                      child: _ReviewText(draft.furnishedStatus ?? '—'),
                    ),

                    // ── Amenities ──────────────────────────────────────────
                    _ReviewSection(
                      title: 'Amenities',
                      onEdit: () => _editAmenities(context, draft),
                      child: draft.amenities.isEmpty
                          ? const _ReviewText('None selected')
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: draft.amenities
                                  .map((a) => _AmenityTag(label: a))
                                  .toList(),
                            ),
                    ),

                    // ── Booking type ───────────────────────────────────────
                    _ReviewSection(
                      title: 'Booking Settings',
                      onEdit: () => _editBookingType(context, draft),
                      child: _ReviewText(
                        draft.listingData?.bookingType == 'INSTANT'
                            ? 'Instant Book'
                            : draft.listingData?.bookingType == 'REQUEST'
                                ? 'Approve Manually'
                                : '—',
                      ),
                    ),

                    // ── Price ──────────────────────────────────────────────
                    _ReviewSection(
                      title: 'Base Price',
                      onEdit: () => _editPrice(context, draft),
                      child: _ReviewText(
                        draft.listingData?.basePrice != null
                            ? 'RM ${draft.listingData!.basePrice!.toStringAsFixed(0)} / month'
                            : '—',
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Bottom bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  const StepProgressBar(currentStep: 12, totalSteps: 12),
                  const SizedBox(height: 12),
                  if (draft.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDEDED),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD32F2F)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Color(0xFFD32F2F), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                draft.errorMessage!,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFFD32F2F)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF25C2A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: draft.isLoading
                          ? null
                          : (draft.listingData?.status == 'PUBLISHED'
                              ? _saveAndClose
                              : _publish),
                      child: draft.isLoading
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(draft.listingData?.status == 'PUBLISHED'
                              ? 'Save changes'
                              : 'Publish listing'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Inline edit sheets ────────────────────────────────────────────────────

  void _editPropertyType(BuildContext context, ListingDraftState draft) {
    // Resolve initial selection — try label first, fall back to UUID match
    KnownType? selected = kKnownTypes
        .where((t) => t.name == draft.propertyTypeLabel)
        .firstOrNull;
    selected ??= kKnownTypes
        .where((t) => t.id == draft.listingData?.propertyTypeId)
        .firstOrNull;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 16,
              bottom: 20 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Property Type',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...kKnownTypes.map((t) {
                  final isSelected = selected?.id == t.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _OptionTile(
                      label: t.name,
                      selected: isSelected,
                      onTap: () => setSt(() => selected = t),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: selected == null
                        ? null
                        : () async {
                            Navigator.of(ctx).pop();
                            await ref
                                .read(listingDraftProvider.notifier)
                                .setPropertyTypeLabel(selected!.name);
                            await ref
                                .read(listingDraftProvider.notifier)
                                .updateDraft(
                                  ListingUpdate(
                                      propertyTypeId: selected!.id),
                                  12,
                                );
                          },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _editLocation(BuildContext context, ListingDraftState draft) {
    final addressCtrl = TextEditingController(text: draft.listingData?.addressLine1 ?? '');
    final cityCtrl    = TextEditingController(text: draft.listingData?.city ?? '');
    final zipCtrl     = TextEditingController(text: draft.listingData?.postalCode ?? '');

    // Use saved coordinates or default to KL
    LatLng point = LatLng(
      draft.listingData?.latitude ?? 3.1390,
      draft.listingData?.longitude ?? 101.6869,
    );
    final mapController = MapController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 16,
              bottom: 20 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Location',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Mini map
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 180,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: point,
                        initialZoom: 14,
                        onTap: (_, tapped) async {
                          setSt(() => point = tapped);
                          mapController.move(tapped, mapController.camera.zoom);
                          // Reverse geocode
                          try {
                            final uri = Uri.https(
                              'nominatim.openstreetmap.org', '/reverse',
                              {'format': 'jsonv2', 'lat': tapped.latitude.toString(),
                               'lon': tapped.longitude.toString(), 'addressdetails': '1'},
                            );
                            final res = await http.get(uri,
                                headers: const {'User-Agent': 'ruumi-propertylisting/1.0'});
                            if (res.statusCode == 200) {
                              final data = jsonDecode(res.body) as Map<String, dynamic>;
                              final addr = (data['address'] as Map<String, dynamic>?) ?? {};
                              final road = addr['road']?.toString() ?? '';
                              final house = addr['house_number']?.toString() ?? '';
                              final city = addr['city']?.toString() ??
                                  addr['town']?.toString() ?? '';
                              final postcode = addr['postcode']?.toString() ?? '';
                              setSt(() {
                                if (road.isNotEmpty) {
                                  addressCtrl.text = [house, road].where((s) => s.isNotEmpty).join(' ');
                                }
                                if (city.isNotEmpty) cityCtrl.text = city;
                                if (postcode.isNotEmpty) zipCtrl.text = postcode;
                              });
                            }
                          } catch (_) {}
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.ruumi.propertylisting',
                        ),
                        MarkerLayer(markers: [
                          Marker(
                            point: point,
                            width: 40, height: 40,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xFFF25C2A), shape: BoxShape.circle),
                              child: const Icon(Icons.apartment, color: Colors.white, size: 20),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(controller: addressCtrl, decoration: _inputDeco('Street address', null)),
                const SizedBox(height: 10),
                TextField(controller: cityCtrl, decoration: _inputDeco('City / Town', null)),
                const SizedBox(height: 10),
                TextField(controller: zipCtrl, decoration: _inputDeco('Postal code', null),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      try {
                        await ref.read(listingDraftProvider.notifier).updateDraft(
                          ListingUpdate(
                            latitude: point.latitude,
                            longitude: point.longitude,
                            addressLine1: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
                            city: cityCtrl.text.trim().isEmpty ? null : cityCtrl.text.trim(),
                            postalCode: zipCtrl.text.trim().isEmpty ? null : zipCtrl.text.trim(),
                          ),
                          12,
                        );
                      } catch (_) {}
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _editTitle(BuildContext context, ListingDraftState draft) {
    final ctrl = TextEditingController(text: draft.listingData?.title ?? '');
    _showEditSheet(
      context: context,
      title: 'Edit Title',
      content: StatefulBuilder(builder: (ctx, setSt) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: ctrl,
              maxLength: 32,
              onChanged: (_) => setSt(() {}),
              decoration: _inputDeco('Title', '${ctrl.text.length}/32'),
            ),
            if (ctrl.text.isNotEmpty && ctrl.text.length < 10)
              const Text('Minimum 10 characters',
                  style: TextStyle(fontSize: 12, color: Color(0xFFD32F2F))),
          ],
        );
      }),
      canSave: () => ctrl.text.trim().length >= 10,
      onSave: () async {
        await ref.read(listingDraftProvider.notifier)
            .updateDraft(ListingUpdate(title: ctrl.text.trim()), 12);
      },
    );
  }

  void _editDescription(BuildContext context, ListingDraftState draft) {
    final ctrl = TextEditingController(text: draft.listingData?.description ?? '');
    _showEditSheet(
      context: context,
      title: 'Edit Description',
      content: StatefulBuilder(builder: (ctx, setSt) {
        return TextField(
          controller: ctrl,
          maxLength: 500,
          maxLines: 6,
          minLines: 4,
          onChanged: (_) => setSt(() {}),
          decoration: _inputDeco('Description', '${ctrl.text.length}/500'),
        );
      }),
      canSave: () => ctrl.text.trim().isNotEmpty,
      onSave: () async {
        await ref.read(listingDraftProvider.notifier)
            .updateDraft(ListingUpdate(description: ctrl.text.trim()), 12);
      },
    );
  }

  void _editPrice(BuildContext context, ListingDraftState draft) {
    final saved = draft.listingData?.basePrice;
    final ctrl = TextEditingController(
        text: saved != null && saved > 0 ? saved.toStringAsFixed(0) : '');
    _showEditSheet(
      context: context,
      title: 'Edit Base Price',
      content: StatefulBuilder(builder: (ctx, setSt) {
        return TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setSt(() {}),
          decoration: _inputDeco('Price (RM)', null),
        );
      }),
      canSave: () => (double.tryParse(ctrl.text.trim()) ?? 0) > 0,
      onSave: () async {
        final price = double.tryParse(ctrl.text.trim()) ?? 0;
        await ref.read(listingDraftProvider.notifier)
            .updateDraft(ListingUpdate(basePrice: price), 12);
      },
    );
  }

  void _editBookingType(BuildContext context, ListingDraftState draft) {
    String? selected = draft.listingData?.bookingType;
    _showEditSheet(
      context: context,
      title: 'Edit Booking Settings',
      content: StatefulBuilder(builder: (ctx, setSt) {
        return Column(
          children: [
            _OptionTile(
              label: 'Instant Book',
              subtitle: 'Guests can book automatically.',
              selected: selected == 'INSTANT',
              onTap: () => setSt(() => selected = 'INSTANT'),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              label: 'Approve Manually',
              subtitle: 'You review each booking request.',
              selected: selected == 'REQUEST',
              onTap: () => setSt(() => selected = 'REQUEST'),
            ),
          ],
        );
      }),
      canSave: () => selected != null,
      onSave: () async {
        await ref.read(listingDraftProvider.notifier)
            .updateDraft(ListingUpdate(bookingType: selected), 12);
      },
    );
  }

  void _editRoomDetails(BuildContext context, ListingDraftState draft) {
    int guests    = draft.listingData?.maxGuests ?? 0;
    int bedrooms  = draft.listingData?.bedrooms ?? 0;
    int bathrooms = draft.listingData?.bathrooms?.toInt() ?? 0;
    int beds      = draft.beds;

    // Restore saved area — convert sqm back to sqft for display
    final savedSqm = draft.listingData?.propertySize?.toDouble() ?? 0;
    final indoorCtrl = TextEditingController(
      text: savedSqm > 0 ? (savedSqm / 0.092903).toStringAsFixed(0) : '',
    );
    final outdoorCtrl = TextEditingController();
    final plotCtrl    = TextEditingController();
    bool useSqft = true;

    _showEditSheet(
      context: context,
      title: 'Edit Room Details',
      content: StatefulBuilder(builder: (ctx, setSt) {
        InputDecoration areaDeco(String label) => InputDecoration(
          labelText: label,
          hintText: '0',
          suffixText: useSqft ? 'sqft' : 'sqm',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF25C2A)),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CounterRow(label: 'Guests',    value: guests,    onChanged: (v) => setSt(() => guests = v)),
            _CounterRow(label: 'Bedrooms',  value: bedrooms,  onChanged: (v) => setSt(() => bedrooms = v)),
            _CounterRow(label: 'Bathrooms', value: bathrooms, onChanged: (v) => setSt(() => bathrooms = v)),
            _CounterRow(label: 'Beds',      value: beds,      onChanged: (v) => setSt(() => beds = v)),
            const SizedBox(height: 12),
            // Unit toggle
            Row(
              children: [
                const Text('Area unit:', style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A))),
                const SizedBox(width: 8),
                _UnitToggle(
                  useSqft: useSqft,
                  onToggle: () {
                    // Convert existing values when switching unit
                    String convert(String raw) {
                      final v = double.tryParse(raw.trim());
                      if (v == null || v == 0) return '';
                      final result = useSqft ? v * 0.092903 : v / 0.092903;
                      return result.toStringAsFixed(0);
                    }
                    final newIndoor  = convert(indoorCtrl.text);
                    final newOutdoor = convert(outdoorCtrl.text);
                    final newPlot    = convert(plotCtrl.text);
                    setSt(() {
                      useSqft = !useSqft;
                      indoorCtrl.text  = newIndoor;
                      outdoorCtrl.text = newOutdoor;
                      plotCtrl.text    = newPlot;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: indoorCtrl, keyboardType: TextInputType.number,
                decoration: areaDeco('Indoor area')),
            const SizedBox(height: 8),
            TextField(controller: outdoorCtrl, keyboardType: TextInputType.number,
                decoration: areaDeco('Outdoor area')),
            const SizedBox(height: 8),
            TextField(controller: plotCtrl, keyboardType: TextInputType.number,
                decoration: areaDeco('Plot size')),
          ],
        );
      }),
      canSave: () => true,
      onSave: () async {
        await ref.read(listingDraftProvider.notifier).setBeds(beds);

        // Sum all areas and convert to sqm
        double parse(String raw) => double.tryParse(raw.trim()) ?? 0;
        final total = parse(indoorCtrl.text) +
            parse(outdoorCtrl.text) +
            parse(plotCtrl.text);
        final sqm = total > 0
            ? (useSqft ? total * 0.092903 : total).round()
            : null;

        await ref.read(listingDraftProvider.notifier).updateDraft(
          ListingUpdate(
            maxGuests: guests,
            bedrooms: bedrooms,
            bathrooms: bathrooms.toDouble(),
            propertySize: sqm,
          ),
          12,
        );
      },
    );
  }

  void _editFurnished(BuildContext context, ListingDraftState draft) {
    String? selected = draft.furnishedStatus;
    const options = ['Unfurnished', 'Partly furnished', 'Fully furnished'];
    _showEditSheet(
      context: context,
      title: 'Edit Furnished Status',
      content: StatefulBuilder(builder: (ctx, setSt) {
        return Column(
          children: options.map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionTile(
              label: opt,
              selected: selected == opt,
              onTap: () => setSt(() => selected = opt),
            ),
          )).toList(),
        );
      }),
      canSave: () => selected != null,
      onSave: () async {
        await ref.read(listingDraftProvider.notifier).setFurnishedStatus(selected);
      },
    );
  }

  void _editAmenities(BuildContext context, ListingDraftState draft) {
    final selected = Set<String>.from(draft.amenities);
    const allAmenities = [
      'WiFi', 'Air Conditioning', 'Kitchen', 'Dedicated Workspace', 'TV',
      'Swimming Pool', 'Gym', 'Free Parking', 'Elevator', 'Security 24/7',
      'Smoke Alarm', 'Fire Extinguisher',
    ];
    _showEditSheet(
      context: context,
      title: 'Edit Amenities',
      content: StatefulBuilder(builder: (ctx, setSt) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allAmenities.map((a) {
            final isSelected = selected.contains(a);
            return GestureDetector(
              onTap: () => setSt(() {
                if (isSelected) selected.remove(a); else selected.add(a);
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0),
                  ),
                  color: Colors.white,
                ),
                child: Text(a,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? const Color(0xFFF25C2A) : const Color(0xFF333333),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
      canSave: () => true,
      onSave: () async {
        await ref.read(listingDraftProvider.notifier).setAmenities(selected.toList());
      },
    );
  }

  // ── Generic sheet helper ──────────────────────────────────────────────────

  void _showEditSheet({
    required BuildContext context,
    required String title,
    required Widget content,
    required bool Function() canSave,
    required Future<void> Function() onSave,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) {
        return StatefulBuilder(builder: (ctx, setSt) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 16,
              bottom: 20 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                content,
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: canSave()
                        ? () async {
                            Navigator.of(ctx).pop();
                            try {
                              await onSave();
                            } catch (e) {
                              // error surfaces via draft.errorMessage
                            }
                          }
                        : null,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> _publish() async {
    setState(() => _isPublishing = true);
    try {
      await ref.read(listingDraftProvider.notifier).publishListing();
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 1800));
        if (mounted) context.go('/');
      }
    } catch (e) {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  /// For published listings — changes are already saved via PATCH on each
  /// inline edit, so just invalidate the list and go home.
  Future<void> _saveAndClose() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully.'),
          backgroundColor: Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) context.go('/');
    }
  }

  InputDecoration _inputDeco(String label, String? counter) {
    return InputDecoration(
      labelText: label,
      counterText: counter ?? '',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF25C2A)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Uploading screen
// ---------------------------------------------------------------------------

class _UploadingScreen extends StatelessWidget {
  const _UploadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset('assets/images/upload.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Finalizing Your Uploads...',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Please stay on this screen while we prepare your\nproperty files for the listing.',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8A)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, size: 14, color: Color(0xFF26A69A)),
                  SizedBox(width: 6),
                  Text('We handle all data per our privacy policy',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A))),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _ReviewSection extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final Widget child;

  const _ReviewSection({required this.title, required this.onEdit, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF555555))),
                GestureDetector(
                  onTap: onEdit,
                  child: const Text('Edit',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFF25C2A),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _ReviewText extends StatelessWidget {
  final String text;
  const _ReviewText(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)));
}

class _ReviewChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ReviewChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF8A8A8A)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
      ],
    );
  }
}

class _AmenityTag extends StatelessWidget {
  final String label;
  const _AmenityTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    this.subtitle,
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0)),
          color: selected ? const Color(0xFFFFF5F0) : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8A8A8A))),
                  ],
                ],
              ),
            ),
            Container(
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected
                        ? const Color(0xFFF25C2A)
                        : const Color(0xFFCFCFCF),
                    width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                            color: Color(0xFFF25C2A), shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _CounterRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          _Btn(icon: Icons.remove, onTap: value > 0 ? () => onChanged(value - 1) : null),
          SizedBox(
            width: 32,
            child: Text(value.toString(), textAlign: TextAlign.center),
          ),
          _Btn(icon: Icons.add, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _Btn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: onTap == null ? const Color(0xFFF3F3F3) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF333333)),
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final bool useSqft;
  final VoidCallback onToggle;

  const _UnitToggle({required this.useSqft, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitOption(label: 'sqft', selected: useSqft,  onTap: useSqft ? null : onToggle),
          _UnitOption(label: 'sqm',  selected: !useSqft, onTap: useSqft ? onToggle : null),
        ],
      ),
    );
  }
}

class _UnitOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _UnitOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFFF25C2A) : const Color(0xFF8A8A8A),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
