import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PlaceholderScreen(title: 'Home / Listing List'),
      ),
      GoRoute(
        path: '/create-listing',
        builder: (context, state) => const PlaceholderScreen(title: 'Step 1: Property Type'),
      ),
      GoRoute(
        path: '/create-listing/step-2',
        builder: (context, state) => const PlaceholderScreen(title: 'Step 2: Location'),
      ),
      GoRoute(
        path: '/create-listing/step-3',
        builder: (context, state) => const PlaceholderScreen(title: 'Step 3: Room Details'),
      ),
      GoRoute(
        path: '/create-listing/step-4',
        builder: (context, state) => const PlaceholderScreen(title: 'Step 4: Title & Description'),
      ),
      GoRoute(
        path: '/create-listing/step-5',
        builder: (context, state) => const PlaceholderScreen(title: 'Step 5: Price & Publish'),
      ),
    ],
  );
}

// Temporary placeholder screen until UI is implemented based on Figma
class PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Placeholder for $title'),
      ),
    );
  }
}
