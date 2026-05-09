import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/step_progress_bar.dart';
import '../providers/listing_draft_provider.dart';
import '../../data/models/listing_models.dart';

class ListingBookingSettingsPage extends ConsumerStatefulWidget {
  const ListingBookingSettingsPage({super.key});

  @override
  ConsumerState<ListingBookingSettingsPage> createState() => _ListingBookingSettingsPageState();
}

class _ListingBookingSettingsPageState extends ConsumerState<ListingBookingSettingsPage> {
  String? _selected;

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pick your booking settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can change this at any time.',
                style: TextStyle(color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 20),
              _BookingOptionCard(
                title: 'Approve your bookings manually',
                subtitle:
                    'Start by reviewing reservation requests,\nthen switch to Instant Book, so guests\ncan book automatically.',
                icon: Icons.event_available_outlined,
                selected: _selected == 'MANUAL',
                onTap: () => setState(() => _selected = 'MANUAL'),
              ),
              const SizedBox(height: 12),
              _BookingOptionCard(
                title: 'Use Instant Book',
                subtitle: 'Let guests book automatically.',
                icon: Icons.flash_on_outlined,
                selected: _selected == 'INSTANT',
                onTap: () => setState(() => _selected = 'INSTANT'),
              ),
              const Spacer(),
              const StepProgressBar(currentStep: 9, totalSteps: 12),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selected == null ? const Color(0xFFBDBDBD) : const Color(0xFFF25C2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _selected == null ? null : _submitAndNext,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitAndNext() async {
    final update = ListingUpdate(bookingType: _selected);
    await ref.read(listingDraftProvider.notifier).updateDraft(update, 10);
    if (mounted) {
      context.go('/create-listing/step-10');
    }
  }
}

class _BookingOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _BookingOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFF25C2A) : const Color(0xFFE0E0E0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Align(
              alignment: Alignment.center,
              child: Icon(icon, color: const Color(0xFF333333)),
            ),
          ],
        ),
      ),
    );
  }
}
