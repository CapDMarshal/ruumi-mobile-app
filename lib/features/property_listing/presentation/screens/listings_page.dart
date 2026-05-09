import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _ListingsHeader(),
            const SizedBox(height: 24),
            const Expanded(child: _EmptyState()),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _ListingsHeader extends StatelessWidget {
  const _ListingsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your listings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              _IconCircle(
                icon: Icons.view_agenda_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _IconCircle(
                icon: Icons.add,
                onTap: () {
                  context.go('/listing-intro');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircle({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF333333)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _EmptyIllustration(),
          const SizedBox(height: 24),
          const Text(
            'No listings yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + to create your first listing.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/listings.png',
            width: 200,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}


class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      selectedItemColor: const Color(0xFFF25C2A),
      unselectedItemColor: const Color(0xFF9E9E9E),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.today_outlined),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment_outlined),
          label: 'Listings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }
}
