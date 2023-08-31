import 'dart:math';

List<double> calculateOrdinates(
  double branchSizeOD,
  double branchWall,
  double headerSizeOD,
  double degreeIntersect,
  int ordinatesCount,
) {
  List<double> ordinates = [];

  double branchIDRadius = ((branchSizeOD - (2 * branchWall)) / 2);
  double headerRadiusOD = (headerSizeOD / 2);
  const double pi = 3.1415926535897932;

  ordinates.add(0);

  for (var i = 1; i <= ordinatesCount; i++) {
    var s = sin(((degreeIntersect / ordinatesCount) * i) * pi / 180);
    var xDimensionBranch = branchIDRadius * s;
    var xDimensionsHeader = xDimensionBranch / headerRadiusOD;
    var degreeAtRadPt = acos(xDimensionsHeader) * 180 / pi;
    var sineOfDegrees = sin((degreeAtRadPt * pi / 180));
    var sinesXHeadRad = headerRadiusOD * sineOfDegrees;
    ordinates.add(headerRadiusOD - sinesXHeadRad);
  }

  return ordinates;
}


