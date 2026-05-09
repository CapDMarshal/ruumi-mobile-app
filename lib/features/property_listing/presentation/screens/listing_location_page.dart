import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../widgets/step_progress_bar.dart';

class ListingLocationPage extends StatefulWidget {
  const ListingLocationPage({super.key});

  @override
  State<ListingLocationPage> createState() => _ListingLocationPageState();
}

class _ListingLocationPageState extends State<ListingLocationPage> {
  final MapController _mapController = MapController();
  final _streetController = TextEditingController(text: '652 7th Avenue');
  final _unitController = TextEditingController(text: 'Apt 172');
  final _cityController = TextEditingController(text: 'Kuala Lumpur');
  final _stateController = TextEditingController(text: 'Kuala Lumpur');
  final _zipController = TextEditingController(text: '10001');

  String _region = 'Malaysia';
  LatLng _selectedPoint = const LatLng(3.1390, 101.6869);
  String _displayAddress =
      'No. 8, Jalan Kerinchi, Bangsar South, 59200 Kuala Lumpur, Malaysia';
  bool _isFetchingAddress = false;

  @override
  void dispose() {
    _streetController.dispose();
    _unitController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create a listing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
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
                'Where\'s your place located?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _selectedPoint,
                          initialZoom: 13,
                          onTap: (tapPosition, point) {
                            _onMapTap(point);
                          },
                        ),
                        mapController: _mapController,
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.ruumi.propertylisting',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _selectedPoint,
                                width: 48,
                                height: 48,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF25C2A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.apartment,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: _ConfirmCard(
                        address: _displayAddress,
                        isLoading: _isFetchingAddress,
                        onConfirm: () {},
                        onEdit: () => _showAddressSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const StepProgressBar(currentStep: 2, totalSteps: 12),
              const SizedBox(height: 10),
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
                    context.go('/create-listing/step-3');
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onMapTap(LatLng point) async {
    setState(() {
      _selectedPoint = point;
      _isFetchingAddress = true;
    });
    _mapController.move(point, _mapController.camera.zoom);

    final address = await _reverseGeocode(point);
    if (!mounted) return;

    setState(() {
      _isFetchingAddress = false;
      if (address != null) {
        _displayAddress = address.display;
        _streetController.text = address.street;
        _cityController.text = address.city;
        _stateController.text = address.state;
        _zipController.text = address.postalCode;
        _region = address.region;
      }
    });
  }

  Future<_ResolvedAddress?> _reverseGeocode(LatLng point) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'jsonv2',
      'lat': point.latitude.toString(),
      'lon': point.longitude.toString(),
      'addressdetails': '1',
    });

    try {
      final response = await http.get(
        uri,
        headers: const {
          'User-Agent': 'ruumi-propertylisting/1.0',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final address = (data['address'] as Map<String, dynamic>?) ?? {};

      final houseNumber = address['house_number']?.toString();
      final road = address['road']?.toString();
      final suburb = address['suburb']?.toString();
      final city = address['city']?.toString() ??
          address['town']?.toString() ??
          address['village']?.toString() ??
          '';
        final state = address['state']?.toString() ??
          address['state_district']?.toString() ??
          address['county']?.toString() ??
          '';
      final postcode = address['postcode']?.toString() ?? '';
      final country = address['country']?.toString() ?? _region;

      final streetParts = [
        if (houseNumber != null && houseNumber.isNotEmpty) houseNumber,
        if (road != null && road.isNotEmpty) road,
        if (suburb != null && suburb.isNotEmpty) suburb,
      ];

      final street = streetParts.isEmpty ? '' : streetParts.join(' ');
      final display = data['display_name']?.toString() ?? street;

      return _ResolvedAddress(
        display: display,
        street: street,
        city: city,
        state: state,
        postalCode: postcode,
        region: _mapCountryToRegion(country),
      );
    } catch (_) {
      return null;
    }
  }

  String _mapCountryToRegion(String country) {
    if (country.toLowerCase().contains('singapore')) {
      return 'Singapore';
    }
    return 'Malaysia';
  }

  void _showAddressSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
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
                'Confirm your address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _region,
                decoration: _inputDecoration('Choose your region'),
                items: const [
                  DropdownMenuItem(value: 'Malaysia', child: Text('Malaysia')),
                  DropdownMenuItem(value: 'Singapore', child: Text('Singapore')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _region = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _streetController,
                decoration: _inputDecoration('Street address'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _unitController,
                decoration: _inputDecoration('Apt, suite, unit (if applicable)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cityController,
                decoration: _inputDecoration('City/town'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stateController,
                decoration: _inputDecoration('State/territory'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _zipController,
                decoration: _inputDecoration('ZIP code'),
              ),
              const SizedBox(height: 16),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF25C2A)),
      ),
    );
  }
}

class _ConfirmCard extends StatelessWidget {
  final String address;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback onEdit;

  const _ConfirmCard({
    required this.address,
    required this.isLoading,
    required this.onConfirm,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are these details correct?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: isLoading
                    ? const Text(
                        'Fetching address...',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6E6E6E)),
                      )
                    : Text(
                        address,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6E6E6E)),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF25C2A),
                    side: const BorderSide(color: Color(0xFFF25C2A)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onEdit,
                  child: const Text('No, edit manually'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF25C2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onConfirm,
                  child: const Text('Yes, use this address'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResolvedAddress {
  final String display;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String region;

  const _ResolvedAddress({
    required this.display,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.region,
  });
}
