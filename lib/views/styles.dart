import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';

class TextStyles {
  static const TextStyle? text12Regular = TextStyle(
    color: ColorStyles.grayDark,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? text14Regular = TextStyle(
    color: ColorStyles.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? text14Medium = TextStyle(
    color: ColorStyles.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? text16Medium = TextStyle(
    color: ColorStyles.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? text14SemiBold = TextStyle(
    color: ColorStyles.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? title18Medium = TextStyle(
    color: ColorStyles.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? title21Regular = TextStyle(
    color: ColorStyles.white,
    fontSize: 21.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? title20SemiBold = TextStyle(
    color: ColorStyles.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );

  static const TextStyle? title60Bold = TextStyle(
    color: ColorStyles.white,
    fontSize: 60.0,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontFamily: 'Jost',
    // letterSpacing: 1.1,
    height: 1.4,
  );
}

class Palette {
  late Color color;
  late Color dark;
  late Color semi;

  Palette({required this.color, required this.dark, required this.semi});
}

class PaletteTheme {
  late List<Palette> palette;

  PaletteTheme() {
    palette = [
      Palette(
          color: ColorStyles.accent,
          dark: ColorStyles.accentDark,
          semi: ColorStyles.accentSemiDark),
      Palette(
          color: ColorStyles.purple,
          dark: ColorStyles.purpleDark,
          semi: ColorStyles.purpleSemiDark),
      Palette(
          color: ColorStyles.blue,
          dark: ColorStyles.blueDark,
          semi: ColorStyles.blueSemiDark),
      Palette(
          color: ColorStyles.cyan,
          dark: ColorStyles.cyanDark,
          semi: ColorStyles.cyanSemiDark),
      Palette(
          color: ColorStyles.green,
          dark: ColorStyles.greenDark,
          semi: ColorStyles.greenSemiDark),
      Palette(
          color: ColorStyles.orange,
          dark: ColorStyles.orangeDark,
          semi: ColorStyles.orangeSemiDark),
      Palette(
          color: ColorStyles.red,
          dark: ColorStyles.redDark,
          semi: ColorStyles.redSemiDark),
    ];
  }
}

class ColorStyles {
  static const Color accent = Color(0xffff6f91);
  static const Color accentLight = Color(0x4dff6f91);
  static const Color accentDark = Color(0xffd7375d);
  static const Color accentSemiDark = Color(0xfff15a7e);
  static const Color black = Color(0xff3a3a3a);
  static const Color orange = Color(0xffff926f);
  static const Color orangeLight = Color(0x4dff926f);
  static const Color orangeSemiDark = Color(0xffec8564);
  static const Color orangeDark = Color(0xffc26f54);
  static const Color green = Color(0xff6cdd6a);
  static const Color greenLight = Color(0x4d6cdd6a);
  static const Color greenSemiDark = Color(0xff64cd62);
  static const Color greenDark = Color(0xff40ad3e);
  static const Color cyan = Color(0xff6ab8ff);
  static const Color cyanLight = Color(0x4d6ab8ff);
  static const Color cyanSemiDark = Color(0xff61a8ea);
  static const Color cyanDark = Color(0xff4f88bc);
  static const Color red = Color(0xffff6f6f);
  static const Color redLight = Color(0x4dff6f6f);
  static const Color redSemiDark = Color(0xffe36262);
  static const Color redDark = Color(0xffc35151);
  static const Color blue = Color(0xff6a8bff);
  static const Color blueLight = Color(0x4d6a8bff);
  static const Color blueSemiDark = Color(0xff6283f9);
  static const Color blueDark = Color(0xff5a74cf);
  static const Color purple = Color(0xff918eff);
  static const Color purpleLight = Color(0x4d918eff);
  static const Color purpleSemiDark = Color(0xff8582ed);
  static const Color purpleDark = Color(0xff7b79d6);
  static const Color yellow = Color(0xffffc25f);
  static const Color white = Color(0xffffffff);
  static const Color gray = Color(0xffdfdfdf);
  static const Color grayLight = Color(0xfff6f6f6);
  static const Color grayDark = Color(0xffbfbfbf);
}
