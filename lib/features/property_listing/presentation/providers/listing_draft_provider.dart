
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../data/listing_repository.dart';
import '../../data/models/listing_models.dart';

part 'listing_draft_provider.g.dart';

// ---------------------------------------------------------------------------
// Listings list provider — paginated
// ---------------------------------------------------------------------------

@riverpod
Future<List<ListingResponse>> listings(
  Ref ref, {
  int limit = 10,
  int offset = 0,
}) async {
  final repo = ref.watch(listingRepositoryProvider);
  return repo.getListings(limit: limit, offset: offset);
}

// ---------------------------------------------------------------------------
// Draft state — holds both API-backed and UI-only fields
// ---------------------------------------------------------------------------

class ListingDraftState {
  final int currentStep;
  final String? listingId;

  /// Full listing data from the API (API-backed fields live here).
  final ListingResponse? listingData;

  final bool isLoading;
  final String? errorMessage;

  // UI-only fields (no API equivalent) — persisted locally
  final String? propertyTypeLabel;     // display label selected on step 1
  final int beds;                      // number of beds (no API field)
  final String? furnishedStatus;       // 'Unfurnished' | 'Partly furnished' | 'Fully furnished'
  final List<String> amenities;        // selected amenity labels
  final List<String> photoPaths;       // local file paths (upload not yet wired)
  final bool newListingPromo;
  final int newListingPromoPercent;
  final bool lastMinuteDiscount;
  final int lastMinuteDiscountPercent;
  final bool customDiscount;
  final int customDiscountPercent;

  ListingDraftState({
    required this.currentStep,
    this.listingId,
    this.listingData,
    this.isLoading = false,
    this.errorMessage,
    this.propertyTypeLabel,
    this.beds = 0,
    this.furnishedStatus,
    this.amenities = const [],
    this.photoPaths = const [],
    this.newListingPromo = true,
    this.newListingPromoPercent = 20,
    this.lastMinuteDiscount = true,
    this.lastMinuteDiscountPercent = 14,
    this.customDiscount = false,
    this.customDiscountPercent = 0,
  });

  ListingDraftState copyWith({
    int? currentStep,
    String? listingId,
    ListingResponse? listingData,
    bool? isLoading,
    String? errorMessage,
    String? propertyTypeLabel,
    int? beds,
    String? furnishedStatus,
    List<String>? amenities,
    List<String>? photoPaths,
    bool? newListingPromo,
    int? newListingPromoPercent,
    bool? lastMinuteDiscount,
    int? lastMinuteDiscountPercent,
    bool? customDiscount,
    int? customDiscountPercent,
  }) {
    return ListingDraftState(
      currentStep: currentStep ?? this.currentStep,
      listingId: listingId ?? this.listingId,
      listingData: listingData ?? this.listingData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      propertyTypeLabel: propertyTypeLabel ?? this.propertyTypeLabel,
      beds: beds ?? this.beds,
      furnishedStatus: furnishedStatus ?? this.furnishedStatus,
      amenities: amenities ?? this.amenities,
      photoPaths: photoPaths ?? this.photoPaths,
      newListingPromo: newListingPromo ?? this.newListingPromo,
      newListingPromoPercent: newListingPromoPercent ?? this.newListingPromoPercent,
      lastMinuteDiscount: lastMinuteDiscount ?? this.lastMinuteDiscount,
      lastMinuteDiscountPercent: lastMinuteDiscountPercent ?? this.lastMinuteDiscountPercent,
      customDiscount: customDiscount ?? this.customDiscount,
      customDiscountPercent: customDiscountPercent ?? this.customDiscountPercent,
    );
  }
}

@riverpod
class ListingDraft extends _$ListingDraft {
  @override
  ListingDraftState build() {
    final storage = ref.watch(localStorageServiceProvider);

    final savedStep = storage.getDraftCurrentStep() ?? 1;
    final savedListingId = storage.getDraftListingId();

    return ListingDraftState(
      currentStep: savedStep,
      listingId: savedListingId,
      // Restore UI-only fields from local storage
      propertyTypeLabel: storage.getPropertyTypeLabel(),
      beds: storage.getBeds(),
      furnishedStatus: storage.getFurnishedStatus(),
      amenities: storage.getAmenities(),
      photoPaths: storage.getPhotoPaths(),
      newListingPromo: storage.getNewListingPromo(),
      newListingPromoPercent: storage.getNewListingPromoPercent(),
      lastMinuteDiscount: storage.getLastMinuteDiscount(),
      lastMinuteDiscountPercent: storage.getLastMinuteDiscountPercent(),
      customDiscount: storage.getCustomDiscount(),
      customDiscountPercent: storage.getCustomDiscountPercent(),
    );
  }

  // ---------------------------------------------------------------------------
  // UI-only field setters — update state + persist immediately
  // ---------------------------------------------------------------------------

  Future<void> setPropertyTypeLabel(String label) async {
    state = state.copyWith(propertyTypeLabel: label);
    await ref.read(localStorageServiceProvider).savePropertyTypeLabel(label);
  }

  Future<void> setBeds(int value) async {
    state = state.copyWith(beds: value);
    await ref.read(localStorageServiceProvider).saveBeds(value);
  }

  Future<void> setFurnishedStatus(String? value) async {
    state = state.copyWith(furnishedStatus: value);
    await ref.read(localStorageServiceProvider).saveFurnishedStatus(value);
  }

  Future<void> setAmenities(List<String> value) async {
    state = state.copyWith(amenities: value);
    await ref.read(localStorageServiceProvider).saveAmenities(value);
  }

  Future<void> setPhotoPaths(List<String> value) async {
    state = state.copyWith(photoPaths: value);
    await ref.read(localStorageServiceProvider).savePhotoPaths(value);
  }

  Future<void> setDiscounts({
    bool? newListingPromo,
    int? newListingPromoPercent,
    bool? lastMinuteDiscount,
    int? lastMinuteDiscountPercent,
    bool? customDiscount,
    int? customDiscountPercent,
  }) async {
    state = state.copyWith(
      newListingPromo: newListingPromo,
      newListingPromoPercent: newListingPromoPercent,
      lastMinuteDiscount: lastMinuteDiscount,
      lastMinuteDiscountPercent: lastMinuteDiscountPercent,
      customDiscount: customDiscount,
      customDiscountPercent: customDiscountPercent,
    );
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveDiscounts(
      newListingPromo: state.newListingPromo,
      newListingPromoPercent: state.newListingPromoPercent,
      lastMinuteDiscount: state.lastMinuteDiscount,
      lastMinuteDiscountPercent: state.lastMinuteDiscountPercent,
      customDiscount: state.customDiscount,
      customDiscountPercent: state.customDiscountPercent,
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation helpers
  // ---------------------------------------------------------------------------

  /// Loads a published listing into the draft state for editing.
  /// Does NOT touch SharedPreferences — edits to published listings
  /// are not resumable drafts.
  void loadForEdit(ListingResponse listing) {
    state = ListingDraftState(
      currentStep: 12,
      listingId: listing.id,
      listingData: listing,
      // Restore UI-only fields from local storage in case they were set
      propertyTypeLabel: ref.read(localStorageServiceProvider).getPropertyTypeLabel(),
      beds: ref.read(localStorageServiceProvider).getBeds(),
      furnishedStatus: ref.read(localStorageServiceProvider).getFurnishedStatus(),
      amenities: ref.read(localStorageServiceProvider).getAmenities(),
      photoPaths: ref.read(localStorageServiceProvider).getPhotoPaths(),
      newListingPromo: ref.read(localStorageServiceProvider).getNewListingPromo(),
      newListingPromoPercent: ref.read(localStorageServiceProvider).getNewListingPromoPercent(),
      lastMinuteDiscount: ref.read(localStorageServiceProvider).getLastMinuteDiscount(),
      lastMinuteDiscountPercent: ref.read(localStorageServiceProvider).getLastMinuteDiscountPercent(),
      customDiscount: ref.read(localStorageServiceProvider).getCustomDiscount(),
      customDiscountPercent: ref.read(localStorageServiceProvider).getCustomDiscountPercent(),
    );
  }

  /// Fetches listing data from the API if we have a listingId but no listingData.
  /// Call this from screen initState to ensure data is available after force-close resume.
  Future<void> ensureListingDataLoaded() async {
    final id = state.listingId;
    if (id == null || state.listingData != null) return;

    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final listings = await repo.getListings();
      final match = listings.where((l) => l.id == id).firstOrNull;
      state = state.copyWith(isLoading: false, listingData: match);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Clears all draft state (used by the + button to start fresh).
  Future<void> startFresh() async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.clearDraft();
    state = ListingDraftState(currentStep: 1);
  }

  /// Resumes a draft: saves id/step locally and fetches listing data from API.
  Future<void> resumeDraft(String listingId, int step) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveDraft(listingId, step);

    // Restore UI-only fields from local storage
    state = ListingDraftState(
      currentStep: step,
      listingId: listingId,
      isLoading: true,
      propertyTypeLabel: storage.getPropertyTypeLabel(),
      beds: storage.getBeds(),
      furnishedStatus: storage.getFurnishedStatus(),
      amenities: storage.getAmenities(),
      photoPaths: storage.getPhotoPaths(),
      newListingPromo: storage.getNewListingPromo(),
      newListingPromoPercent: storage.getNewListingPromoPercent(),
      lastMinuteDiscount: storage.getLastMinuteDiscount(),
      lastMinuteDiscountPercent: storage.getLastMinuteDiscountPercent(),
      customDiscount: storage.getCustomDiscount(),
      customDiscountPercent: storage.getCustomDiscountPercent(),
    );

    // Fetch latest listing data from API so screens can pre-populate
    try {
      final repo = ref.read(listingRepositoryProvider);
      final listings = await repo.getListings();
      final match = listings.where((l) => l.id == listingId).firstOrNull;
      state = state.copyWith(isLoading: false, listingData: match);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  // ---------------------------------------------------------------------------
  // API calls
  // ---------------------------------------------------------------------------

  Future<void> createDraft(String propertyTypeId, String spaceType) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final response = await repo.createListingDraft(
        ListingCreate(propertyTypeId: propertyTypeId, spaceType: spaceType),
      );

      final storage = ref.read(localStorageServiceProvider);
      await storage.saveDraft(response.id, 2);

      ref.invalidate(listingsProvider);

      state = state.copyWith(
        isLoading: false,
        listingId: response.id,
        listingData: response,
        currentStep: 2,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> updateDraft(ListingUpdate updateData, int nextStep) async {
    if (state.listingId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final response = await repo.updateListing(state.listingId!, updateData);

      final storage = ref.read(localStorageServiceProvider);
      await storage.saveDraft(state.listingId!, nextStep);

      ref.invalidate(listingsProvider);

      state = state.copyWith(
        isLoading: false,
        listingData: response,
        currentStep: nextStep,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> publishListing() async {
    if (state.listingId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final response = await repo.publishListing(state.listingId!);

      final storage = ref.read(localStorageServiceProvider);
      await storage.clearDraft();

      ref.invalidate(listingsProvider);

      state = state.copyWith(
        isLoading: false,
        listingData: response,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }
}
