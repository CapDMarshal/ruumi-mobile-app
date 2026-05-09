
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_service.g.dart';

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

  // Keys
  static const _kListingId          = 'draft_listing_id';
  static const _kCurrentStep        = 'draft_current_step';
  static const _kPropertyTypeLabel  = 'draft_property_type_label';
  static const _kBeds               = 'draft_beds';
  static const _kFurnished          = 'draft_furnished_status';
  static const _kAmenities          = 'draft_amenities';
  static const _kPhotoPaths         = 'draft_photo_paths';
  static const _kNewListingPromo    = 'draft_new_listing_promo';
  static const _kNewListingPct      = 'draft_new_listing_pct';
  static const _kLastMinute         = 'draft_last_minute';
  static const _kLastMinutePct      = 'draft_last_minute_pct';
  static const _kCustomDiscount     = 'draft_custom_discount';
  static const _kCustomDiscountPct  = 'draft_custom_discount_pct';

  // ── Core draft ────────────────────────────────────────────────────────────

  Future<void> saveDraft(String listingId, int step) async {
    await _prefs.setString(_kListingId, listingId);
    await _prefs.setInt(_kCurrentStep, step);
  }

  Future<void> clearDraft() async {
    for (final key in [
      _kListingId, _kCurrentStep, _kPropertyTypeLabel, _kBeds, _kFurnished,
      _kAmenities, _kPhotoPaths, _kNewListingPromo, _kNewListingPct,
      _kLastMinute, _kLastMinutePct, _kCustomDiscount, _kCustomDiscountPct,
    ]) {
      await _prefs.remove(key);
    }
  }

  String? getDraftListingId()  => _prefs.getString(_kListingId);
  int?    getDraftCurrentStep() => _prefs.getInt(_kCurrentStep);

  // ── Property type label ───────────────────────────────────────────────────

  Future<void> savePropertyTypeLabel(String label) =>
      _prefs.setString(_kPropertyTypeLabel, label);

  String? getPropertyTypeLabel() => _prefs.getString(_kPropertyTypeLabel);

  // ── Beds (UI-only, no API field) ──────────────────────────────────────────

  Future<void> saveBeds(int value) => _prefs.setInt(_kBeds, value);
  int getBeds() => _prefs.getInt(_kBeds) ?? 0;

  // ── Furnished ─────────────────────────────────────────────────────────────

  Future<void> saveFurnishedStatus(String? value) async {
    if (value == null) {
      await _prefs.remove(_kFurnished);
    } else {
      await _prefs.setString(_kFurnished, value);
    }
  }

  String? getFurnishedStatus() => _prefs.getString(_kFurnished);

  // ── Amenities ─────────────────────────────────────────────────────────────

  Future<void> saveAmenities(List<String> value) async =>
      _prefs.setStringList(_kAmenities, value);

  List<String> getAmenities() =>
      _prefs.getStringList(_kAmenities) ?? [];

  // ── Photos ────────────────────────────────────────────────────────────────

  Future<void> savePhotoPaths(List<String> value) async =>
      _prefs.setStringList(_kPhotoPaths, value);

  List<String> getPhotoPaths() =>
      _prefs.getStringList(_kPhotoPaths) ?? [];

  // ── Discounts ─────────────────────────────────────────────────────────────

  Future<void> saveDiscounts({
    required bool newListingPromo,
    required int newListingPromoPercent,
    required bool lastMinuteDiscount,
    required int lastMinuteDiscountPercent,
    required bool customDiscount,
    required int customDiscountPercent,
  }) async {
    await _prefs.setBool(_kNewListingPromo, newListingPromo);
    await _prefs.setInt(_kNewListingPct, newListingPromoPercent);
    await _prefs.setBool(_kLastMinute, lastMinuteDiscount);
    await _prefs.setInt(_kLastMinutePct, lastMinuteDiscountPercent);
    await _prefs.setBool(_kCustomDiscount, customDiscount);
    await _prefs.setInt(_kCustomDiscountPct, customDiscountPercent);
  }

  bool getNewListingPromo()         => _prefs.getBool(_kNewListingPromo)   ?? true;
  int  getNewListingPromoPercent()  => _prefs.getInt(_kNewListingPct)      ?? 20;
  bool getLastMinuteDiscount()      => _prefs.getBool(_kLastMinute)        ?? true;
  int  getLastMinuteDiscountPercent() => _prefs.getInt(_kLastMinutePct)    ?? 14;
  bool getCustomDiscount()          => _prefs.getBool(_kCustomDiscount)    ?? false;
  int  getCustomDiscountPercent()   => _prefs.getInt(_kCustomDiscountPct)  ?? 0;
}
