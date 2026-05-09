import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../data/models/listing_models.dart';

class ListingTitlePage extends ConsumerStatefulWidget {
  const ListingTitlePage({super.key});

  @override
  ConsumerState<ListingTitlePage> createState() => _ListingTitlePageState();
}

class _ListingTitlePageState extends ConsumerState<ListingTitlePage> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: ref.read(listingDraftProvider).listingData?.title ?? '',
    );
    if (ref.read(listingDraftProvider).listingData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(listingDraftProvider.notifier).ensureListingDataLoaded();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ListingDraftState>(listingDraftProvider, (prev, next) {
      if (prev?.listingData == null && next.listingData != null) {
        final title = next.listingData!.title ?? '';
        if (title.isNotEmpty && _titleController.text.isEmpty) {
          setState(() => _titleController.text = title);
        }
      }
    });

    final titleLength = _titleController.text.length;
    final canProceed = titleLength >= 10;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-6'),
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
                      'Let\'s create a title for your\nproperty.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Catchy titles are most effective. Enjoy the\nprocess, you can modify it later.',
                      style: TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      maxLength: 32,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        counterText: '$titleLength/32',
                        hintText: 'Apartment Syariah in Kuala Lumpur',
                        helperText: titleLength > 0 && titleLength < 10
                            ? 'Minimum 10 characters'
                            : null,
                        helperStyle: const TextStyle(color: Color(0xFFD32F2F)),
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
                    const SizedBox(height: 16),
                    const StepProgressBar(currentStep: 7, totalSteps: 12),
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _submitAndNext() async {
    final update = ListingUpdate(title: _titleController.text.trim());
    try {
      await ref.read(listingDraftProvider.notifier).updateDraft(update, 8);
      if (mounted) {
        context.go('/create-listing/step-8');
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
}
