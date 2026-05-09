import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/local_storage_service.dart';
import '../../data/listing_repository.dart';
import '../../data/models/listing_models.dart';

part 'listing_draft_provider.g.dart';

class ListingDraftState {
  final int currentStep;
  final String? listingId;
  final ListingResponse? listingData; // Optional: keep full data if needed
  final bool isLoading;

  ListingDraftState({
    required this.currentStep,
    this.listingId,
    this.listingData,
    this.isLoading = false,
  });

  ListingDraftState copyWith({
    int? currentStep,
    String? listingId,
    ListingResponse? listingData,
    bool? isLoading,
  }) {
    return ListingDraftState(
      currentStep: currentStep ?? this.currentStep,
      listingId: listingId ?? this.listingId,
      listingData: listingData ?? this.listingData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class ListingDraft extends _$ListingDraft {
  @override
  ListingDraftState build() {
    final storage = ref.watch(localStorageServiceProvider);
    
    // Initialize state from local storage (Draft resumption)
    final savedStep = storage.getDraftCurrentStep() ?? 1;
    final savedListingId = storage.getDraftListingId();
    
    return ListingDraftState(
      currentStep: savedStep,
      listingId: savedListingId,
    );
  }

  Future<void> createDraft(String propertyTypeId, String spaceType) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final response = await repo.createListingDraft(
        ListingCreate(propertyTypeId: propertyTypeId, spaceType: spaceType),
      );
      
      final storage = ref.read(localStorageServiceProvider);
      await storage.saveDraft(response.id, 2);
      
      state = state.copyWith(
        isLoading: false,
        listingId: response.id,
        listingData: response,
        currentStep: 2,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> updateDraft(ListingUpdate updateData, int nextStep) async {
    if (state.listingId == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final response = await repo.updateListing(state.listingId!, updateData);
      
      final storage = ref.read(localStorageServiceProvider);
      await storage.saveDraft(state.listingId!, nextStep);
      
      state = state.copyWith(
        isLoading: false,
        listingData: response,
        currentStep: nextStep,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> publishListing() async {
    if (state.listingId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(listingRepositoryProvider);
      final response = await repo.publishListing(state.listingId!);
      
      // On success, clear draft
      final storage = ref.read(localStorageServiceProvider);
      await storage.clearDraft();
      
      state = state.copyWith(
        isLoading: false,
        listingData: response,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
