import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingIntroPage extends StatelessWidget {
  const ListingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.go('/'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Getting started with\nRUUMI is simple',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _StepTile(
                icon: Icons.apartment_rounded,
                title: 'Share some details about your location.',
                subtitle:
                    'Share key details like the location and maximum guest capacity.',
              ),
              const SizedBox(height: 14),
              _StepTile(
                icon: Icons.image_outlined,
                title: 'Make it noticeable',
                subtitle:
                    'Upload at least 5 photos along with a title and description, and we\'ll assist you.',
              ),
              const SizedBox(height: 14),
              _StepTile(
                icon: Icons.upload_outlined,
                title: 'Wrap it up and release it.',
                subtitle:
                    'Select a starting price, confirm some details, and then post your listing.',
              ),
              const Spacer(),
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
                  onPressed: () {
                    _showStartSheet(context);
                  },
                  child: const Text('Get started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStartSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const _StartListingSheet();
      },
    );
  }
}

class _StartListingSheet extends StatefulWidget {
  const _StartListingSheet();

  @override
  State<_StartListingSheet> createState() => _StartListingSheetState();
}

class _StartListingSheetState extends State<_StartListingSheet> {
  bool _useApp = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Text(
            'How would you like to start?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose the most convenient way to set up your property listing',
            style: TextStyle(color: Color(0xFF8A8A8A)),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: 'Fill in RUUMI App',
            subtitle: 'Use our guide to list your property at your own pace.',
            icon: Icons.waves_outlined,
            selected: _useApp,
            onTap: () => setState(() => _useApp = true),
          ),
          const SizedBox(height: 12),
          _OptionCard(
            title: 'Fill via WhatsApp',
            subtitle: 'Chat with us and send your photos for quick help.',
            icon: Icons.chat_bubble_outline,
            selected: !_useApp,
            onTap: () => setState(() => _useApp = false),
            badgeText: 'NEW',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _useApp ? const Color(0xFFF25C2A) : const Color(0xFFBDBDBD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _useApp
                  ? () {
                      Navigator.of(context).pop();
                      context.go('/create-listing');
                    }
                  : null,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? badgeText;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badgeText,
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
          color: selected ? const Color(0xFFFFF5F0) : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFDE7DE) : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFF25C2A), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF9F4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEE6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFF25C2A), size: 18),
        ),
        const SizedBox(width: 12),
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
      ],
    );
  }
}
