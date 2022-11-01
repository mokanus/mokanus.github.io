import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<List<Color>> getColors({
  required ImageProvider imageProvider,
}) async {
  PaletteGenerator paletteGenerator;
  paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
  final Color dominantColor =
      paletteGenerator.dominantColor?.color ?? Colors.black;
  final Color darkMutedColor =
      paletteGenerator.darkMutedColor?.color ?? Colors.black;

  return [
    dominantColor,
    darkMutedColor,
  ];
}
