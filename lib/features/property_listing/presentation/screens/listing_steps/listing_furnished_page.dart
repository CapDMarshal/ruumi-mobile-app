import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../../../core/storage/local_storage_service.dart';

class ListingFurnishedPage extends ConsumerStatefulWidget {
  const ListingFurnishedPage({super.key});

  @override
  ConsumerState<ListingFurnishedPage> createState() => _ListingFurnishedPageState();
}

class _ListingFurnishedPageState extends ConsumerState<ListingFurnishedPage> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(listingDraftProvider).furnishedStatus;
  }

  final List<String> _options = const [
    'Unfurnished',
    'Partly furnished',
    'Fully furnished',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-3'),
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
                'How is your house available?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enhance your list with additional information',
                style: TextStyle(color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 20),
              ..._options.map((option) {
                final selected = _selected == option;
                return _FurnishedOption(
                  label: option,
                  selected: selected,
                  onTap: () => setState(() => _selected = option),
                );
              }),
              const Spacer(),
              const StepProgressBar(currentStep: 4, totalSteps: 12),
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
    await ref.read(listingDraftProvider.notifier).setFurnishedStatus(_selected);
    // Furnished is UI-only — just advance step locally, no PATCH needed
    final storage = ref.read(localStorageServiceProvider);
    final id = ref.read(listingDraftProvider).listingId;
    if (id != null) await storage.saveDraft(id, 5);
    ref.read(listingDraftProvider.notifier);
    if (mounted) context.go('/create-listing/step-5');
  }
}

class _FurnishedOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FurnishedOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFFF25C2A) : const Color(0xFFCFCFCF),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF25C2A),
                          shape: BoxShape.circle,
                        ),
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
