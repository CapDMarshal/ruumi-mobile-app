import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../data/models/listing_models.dart';

class ListingPricePage extends ConsumerStatefulWidget {
  const ListingPricePage({super.key});

  @override
  ConsumerState<ListingPricePage> createState() => _ListingPricePageState();
}

class _ListingPricePageState extends ConsumerState<ListingPricePage> {
  late final TextEditingController _priceController;
  bool _flexibleEnabled = false;
  bool _showFlexibleInfo = false;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(listingDraftProvider).listingData?.basePrice;
    _priceController = TextEditingController(
      text: saved != null && saved > 0 ? saved.toStringAsFixed(0) : '650',
    );
    if (ref.read(listingDraftProvider).listingData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(listingDraftProvider.notifier).ensureListingDataLoaded();
      });
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ListingDraftState>(listingDraftProvider, (prev, next) {
      if (prev?.listingData == null && next.listingData != null) {
        final price = next.listingData!.basePrice;
        if (price != null && price > 0) {
          setState(() => _priceController.text = price.toStringAsFixed(0));
        }
      }
    });

    final basePrice = _parsePrice();
    final canProceed = basePrice > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-9'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Now, set the base price for\nproperty rent',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You can change this at any time.',
                    style: TextStyle(color: Color(0xFF8A8A8A)),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'RM',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const Text(
                          '/mo',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color(0xFFF25C2A)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.edit, size: 16, color: Color(0xFF8A8A8A)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Guest price RM675',
                          style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.expand_more, size: 16, color: Color(0xFF8A8A8A)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _flexibleEnabled,
                          onChanged: (value) {
                            setState(() {
                              _flexibleEnabled = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFF25C2A),
                        ),
                        const Text('Enable Flexible Price'),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _showFlexibleInfo = true),
                          child: const Icon(Icons.info_outline, size: 16, color: Color(0xFFF25C2A)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.auto_fix_high, color: Color(0xFFF25C2A), size: 16),
                      label: const Text('Get recommendation price'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF333333),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Learn more about pricing',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                    ),
                  ),
                  const Spacer(),
                  const StepProgressBar(currentStep: 10, totalSteps: 12),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            canProceed ? const Color(0xFFF25C2A) : const Color(0xFFBDBDBD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: canProceed ? () => _showBreakdownSheet(basePrice) : null,
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
            if (_showFlexibleInfo)
              _FlexibleInfoDialog(
                onClose: () => setState(() => _showFlexibleInfo = false),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAndNext() async {
    final value = _parsePrice();
    final update = ListingUpdate(basePrice: value);
    try {
      await ref.read(listingDraftProvider.notifier).updateDraft(update, 11);
      if (mounted) context.go('/create-listing/step-11');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: const Color(0xFFD32F2F)),
        );
      }
    }
  }

  double _parsePrice() {
    return double.tryParse(_priceController.text.trim()) ?? 0;
  }

  void _showBreakdownSheet(double basePrice) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _PriceBreakdownSheet(
          basePrice: basePrice,
          onContinue: () {
            Navigator.of(context).pop();
            _submitAndNext();
          },
        );
      },
    );
  }
}

class _FlexibleInfoDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _FlexibleInfoDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enable Flexible Price',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.local_offer_outlined, size: 18, color: Color(0xFFF25C2A)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Establish a minimum and maximum price\nrange for your rental to increase visibility in\nsearch results for various budgets.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.handshake_outlined, size: 18, color: Color(0xFFF25C2A)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'In the "Deal Room," renters can quickly\nsubmit approved offers, streamlining\nnegotiations and speeding up deal closures.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF25C2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onClose,
                  child: const Text('I Understand'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceBreakdownSheet extends StatelessWidget {
  final double basePrice;
  final VoidCallback onContinue;

  const _PriceBreakdownSheet({
    required this.basePrice,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final guestServiceFee = 15.0;
    final taxes = basePrice * 0.10;
    final guestPrice = basePrice + guestServiceFee + taxes;
    final hostServiceFee = basePrice * 0.0075;
    final hostEarnings = basePrice - hostServiceFee;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RM${basePrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const Text(
                '/mo',
                style: TextStyle(fontSize: 14, color: Color(0xFFF25C2A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BreakdownCard(
            title: 'Guest price',
            rows: [
              _BreakdownRow(label: 'Base price', value: basePrice),
              _BreakdownRow(label: 'Guest service fee', value: guestServiceFee),
              _BreakdownRow(label: 'Taxes (10% SST)', value: taxes),
              _BreakdownRow(label: 'Guest price', value: guestPrice, isTotal: true),
            ],
          ),
          const SizedBox(height: 12),
          _BreakdownCard(
            title: 'You earn',
            rows: [
              _BreakdownRow(label: 'Base price', value: basePrice),
              _BreakdownRow(
                label: 'Host service fee (0.75%)',
                value: -hostServiceFee,
                isNegative: true,
              ),
              _BreakdownRow(label: 'You earn', value: hostEarnings, isTotal: true),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF25C2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onContinue,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final String title;
  final List<_BreakdownRow> rows;

  const _BreakdownCard({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool isNegative;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = value.abs().toStringAsFixed(0);
    final prefix = isNegative ? '-' : '';
    final color = isNegative ? const Color(0xFFF25C2A) : const Color(0xFF333333);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF333333),
            ),
          ),
          Text(
            '${prefix}RM$formatted',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
