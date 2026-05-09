import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/step_progress_bar.dart';
import '../providers/listing_draft_provider.dart';
import '../../data/models/listing_models.dart';

class ListingDiscountPage extends ConsumerStatefulWidget {
  const ListingDiscountPage({super.key});

  @override
  ConsumerState<ListingDiscountPage> createState() => _ListingDiscountPageState();
}

class _ListingDiscountPageState extends ConsumerState<ListingDiscountPage> {
  bool _newListingPromo = true;
  bool _lastMinute = true;
  bool _customDiscount = false;
  final _customPercentController = TextEditingController(text: '0');

  @override
  void dispose() {
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
          onPressed: () => context.pop(),
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
                      percentText: '20%',
                      title: 'New listing promotion',
                      subtitle: 'Offer 20% off your first 3 bookings',
                      selected: _newListingPromo,
                      onChanged: (value) => setState(() => _newListingPromo = value),
                    ),
                    const SizedBox(height: 12),
                    _DiscountCard(
                      percentText: '14%',
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
                        child: const Text('Create listing'),
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
    final update = ListingUpdate();
    await ref.read(listingDraftProvider.notifier).updateDraft(update, 12);
    if (mounted) {
      context.go('/create-listing/step-12');
    }
  }
}

class _DiscountCard extends StatelessWidget {
  final String percentText;
  final String title;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _DiscountCard({
    required this.percentText,
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
          _PercentBadge(text: percentText),
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

class _PercentBadge extends StatelessWidget {
  final String text;

  const _PercentBadge({required this.text});

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
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
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
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
        style: const TextStyle(fontWeight: FontWeight.w600),
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
