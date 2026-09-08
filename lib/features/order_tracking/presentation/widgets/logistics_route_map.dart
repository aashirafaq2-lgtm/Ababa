import 'package:flutter/material.dart';

class LogisticsRouteMap extends StatelessWidget {
  const LogisticsRouteMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/800x400?text=Global+Trade+Route+Map+China+to+Iraq'),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      child: Stack(
        children: [
          _locationPin(top: 80, left: 140, label: 'Origin: Shenzhen'),
          _locationPin(bottom: 60, right: 100, label: 'Dest: Umm Qasr'),
          Center(
            child: Icon(Icons.directions_boat_rounded, color: Colors.blue[800], size: 28),
          ),
          Positioned(
            bottom: 12, left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
              child: const Text('Status: Floating on Arabian Sea', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _locationPin({double? top, double? left, double? right, double? bottom, required String label}) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
          const Icon(Icons.location_on, color: Colors.red, size: 16),
        ],
      ),
    );
  }
}
