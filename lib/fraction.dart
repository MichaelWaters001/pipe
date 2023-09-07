import 'package:fraction/fraction.dart';

String asFraction(double value) {
  var sixteenths = (value * 16).round();
  var frac = MixedFraction.fromDouble((sixteenths / 16));
  //do not display denominators of 1
  if (frac.denominator == 1){
    return value.round().toString();
  }
  return frac.toString();
}
