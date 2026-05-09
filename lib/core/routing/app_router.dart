import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/property_listing/presentation/screens/listings_page.dart';
import '../../features/property_listing/presentation/screens/listing_intro_page.dart';
import '../../features/property_listing/presentation/screens/listing_type_page.dart';
import '../../features/property_listing/presentation/screens/listing_location_page.dart';
import '../../features/property_listing/presentation/screens/listing_room_details_page.dart';
import '../../features/property_listing/presentation/screens/listing_furnished_page.dart';
import '../../features/property_listing/presentation/screens/listing_amenities_page.dart';
import '../../features/property_listing/presentation/screens/listing_photos_page.dart';
import '../../features/property_listing/presentation/screens/listing_title_page.dart';
import '../../features/property_listing/presentation/screens/listing_description_page.dart';
import '../../features/property_listing/presentation/screens/listing_booking_settings_page.dart';
import '../../features/property_listing/presentation/screens/listing_price_page.dart';
import '../../features/property_listing/presentation/screens/listing_discount_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ListingsPage(),
      ),
      GoRoute(
        path: '/listing-intro',
        builder: (context, state) => const ListingIntroPage(),
      ),
      GoRoute(
        path: '/listing-start',
        builder: (context, state) => const PlaceholderScreen(title: 'Start options'),
      ),
      GoRoute(
        path: '/create-listing',
        builder: (context, state) => const ListingTypePage(),
      ),
      GoRoute(
        path: '/create-listing/step-2',
        builder: (context, state) => const ListingLocationPage(),
      ),
      GoRoute(
        path: '/create-listing/step-3',
        builder: (context, state) => const ListingRoomDetailsPage(),
      ),
      GoRoute(
        path: '/create-listing/step-4',
        builder: (context, state) => const ListingFurnishedPage(),
      ),
      GoRoute(
        path: '/create-listing/step-5',
        builder: (context, state) => const ListingAmenitiesPage(),
      ),
      GoRoute(
        path: '/create-listing/step-6',
        builder: (context, state) => const ListingPhotosPage(),
      ),
      GoRoute(
        path: '/create-listing/step-7',
        builder: (context, state) => const ListingTitlePage(),
      ),
      GoRoute(
        path: '/create-listing/step-8',
        builder: (context, state) => const ListingDescriptionPage(),
      ),
      GoRoute(
        path: '/create-listing/step-9',
        builder: (context, state) => const ListingBookingSettingsPage(),
      ),
      GoRoute(
        path: '/create-listing/step-10',
        builder: (context, state) => const ListingPricePage(),
      ),
      GoRoute(
        path: '/create-listing/step-11',
        builder: (context, state) => const ListingDiscountPage(),
      ),
      GoRoute(
        path: '/create-listing/step-12',
        builder: (context, state) => const PlaceholderScreen(title: 'Step 12: Review & Publish'),
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
