import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/step_progress_bar.dart';
import '../providers/listing_draft_provider.dart';
import '../../data/models/listing_models.dart';

class ListingDescriptionPage extends ConsumerStatefulWidget {
  const ListingDescriptionPage({super.key});

  @override
  ConsumerState<ListingDescriptionPage> createState() => _ListingDescriptionPageState();
}

class _ListingDescriptionPageState extends ConsumerState<ListingDescriptionPage> {
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = _descriptionController.text.length;
    final canProceed = length > 0;

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
                      'Create your description for your\nproperty.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Describe the unique qualities that set your\nlocation apart.',
                      style: TextStyle(color: Color(0xFF8A8A8A)),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      maxLength: 500,
                      maxLines: 10,
                      minLines: 8,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        counterText: '$length/500',
                        hintText: 'Describe your property...',
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
                    const StepProgressBar(currentStep: 8, totalSteps: 12),
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
    final update = ListingUpdate(description: _descriptionController.text.trim());
    await ref.read(listingDraftProvider.notifier).updateDraft(update, 9);
    if (mounted) {
      context.go('/create-listing/step-9');
    }
  }
}
