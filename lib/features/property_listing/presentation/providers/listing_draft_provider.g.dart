// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_draft_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listingsHash() => r'29de79f357fbd58e506df2b0c7ea5b81a912263f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [listings].
@ProviderFor(listings)
const listingsProvider = ListingsFamily();

/// See also [listings].
class ListingsFamily extends Family<AsyncValue<List<ListingResponse>>> {
  /// See also [listings].
  const ListingsFamily();

  /// See also [listings].
  ListingsProvider call({int limit = 10, int offset = 0}) {
    return ListingsProvider(limit: limit, offset: offset);
  }

  @override
  ListingsProvider getProviderOverride(covariant ListingsProvider provider) {
    return call(limit: provider.limit, offset: provider.offset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'listingsProvider';
}

/// See also [listings].
class ListingsProvider
    extends AutoDisposeFutureProvider<List<ListingResponse>> {
  /// See also [listings].
  ListingsProvider({int limit = 10, int offset = 0})
    : this._internal(
        (ref) => listings(ref as ListingsRef, limit: limit, offset: offset),
        from: listingsProvider,
        name: r'listingsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$listingsHash,
        dependencies: ListingsFamily._dependencies,
        allTransitiveDependencies: ListingsFamily._allTransitiveDependencies,
        limit: limit,
        offset: offset,
      );

  ListingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final int limit;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<ListingResponse>> Function(ListingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ListingsProvider._internal(
        (ref) => create(ref as ListingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ListingResponse>> createElement() {
    return _ListingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListingsProvider &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ListingsRef on AutoDisposeFutureProviderRef<List<ListingResponse>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _ListingsProviderElement
    extends AutoDisposeFutureProviderElement<List<ListingResponse>>
    with ListingsRef {
  _ListingsProviderElement(super.provider);

  @override
  int get limit => (origin as ListingsProvider).limit;
  @override
  int get offset => (origin as ListingsProvider).offset;
}

String _$listingDraftHash() => r'92e2ce52c994957ebd42e66ac48ca965ecb4cd2b';

/// See also [ListingDraft].
@ProviderFor(ListingDraft)
final listingDraftProvider =
    AutoDisposeNotifierProvider<ListingDraft, ListingDraftState>.internal(
      ListingDraft.new,
      name: r'listingDraftProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$listingDraftHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ListingDraft = AutoDisposeNotifier<ListingDraftState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
