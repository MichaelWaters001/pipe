import 'package:fraction/fraction.dart';

String formatDouble(double value, bool fraction) {
  if (value.isNaN) {
    return "";
  }
  if (fraction) {
    var sixteenths = (value * 16).round();
    var frac = MixedFraction.fromDouble((sixteenths / 16));
    //do not display denominators of 1
    if (frac.denominator == 1) {
      return value.round().toString();
    }
    return frac.toString();
  } else {
    return value.toStringAsFixed(4);
  }
}

double readDecOrFrac(String value) {
  try {
    return MixedFraction.fromString(value).toDouble();
  } on Exception {
    return double.tryParse(value) ?? 0;
  }
}
