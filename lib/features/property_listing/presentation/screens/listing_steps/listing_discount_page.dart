import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../../../core/storage/local_storage_service.dart';

class ListingDiscountPage extends ConsumerStatefulWidget {
  const ListingDiscountPage({super.key});

  @override
  ConsumerState<ListingDiscountPage> createState() => _ListingDiscountPageState();
}

class _ListingDiscountPageState extends ConsumerState<ListingDiscountPage> {
  late bool _newListingPromo;
  late bool _lastMinute;
  late bool _customDiscount;
  late final TextEditingController _newListingController;
  late final TextEditingController _lastMinuteController;
  late final TextEditingController _customPercentController;

  @override
  void initState() {
    super.initState();
    final s = ref.read(listingDraftProvider);
    _newListingPromo  = s.newListingPromo;
    _lastMinute       = s.lastMinuteDiscount;
    _customDiscount   = s.customDiscount;
    _newListingController     = TextEditingController(text: s.newListingPromoPercent.toString());
    _lastMinuteController     = TextEditingController(text: s.lastMinuteDiscountPercent.toString());
    _customPercentController  = TextEditingController(text: s.customDiscountPercent.toString());
  }

  @override
  void dispose() {
    _newListingController.dispose();
    _lastMinuteController.dispose();
    _customPercentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-10'),
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
                      'Add discounts',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Make your space more appealing to get booked\nquickly and receive your initial reviews.',
                      style: TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 16),
                    _DiscountCard(
                      percentController: _newListingController,
                      title: 'New listing promotion',
                      subtitle: 'Offer 20% off your first 3 bookings',
                      selected: _newListingPromo,
                      onChanged: (value) => setState(() => _newListingPromo = value),
                    ),
                    const SizedBox(height: 12),
                    _DiscountCard(
                      percentController: _lastMinuteController,
                      title: 'Last-minute discount',
                      subtitle: 'For stays booked 14 days or less\nbefore arrival',
                      selected: _lastMinute,
                      onChanged: (value) => setState(() => _lastMinute = value),
                    ),
                    const SizedBox(height: 12),
                    _CustomDiscountCard(
                      controller: _customPercentController,
                      selected: _customDiscount,
                      onChanged: (value) => setState(() => _customDiscount = value),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Only one discount will be applied per stay.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 16),
                    const StepProgressBar(currentStep: 11, totalSteps: 12),
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
                        child: const Text('Review Listing'),
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

  Future<void> _submitAndNext() async {
    await ref.read(listingDraftProvider.notifier).setDiscounts(
      newListingPromo: _newListingPromo,
      newListingPromoPercent: int.tryParse(_newListingController.text) ?? 20,
      lastMinuteDiscount: _lastMinute,
      lastMinuteDiscountPercent: int.tryParse(_lastMinuteController.text) ?? 14,
      customDiscount: _customDiscount,
      customDiscountPercent: int.tryParse(_customPercentController.text) ?? 0,
    );
    final storage = ref.read(localStorageServiceProvider);
    final id = ref.read(listingDraftProvider).listingId;
    if (id != null) await storage.saveDraft(id, 12);
    if (mounted) context.go('/create-listing/step-12');
  }
}

class _DiscountCard extends StatelessWidget {
  final TextEditingController percentController;
  final String title;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _DiscountCard({
    required this.percentController,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _PercentInput(controller: percentController),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ToggleCheck(
            selected: selected,
            onTap: () => onChanged(!selected),
          ),
        ],
      ),
    );
  }
}

class _CustomDiscountCard extends StatelessWidget {
  final TextEditingController controller;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _CustomDiscountCard({
    required this.controller,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _PercentInput(controller: controller),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Special discount',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'Create your custom discount',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ToggleCheck(
            selected: selected,
            onTap: () => onChanged(!selected),
          ),
        ],
      ),
    );
  }
}

class _PercentInput extends StatelessWidget {
  final TextEditingController controller;

  const _PercentInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 3,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          counterText: '',
          suffixText: '%',
          suffixStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: const TextStyle(fontWeight: FontWeight.w600),
        onChanged: (value) {
          final parsed = int.tryParse(value);
          if (parsed == null) return;
          final clamped = parsed.clamp(0, 100);
          if (clamped.toString() != value) {
            controller.value = TextEditingValue(
              text: clamped.toString(),
              selection: TextSelection.collapsed(offset: clamped.toString().length),
            );
          }
        },
      ),
    );
  }
}

class _ToggleCheck extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _ToggleCheck({
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF25C2A) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0),
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}
