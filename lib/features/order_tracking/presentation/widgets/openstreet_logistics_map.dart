import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Uses OpenStreetMap (FREE, no API key needed) instead of Google Maps
/// Shows the shipping route: Shenzhen China → Umm Qasr Port Iraq
class OpenStreetLogisticsMap extends StatelessWidget {
  const OpenStreetLogisticsMap({super.key});

  @override
  Widget build(BuildContext context) {
    // China (Shenzhen) → Iraq (Basra/Umm Qasr)
    const origin = LatLng(22.5431, 114.0579);      // Shenzhen
    const destination = LatLng(30.0444, 47.9637);  // Umm Qasr Port, Iraq

    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(26.0, 80.0), // Centered between China and Iraq
            initialZoom: 3.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.ahmedbaba.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [origin, destination],
                  color: const Color(0xFFFF6600),
                  strokeWidth: 3,
                  isDotted: true,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: origin,
                  child: const Icon(Icons.factory_rounded, color: Colors.blue, size: 28),
                ),
                Marker(
                  point: destination,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
