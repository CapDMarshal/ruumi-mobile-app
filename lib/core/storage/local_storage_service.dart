
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_service.g.dart';

// Provider to hold the SharedPreferences instance.
// Must be overridden in main() before the app starts.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
}

@riverpod
LocalStorageService localStorageService(Ref ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
}

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static const String _keyListingId = 'draft_listing_id';
  static const String _keyCurrentStep = 'draft_current_step';

  Future<void> saveDraft(String listingId, int step) async {
    await _prefs.setString(_keyListingId, listingId);
    await _prefs.setInt(_keyCurrentStep, step);
  }

  Future<void> clearDraft() async {
    await _prefs.remove(_keyListingId);
    await _prefs.remove(_keyCurrentStep);
  }

  String? getDraftListingId() {
    return _prefs.getString(_keyListingId);
  }

  int? getDraftCurrentStep() {
    return _prefs.getInt(_keyCurrentStep);
  }
}
