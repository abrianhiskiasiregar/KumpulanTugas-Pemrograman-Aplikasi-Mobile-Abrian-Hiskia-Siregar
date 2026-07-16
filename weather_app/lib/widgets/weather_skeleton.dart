// lib/widgets/weather_skeleton.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherSkeleton extends StatelessWidget {
  const WeatherSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 150, height: 32, color: Colors.white),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 40, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 150, height: 24, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDetailSkeleton(), _buildDetailSkeleton()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSkeleton() {
    return Column(
      children: [
        Container(width: 40, height: 40, color: Colors.white),
        const SizedBox(height: 8),
        Container(width: 60, height: 20, color: Colors.white),
      ],
    );
  }
}
