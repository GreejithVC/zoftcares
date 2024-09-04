import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSquare extends StatelessWidget {
  const ShimmerSquare({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      enabled: true,
      highlightColor: Colors.white,
      loop: 3,
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(
          height: size * 1,
          width: size * 1,
        ),
      ),
    );
  }
}
