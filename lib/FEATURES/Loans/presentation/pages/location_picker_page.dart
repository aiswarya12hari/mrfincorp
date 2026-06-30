import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../../data/models/selected_location_model.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final MapController _mapController = MapController();

  final TextEditingController searchController = TextEditingController();

  LatLng selectedLocation = const LatLng(10.5276, 76.2144);

  bool isLoading = false;

  String address = '';
  String state = '';
  String district = '';
  String pinCode = '';

  Future<void> searchLocation() async {
    if (searchController.text.trim().isEmpty) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(searchController.text)}&format=jsonv2&limit=1',
        ),
        headers: {'User-Agent': 'MRFinCorp'},
      );

      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);

        final lng = double.parse(data[0]['lon']);

        selectedLocation = LatLng(lat, lng);

        _mapController.move(selectedLocation, 16);

        await fetchAddress(lat, lng);
      }
    } catch (e) {
      debugPrint('SEARCH ERROR => $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition();

      selectedLocation = LatLng(position.latitude, position.longitude);

      _mapController.move(selectedLocation, 17);

      await fetchAddress(position.latitude, position.longitude);

      setState(() {});
    } catch (e) {
      debugPrint('LOCATION ERROR => $e');
    }
  }

  Future<void> fetchAddress(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';

        state = place.administrativeArea ?? '';

        district = place.subAdministrativeArea ?? '';

        pinCode = place.postalCode ?? '';

        setState(() {});
      }
    } catch (e) {
      debugPrint('ADDRESS ERROR => $e');
    }
  }

  Future<void> onMapTap(LatLng point) async {
    selectedLocation = point;

    await fetchAddress(point.latitude, point.longitude);

    setState(() {});
  }

  void confirmLocation() {
    final mapLink =
        'https://maps.google.com/?q=${selectedLocation.latitude},${selectedLocation.longitude}';

    Navigator.pop(
      context,
      SelectedLocationModel(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        address: address,
        state: state,
        district: district,
        pinCode: pinCode,
        googleMapLink: mapLink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Location')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: searchLocation,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Use Current Location'),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: FlutterMap(
              mapController: _mapController,

              options: MapOptions(
                initialCenter: selectedLocation,
                initialZoom: 14,

                onTap: (tapPosition, point) {
                  onMapTap(point);
                },
              ),

              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mr_fincorp.app',
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        size: 45,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.isEmpty ? 'No Location Selected' : address),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: confirmLocation,
                    child: const Text('Confirm Location'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
