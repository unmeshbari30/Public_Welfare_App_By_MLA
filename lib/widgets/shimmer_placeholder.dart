import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerPlaceholderFormField extends StatelessWidget {
  final Color? shimmerColor;
  final Color? backgroundColor;
  const ShimmerPlaceholderFormField(
      {super.key, this.backgroundColor, this.shimmerColor});

  @override
  Widget build(BuildContext context) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 2,
    margin: const EdgeInsets.all(0),
    color: backgroundColor,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
    child: Shimmer(
      color: shimmerColor ?? Colors.white,
      colorOpacity: 1.0,
      duration: const Duration(milliseconds: 1500),
      interval: const Duration(milliseconds: 100),
      child: Transform.scale(
        scale: 1.01,
        child: const SizedBox(
          height: 57,
          width: double.maxFinite,
        ),
      ),
    ),
  );
}

}
