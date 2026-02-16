import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  const GradientCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Add your onTap logic here
      child: Stack(
        children: [
          // ::after in CSS (Blurred background gradient)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFC00FF), Color(0xFF00DBDE)],
                  transform: GradientRotation(-0.785), // -45 degrees in radians
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Main card content
          Container(
            width: 190,
            height: 254,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Heading',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Description text goes here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Action',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ::before in CSS (Rotating gradient border)
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE81CFF), Color(0xFF40C9FF)],
                  transform: GradientRotation(-0.785),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}