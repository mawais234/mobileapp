import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class SearchMapScreen extends StatefulWidget {
  const SearchMapScreen({Key? key}) : super(key: key);

  @override
  State<SearchMapScreen> createState() => _SearchMapScreenState();
}

class _SearchMapScreenState extends State<SearchMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  String? _locationName;
  bool _isLoading = false;
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _executeSearch(String query) async {
    if (query.isEmpty) {
      _updateErrorState('Please enter a location to search');
      return;
    }

    _updateLoadingState(true);
    _updateErrorState(null);

    try {
      final coords = await _getLocationCoordinates(query);
      if (coords == null) {
        _updateErrorState('Location not found');
        return;
      }

      _updateMapLocation(coords, query);
    } catch (e) {
      _updateErrorState(
        'Search failed: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      _updateLoadingState(false);
    }
  }

  Future<LatLng?> _getLocationCoordinates(String query) async {
    // Try primary geocoding first
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (_) {}

    // Fallback to Nominatim API
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          final firstResult = data.first;
          return LatLng(
            double.parse(firstResult['lat']),
            double.parse(firstResult['lon']),
          );
        }
      }
    } catch (_) {}

    return null;
  }

  void _updateMapLocation(LatLng coords, String query) {
    setState(() {
      _currentLocation = coords;
      _locationName = query;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_currentLocation!, 15.0);
    });
  }

  void _updateLoadingState(bool isLoading) {
    setState(() => _isLoading = isLoading);
  }

  void _updateErrorState(String? error) {
    setState(() => _searchError = error);
  }

  Future<void> _launchAttributionUrl() async {
    final url = Uri.parse('https://openstreetmap.org/copyright');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open browser')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Search'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search city or place...',
                      border: const OutlineInputBorder(),
                      suffixIcon:
                          _isLoading
                              ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : null,
                    ),
                    onSubmitted: _executeSearch,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed:
                      _isLoading
                          ? null
                          : () => _executeSearch(_searchController.text),
                ),
              ],
            ),
          ),
          if (_searchError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _searchError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
              ),
            ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation ?? const LatLng(31.4504, 73.7060),
                zoom: _currentLocation != null ? 15.0 : 5.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        width: 60,
                        height: 60,
                        builder:
                            (ctx) => Column(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                if (_locationName != null)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _locationName!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                      ),
                    ],
                  ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: _launchAttributionUrl,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
