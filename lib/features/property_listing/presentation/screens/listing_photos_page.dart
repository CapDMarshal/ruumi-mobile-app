import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/step_progress_bar.dart';
import '../providers/listing_draft_provider.dart';
import '../../data/models/listing_models.dart';

class ListingPhotosPage extends ConsumerStatefulWidget {
  const ListingPhotosPage({super.key});

  @override
  ConsumerState<ListingPhotosPage> createState() => _ListingPhotosPageState();
}

class _ListingPhotosPageState extends ConsumerState<ListingPhotosPage> {
  int _photoCount = 0;

  @override
  Widget build(BuildContext context) {
    final canProceed = _photoCount > 0;

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
                'Add some photos of your\nproperty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'You\'ll need 5 photos to get started. You can add\nmore or make changes later.',
                style: TextStyle(color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 20),
              _ActionCard(
                icon: Icons.add,
                label: 'Add photos',
                onTap: () => setState(() => _photoCount = 5),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.photo_camera_outlined,
                label: 'Take new photos',
                onTap: () => setState(() => _photoCount = 5),
              ),
              const Spacer(),
              const StepProgressBar(currentStep: 6, totalSteps: 12),
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
                  onPressed: canProceed ? _submitAndNext : null,
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
    final update = ListingUpdate();
    await ref.read(listingDraftProvider.notifier).updateDraft(update, 7);
    if (mounted) {
      context.go('/create-listing/step-7');
    }
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF333333)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
