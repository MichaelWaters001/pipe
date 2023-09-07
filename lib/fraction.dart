import 'package:fraction/fraction.dart';

String formatDouble(double value, bool fraction) {
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
