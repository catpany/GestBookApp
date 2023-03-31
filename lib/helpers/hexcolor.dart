import 'dart:ui';

extension HexColor on Color {
  String toHexString() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}