import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/step_progress_bar.dart';
import '../../providers/listing_draft_provider.dart';
import '../../../../../core/storage/local_storage_service.dart';

// Simulated asset path used for all "picked" photos
const _kPhotoAsset = 'assets/images/property.jpeg';
const _kMinPhotos = 5;

class ListingPhotosPage extends ConsumerStatefulWidget {
  const ListingPhotosPage({super.key});

  @override
  ConsumerState<ListingPhotosPage> createState() => _ListingPhotosPageState();
}

class _ListingPhotosPageState extends ConsumerState<ListingPhotosPage> {
  late List<String> _photoPaths;

  @override
  void initState() {
    super.initState();
    _photoPaths = List.from(ref.read(listingDraftProvider).photoPaths);
  }

  void _addPhotos(int count) {
    setState(() {
      for (int i = 0; i < count; i++) {
        _photoPaths.add(_kPhotoAsset);
      }
    });
  }

  void _removePhoto(int index) {
    setState(() => _photoPaths.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final count = _photoPaths.length;
    final canProceed = count > 0;
    final meetsMinimum = count >= _kMinPhotos;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/create-listing/step-5'),
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
              Text(
                'You\'ll need $_kMinPhotos photos to get started. You can add\nmore or make changes later.',
                style: const TextStyle(color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 16),

              // ── Action buttons ─────────────────────────────────────────
              _ActionCard(
                icon: Icons.add_photo_alternate_outlined,
                label: 'Add photos',
                onTap: () => _addPhotos(1),
              ),
              const SizedBox(height: 10),
              _ActionCard(
                icon: Icons.photo_camera_outlined,
                label: 'Take new photos',
                onTap: () => _addPhotos(1),
              ),
              const SizedBox(height: 16),

              // ── Photo count indicator ──────────────────────────────────
              if (count > 0) ...[
                Row(
                  children: [
                    Text(
                      '$count photo${count == 1 ? '' : 's'} added',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    if (!meetsMinimum)
                      Text(
                        '(${_kMinPhotos - count} more needed)',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFFE65100)),
                      ),
                    if (meetsMinimum)
                      const Icon(Icons.check_circle,
                          size: 16, color: Color(0xFF2E7D32)),
                  ],
                ),
                const SizedBox(height: 10),
              ],

              // ── Photo grid ─────────────────────────────────────────────
              if (count > 0)
                Expanded(
                  child: GridView.builder(
                    itemCount: count,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _PhotoCard(
                        assetPath: _photoPaths[index],
                        onRemove: () => _removePhoto(index),
                      );
                    },
                  ),
                )
              else
                const Spacer(),

              const SizedBox(height: 12),

              const StepProgressBar(currentStep: 6, totalSteps: 12),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canProceed
                        ? const Color(0xFFF25C2A)
                        : const Color(0xFFBDBDBD),
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
    // Simulate 422 from the publish endpoint when < 5 photos
    if (_photoPaths.length < _kMinPhotos) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEDED),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFFD32F2F),
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Not enough photos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Minimum $_kMinPhotos photos required.\n'
                'You currently have ${_photoPaths.length}.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A8A8A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: [
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
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Add more photos'),
              ),
            ),
          ],
        ),
      );
      return;
    }

    await ref.read(listingDraftProvider.notifier).setPhotoPaths(_photoPaths);
    final storage = ref.read(localStorageServiceProvider);
    final id = ref.read(listingDraftProvider).listingId;
    if (id != null) await storage.saveDraft(id, 7);
    if (mounted) context.go('/create-listing/step-7');
  }
}

// ---------------------------------------------------------------------------
// Photo card with remove button
// ---------------------------------------------------------------------------

class _PhotoCard extends StatelessWidget {
  final String assetPath;
  final VoidCallback onRemove;

  const _PhotoCard({required this.assetPath, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Color(0xFF333333)),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Action card
// ---------------------------------------------------------------------------

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF333333)),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
