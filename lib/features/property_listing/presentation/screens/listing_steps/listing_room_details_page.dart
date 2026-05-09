import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../data/models/listing_models.dart';

class ListingRoomDetailsPage extends ConsumerStatefulWidget {
  const ListingRoomDetailsPage({super.key});

  @override
  ConsumerState<ListingRoomDetailsPage> createState() => _ListingRoomDetailsPageState();
}

class _ListingRoomDetailsPageState extends ConsumerState<ListingRoomDetailsPage> {
  late int _guestCapacity;
  late int _bedrooms;
  late int _bathrooms;
  int _beds = 0;
  bool _petsAllowed = false;

  late final TextEditingController _indoorController;
  late final TextEditingController _outdoorController;
  late final TextEditingController _plotController;

  bool _useSqft = true;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    final draftState = ref.read(listingDraftProvider);
    _beds = draftState.beds;
    _applyData(draftState.listingData);

    _indoorController.addListener(_onAreaChanged);
    _outdoorController.addListener(_onAreaChanged);
    _plotController.addListener(_onAreaChanged);

    // Trigger fetch if listingData is missing (force-close / cold resume)
    if (ref.read(listingDraftProvider).listingData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(listingDraftProvider.notifier).ensureListingDataLoaded();
      });
    }
  }

  void _applyData(ListingResponse? data) {
    _guestCapacity = data?.maxGuests ?? 0;
    _bedrooms      = data?.bedrooms ?? 0;
    _bathrooms     = data?.bathrooms?.toInt() ?? 0;
    final savedSqm = data?.propertySize?.toDouble() ?? 0;
    final display  = savedSqm > 0 ? (savedSqm / 0.092903).toStringAsFixed(0) : '0';
    if (_dataLoaded) {
      // Controllers already exist — just update text
      _indoorController.text = display;
    } else {
      _indoorController  = TextEditingController(text: display);
      _outdoorController = TextEditingController(text: '0');
      _plotController    = TextEditingController(text: '0');
      _dataLoaded = true;
    }
  }

  @override
  void dispose() {
    _indoorController.removeListener(_onAreaChanged);
    _outdoorController.removeListener(_onAreaChanged);
    _plotController.removeListener(_onAreaChanged);
    _indoorController.dispose();
    _outdoorController.dispose();
    _plotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // React when listingData arrives from the async fetch
    ref.listen<ListingDraftState>(listingDraftProvider, (prev, next) {
      if (prev?.listingData == null && next.listingData != null) {
        setState(() {
          _applyData(next.listingData);
          // beds is UI-only — keep the locally restored value, don't overwrite
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-2'),
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
                      'Share some basics about your\nproperty',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You\'ll add more details later, like bed types.',
                      style: TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 20),
                    _CounterRow(
                      label: 'Guest Capacity',
                      value: _guestCapacity,
                      onChanged: (value) => setState(() => _guestCapacity = value),
                    ),
                    _CounterRow(
                      label: 'Bedrooms',
                      value: _bedrooms,
                      onChanged: (value) => setState(() => _bedrooms = value),
                    ),
                    _CounterRow(
                      label: 'Bathrooms',
                      value: _bathrooms,
                      onChanged: (value) => setState(() => _bathrooms = value),
                    ),
                    _CounterRow(
                      label: 'Beds',
                      value: _beds,
                      onChanged: (value) => setState(() => _beds = value),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _petsAllowed,
                          onChanged: (value) =>
                              setState(() => _petsAllowed = value ?? false),
                          activeColor: const Color(0xFFF25C2A),
                        ),
                        const Text('Pets'),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Pets are allowed in this property',
                            style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _AreaInput(
                      label: 'Indoor area',
                      hint:
                          'All space between a floor and a ceiling that is\ncovered by walls, doorways, or windows.',
                      controller: _indoorController,
                      useSqft: _useSqft,
                      onToggleUnit: _toggleUnit,
                    ),
                    _AreaInput(
                      label: 'Outdoor area',
                      hint:
                          'Combined size of the terrace, pool, parking area,\nand surroundings. Do not include the size of the garden.',
                      controller: _outdoorController,
                      useSqft: _useSqft,
                      onToggleUnit: _toggleUnit,
                    ),
                    _AreaInput(
                      label: 'Plot size',
                      hint:
                          'A land plot is a defined parcel of land registered\nwith local authorities.',
                      controller: _plotController,
                      useSqft: _useSqft,
                      onToggleUnit: _toggleUnit,
                    ),
                    const SizedBox(height: 16),
                    const StepProgressBar(currentStep: 3, totalSteps: 12),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _canProceed ? const Color(0xFFF25C2A) : const Color(0xFFBDBDBD),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _canProceed ? _submitAndNext : null,
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

  void _toggleUnit() {
    final indoor = _convertUnit(_indoorController.text);
    final outdoor = _convertUnit(_outdoorController.text);
    final plot = _convertUnit(_plotController.text);

    setState(() {
      _useSqft = !_useSqft;
      if (indoor != null) _indoorController.text = indoor;
      if (outdoor != null) _outdoorController.text = outdoor;
      if (plot != null) _plotController.text = plot;
    });
  }

  String? _convertUnit(String raw) {
    final value = double.tryParse(raw);
    if (value == null) return null;

    final converted = _useSqft ? value * 0.092903 : value / 0.092903;
    return converted.toStringAsFixed(0);
  }

  void _onAreaChanged() {
    setState(() {});
  }

  bool get _canProceed {
    // Allow proceeding if any area is filled OR any counter is set
    return _parseArea(_indoorController.text) > 0 ||
        _parseArea(_outdoorController.text) > 0 ||
        _parseArea(_plotController.text) > 0 ||
        _guestCapacity > 0 ||
        _bedrooms > 0 ||
        _bathrooms > 0;
  }

  double _parseArea(String raw) {
    return double.tryParse(raw) ?? 0;
  }

  Future<void> _submitAndNext() async {
    // Save beds locally (no API field)
    await ref.read(listingDraftProvider.notifier).setBeds(_beds);

    final propertySizeSqm = _sumAreasToSqm(
      _indoorController.text,
      _outdoorController.text,
      _plotController.text,
    );
    final update = ListingUpdate(
      maxGuests: _guestCapacity,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms.toDouble(),
      propertySize: propertySizeSqm,
    );

    try {
      await ref.read(listingDraftProvider.notifier).updateDraft(update, 4);
      if (mounted) {
        context.go('/create-listing/step-4');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
    }
  }

  int? _sumAreasToSqm(String indoorRaw, String outdoorRaw, String plotRaw) {
    final indoor = _parseArea(indoorRaw);
    final outdoor = _parseArea(outdoorRaw);
    final plot = _parseArea(plotRaw);
    final total = indoor + outdoor + plot;
    if (total <= 0) return null;

    final sqmValue = _useSqft ? total * 0.092903 : total;
    return sqmValue.round();
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _CounterRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          _CounterButton(
            icon: Icons.remove,
            onTap: value > 0 ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          _CounterButton(
            icon: Icons.add,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Container(
        width: 28,
        height: 28,
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

class _AreaInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool useSqft;
  final VoidCallback onToggleUnit;

  const _AreaInput({
    required this.label,
    required this.hint,
    required this.controller,
    required this.useSqft,
    required this.onToggleUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '100',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF25C2A)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _UnitToggle(
                useSqft: useSqft,
                onToggle: onToggleUnit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final bool useSqft;
  final VoidCallback onToggle;

  const _UnitToggle({
    required this.useSqft,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _UnitOption(
            label: 'sqft',
            selected: useSqft,
            onTap: useSqft ? null : onToggle,
          ),
          _UnitOption(
            label: 'sqm',
            selected: !useSqft,
            onTap: useSqft ? onToggle : null,
          ),
        ],
      ),
    );
  }
}

class _UnitOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _UnitOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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

