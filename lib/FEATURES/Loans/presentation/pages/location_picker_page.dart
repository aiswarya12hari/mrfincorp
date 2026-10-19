import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../data/models/selected_location_model.dart';

/// Place suggestion model for search autocomplete
class _MapSuggestion {
  final String title;
  final String subtitle;
  final double latitude;
  final double longitude;

  const _MapSuggestion({
    required this.title,
    required this.subtitle,
    required this.latitude,
    required this.longitude,
  });
}

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  // Brand color constants matching Friends Fincorp design system
  static const Color _tealPrimary = AppColors.secondary; // #18B7B0
  static const Color _tealDark = AppColors.secondaryDark; // #129C97
  static const Color _tealLightBg = AppColors.primaryLight; // #E0F7F6
  static const Color _charcoalText = AppColors.textPrimary; // #111827
  static const Color _mutedText = AppColors.subtitle; // #6B7280
  static const Color _placeholderText = AppColors.textMuted; // #9CA3AF
  static const Color _borderColor = AppColors.border; // #E5E7EB
  static const Color _cardBg = AppColors.background; // #F8FAFC

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Default coordinate: Thrissur, Kerala (10.5276, 76.2144)
  LatLng _selectedLocation = const LatLng(10.5276, 76.2144);

  Timer? _debounceTimer;
  bool _isSearching = false;
  bool _isAddressLoading = false;
  bool _isCurrentLocationLoading = false;

  List<_MapSuggestion> _suggestions = [];

  String _address = '';
  String _state = '';
  String _district = '';

  @override
  void initState() {
    super.initState();
    _fetchAddress(_selectedLocation.latitude, _selectedLocation.longitude);
    _checkAndFetchCurrentLocationSilently();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ── Search & Autocomplete ──────────────────────────────────────────────────

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    setState(() {});

    if (trimmed.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 320), () {
      _fetchSuggestions(trimmed);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (!mounted) return;
    setState(() {
      _isSearching = true;
    });

    // 1. Primary: Photon geocoding API (free, OSM-backed, built for autocomplete)
    try {
      final photonUri = Uri.parse(
        'https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=5',
      );
      final response =
          await http.get(photonUri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data['features'] as List<dynamic>?;

        if (features != null && features.isNotEmpty) {
          final List<_MapSuggestion> results = [];

          for (final item in features) {
            final props = item['properties'] as Map<String, dynamic>? ?? {};
            final geometry = item['geometry'] as Map<String, dynamic>? ?? {};
            final coords = geometry['coordinates'] as List<dynamic>?;

            if (coords != null && coords.length >= 2) {
              final lng = (coords[0] as num).toDouble();
              final lat = (coords[1] as num).toDouble();

              final name = props['name']?.toString() ??
                  props['street']?.toString() ??
                  '';

              final parts = <String>[
                if (props['street'] != null && props['street'] != name)
                  props['street'].toString(),
                if (props['city'] != null) props['city'].toString(),
                if (props['district'] != null &&
                    props['district'] != props['city'])
                  props['district'].toString(),
                if (props['state'] != null) props['state'].toString(),
                if (props['country'] != null) props['country'].toString(),
              ];
              final subtitle = parts.join(', ');

              if (name.isNotEmpty || subtitle.isNotEmpty) {
                results.add(
                  _MapSuggestion(
                    title: name.isNotEmpty ? name : subtitle,
                    subtitle: subtitle.isNotEmpty ? subtitle : name,
                    latitude: lat,
                    longitude: lng,
                  ),
                );
              }
            }
          }

          if (results.isNotEmpty && mounted) {
            setState(() {
              _suggestions = results;
              _isSearching = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Photon suggestions error: $e');
    }

    // 2. Secondary: Nominatim OpenStreetMap fallback
    try {
      final nominatimUri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5',
      );
      final response = await http.get(
        nominatimUri,
        headers: {'User-Agent': 'MRFinCorp-FieldApp'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        if (data.isNotEmpty) {
          final List<_MapSuggestion> results = [];

          for (final item in data) {
            final lat = double.tryParse(item['lat']?.toString() ?? '') ?? 0.0;
            final lng = double.tryParse(item['lon']?.toString() ?? '') ?? 0.0;
            final displayName = item['display_name']?.toString() ?? '';
            final name =
                item['name']?.toString() ?? displayName.split(',').first.trim();

            if (lat != 0.0 && lng != 0.0) {
              results.add(
                _MapSuggestion(
                  title: name,
                  subtitle: displayName,
                  latitude: lat,
                  longitude: lng,
                ),
              );
            }
          }

          if (results.isNotEmpty && mounted) {
            setState(() {
              _suggestions = results;
              _isSearching = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Nominatim suggestions error: $e');
    }

    // 3. Fallback: Native device Geocoder
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty && mounted) {
        final loc = locations.first;
        setState(() {
          _suggestions = [
            _MapSuggestion(
              title: query,
              subtitle:
                  'Lat: ${loc.latitude.toStringAsFixed(4)}, Lng: ${loc.longitude.toStringAsFixed(4)}',
              latitude: loc.latitude,
              longitude: loc.longitude,
            ),
          ];
          _isSearching = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('Native geocoding suggestions error: $e');
    }

    if (mounted) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
    }
  }

  Future<void> _selectSuggestion(_MapSuggestion suggestion) async {
    _searchController.text = suggestion.title;
    _searchFocusNode.unfocus();

    final target = LatLng(suggestion.latitude, suggestion.longitude);

    setState(() {
      _suggestions = [];
      _selectedLocation = target;
    });

    _animateCameraTo(target);
    await _fetchAddress(suggestion.latitude, suggestion.longitude);
  }

  Future<void> _executeSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    _searchFocusNode.unfocus();

    if (_suggestions.isNotEmpty) {
      await _selectSuggestion(_suggestions.first);
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);

        if (mounted) {
          setState(() {
            _selectedLocation = target;
            _suggestions = [];
          });
          _animateCameraTo(target);
          await _fetchAddress(loc.latitude, loc.longitude);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No matching location found. Please try another term.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Search error => $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not find location. Please tap directly on the map.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _suggestions = [];
      _isSearching = false;
    });
  }

  // ── Camera & Map Interactions ──────────────────────────────────────────────

  void _animateCameraTo(LatLng target, {double zoom = 15.5}) {
    _mapController.move(target, zoom);
  }

  Future<void> _checkAndFetchCurrentLocationSilently() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 6),
          ),
        );
        if (!mounted) return;
        final currentPoint = LatLng(position.latitude, position.longitude);
        setState(() {
          _selectedLocation = currentPoint;
        });
        _animateCameraTo(currentPoint, zoom: 16.0);
        await _fetchAddress(position.latitude, position.longitude);
      }
    } catch (e) {
      debugPrint('Silent location detection error => $e');
    }
  }

  Future<void> _onMapTap(LatLng point) async {
    _searchFocusNode.unfocus();
    setState(() {
      _suggestions = [];
      _selectedLocation = point;
    });

    await _fetchAddress(point.latitude, point.longitude);
  }

  // ── Location & Address Retrieval ───────────────────────────────────────────

  Future<void> _fetchAddress(double latitude, double longitude) async {
    if (!mounted) return;
    setState(() {
      _isAddressLoading = true;
    });

    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;

        final street = place.street ?? '';
        final subLocality = place.subLocality ?? '';
        final locality = place.locality ?? '';
        final adminArea = place.administrativeArea ?? '';

        final parts = <String>[
          if (street.isNotEmpty) street,
          if (subLocality.isNotEmpty && subLocality != street) subLocality,
          if (locality.isNotEmpty && locality != street) locality,
          if (adminArea.isNotEmpty) adminArea,
        ];

        final fullAddress = parts.isNotEmpty
            ? parts.join(', ')
            : '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

        setState(() {
          _address = fullAddress;
          _state = place.administrativeArea ?? '';
          _district = place.subAdministrativeArea ?? place.locality ?? '';
        });
      } else if (mounted) {
        setState(() {
          _address =
              '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
        });
      }
    } catch (e) {
      debugPrint('Address geocoding error => $e');
      if (mounted) {
        setState(() {
          _address =
              '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddressLoading = false;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isCurrentLocationLoading) return;

    setState(() {
      _isCurrentLocationLoading = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location services are disabled. Please enable GPS in device settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission was denied.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied. Please enable them in app settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      final currentPoint = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _selectedLocation = currentPoint;
          _suggestions = [];
        });

        _animateCameraTo(currentPoint, zoom: 16.5);
        await _fetchAddress(position.latitude, position.longitude);
      }
    } catch (e) {
      debugPrint('Get current location error => $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to detect current location. Tap on the map to select.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCurrentLocationLoading = false;
        });
      }
    }
  }

  // ── Confirmation & Navigation Return ───────────────────────────────────────

  void _confirmLocation() {
    final mapLink =
        'https://maps.google.com/?q=${_selectedLocation.latitude},${_selectedLocation.longitude}';

    final finalAddress = _address.isNotEmpty
        ? _address
        : 'Location (${_selectedLocation.latitude.toStringAsFixed(5)}, ${_selectedLocation.longitude.toStringAsFixed(5)})';

    Navigator.pop(
      context,
      SelectedLocationModel(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        address: finalAddress,
        state: _state,
        district: _district,
        googleMapLink: mapLink,
      ),
    );
  }

  // ── UI Builders ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _searchFocusNode.hasFocus ? _tealPrimary : _borderColor,
          width: _searchFocusNode.hasFocus ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _executeSearch,
            icon: const Icon(
              Icons.search_rounded,
              color: _tealPrimary,
              size: 22,
            ),
            splashRadius: 20,
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              onSubmitted: (_) => _executeSearch(),
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _charcoalText,
              ),
              decoration: const InputDecoration(
                hintText: 'Search location',
                hintStyle: TextStyle(
                  color: _placeholderText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _tealPrimary,
                ),
              ),
            )
          else if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              icon: const Icon(
                Icons.close_rounded,
                color: _placeholderText,
                size: 20,
              ),
              splashRadius: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsDropdown() {
    if (_suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 230),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 6),
          shrinkWrap: true,
          itemCount: _suggestions.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
          itemBuilder: (context, index) {
            final item = _suggestions[index];
            return InkWell(
              onTap: () => _selectSuggestion(item),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _tealLightBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: _tealPrimary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _charcoalText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.north_west_rounded,
                      size: 16,
                      color: _placeholderText,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCircularMapButton(
          icon: Icons.add_rounded,
          onTap: () {
            final currentZoom = _mapController.camera.zoom;
            final nextZoom = (currentZoom + 1).clamp(3.0, 18.5);
            _mapController.move(_selectedLocation, nextZoom);
          },
        ),
        const SizedBox(height: 8),
        _buildCircularMapButton(
          icon: Icons.remove_rounded,
          onTap: () {
            final currentZoom = _mapController.camera.zoom;
            final nextZoom = (currentZoom - 1).clamp(3.0, 18.5);
            _mapController.move(_selectedLocation, nextZoom);
          },
        ),
        const SizedBox(height: 12),
        _buildCurrentLocationFloatingButton(),
      ],
    );
  }

  Widget _buildCircularMapButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        splashColor: _tealLightBg,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: _charcoalText,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationFloatingButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _getCurrentLocation,
        borderRadius: BorderRadius.circular(28),
        splashColor: _tealLightBg,
        child: Ink(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: _isCurrentLocationLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: _tealPrimary,
                    ),
                  )
                : const Icon(
                    Icons.my_location_rounded,
                    color: _tealPrimary,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle pill
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Location Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _tealLightBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: _tealPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _isAddressLoading
                        ? const Row(
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _tealPrimary,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Locating address...',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _mutedText,
                                ),
                              ),
                            ],
                          )
                        : _address.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'SELECTED LOCATION',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _tealDark,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _charcoalText,
                                      height: 1.25,
                                    ),
                                  ),
                                  if (_district.isNotEmpty || _state.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      [_district, _state]
                                          .where((s) => s.isNotEmpty)
                                          .join(', '),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: _mutedText,
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Location Selected',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _mutedText,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Tap on the map or search to choose a location',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _placeholderText,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Confirm Location Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _confirmLocation,
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return _tealDark;
                    }
                    return _tealPrimary;
                  }),
                  foregroundColor:
                      WidgetStateProperty.all<Color>(Colors.white),
                  elevation: WidgetStateProperty.all<double>(0),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Confirm Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _charcoalText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Choose Location',
          style: TextStyle(
            color: _charcoalText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: _borderColor,
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Flutter Map (OpenStreetMap)
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedLocation,
                initialZoom: 15.0,
                minZoom: 3.0,
                maxZoom: 18.5,
                onTap: (tapPosition, point) => _onMapTap(point),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.techfifo.mr_fincorp',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      width: 50,
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: _tealDark,
                        size: 46,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Search Field + Autocomplete Dropdown (Floating at top)
          Positioned(
            top: 14,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchBar(),
                _buildSuggestionsDropdown(),
              ],
            ),
          ),

          // 3. Floating Map Controls (Zoom in/out + My Location)
          Positioned(
            right: 16,
            bottom: 216,
            child: _buildMapControls(),
          ),

          // 4. Bottom Panel with Address & Confirm Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }
}
