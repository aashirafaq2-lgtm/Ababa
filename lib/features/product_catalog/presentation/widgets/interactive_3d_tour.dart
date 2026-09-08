import 'package:flutter/material.dart';

class Interactive3DTour extends StatefulWidget {
  const Interactive3DTour({super.key});

  @override
  State<Interactive3DTour> createState() => _Interactive3DTourState();
}

class _Interactive3DTourState extends State<Interactive3DTour> {
  double _rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulate 3D rotation with Transform and Opacity layers
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _rotation += details.delta.dx / 100;
              });
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_rotation),
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 40)],
                ),
                child: const Icon(Icons.precision_manufacturing_outlined, size: 100, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Icon(Icons.threed_rotation_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Swipe to Rotate 360°', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
