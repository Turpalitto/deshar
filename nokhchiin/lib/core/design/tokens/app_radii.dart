/// Скругления для kids / adult скинов.
abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static double card(bool isKids) => isKids ? xxl : lg;
  static double button(bool isKids) => isKids ? xl : md;
  static double chip(bool isKids) => isKids ? lg : sm;
}
