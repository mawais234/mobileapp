import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UniversityMapScreen extends StatelessWidget {
  const UniversityMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Coordinates for Baba Guru Nanak University, Nankana Sahib
    const universityLocation = LatLng(31.4504, 73.7060);

    return Scaffold(
      appBar: AppBar(title: const Text('Baba Guru Nanak University Location')),
      body: FlutterMap(
        options: MapOptions(center: universityLocation, zoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: universityLocation,
                width: 80,
                height: 80,
                builder:
                    (context) => const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
              ),
            ],
          ),
          const RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors', onTap: null),
            ],
          ),
        ],
      ),
    );
  }
}
