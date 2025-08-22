import 'package:flutter/material.dart';

CircularProgressIndicator customCircularProgressIndicator({
  required BuildContext context,
  double strokeWidth = 15.0,
  Color? valueColor,
}) {
  return CircularProgressIndicator(
    strokeWidth: strokeWidth,
    valueColor: AlwaysStoppedAnimation<Color>(
      valueColor ??
          Theme.of(
            context,
          ).colorScheme.primaryFixedDim, // Default color is pink
    ),
  );
}

// Custom CircularProgressIndicator Guide

              // CircularProgressIndicator(
              //   strokeWidth: 5.0, // Độ dày của vòng tròn
              //   valueColor: AlwaysStoppedAnimation<Color>(
              //     Theme.of(
              //       context,
              //     ).colorScheme.primary, // Default color is primary color
              //   ),
              //   backgroundColor: Colors.transparent,
              // ),