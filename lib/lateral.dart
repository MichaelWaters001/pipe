import 'dart:math';
import 'package:flutter/material.dart';
import 'fraction.dart';
import 'package:fraction/fraction.dart';

class Lateral extends StatefulWidget {
  @override
  _LateralState createState() => _LateralState();
}

class _LateralState extends State<Lateral> {
  bool displayFraction = true; // Initially display as fraction
  TextEditingController bsod = TextEditingController();
  TextEditingController bw = TextEditingController();
  TextEditingController hsod = TextEditingController();
  TextEditingController dl = TextEditingController();
  TextEditingController c2c = TextEditingController();
  List<double> ordinates4 = [];
  List<double> ordinates8 = [];
  double wrapToWrap = 0;
  double takeOff = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: bsod,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Branch Size OD'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: bw,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Branch Wall'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: hsod,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Header Size OD'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: dl,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Degree Lateral'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: c2c,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Desired Center to Center'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          double branchSizeOD = readDecOrFrac(bsod.text);
                          double branchWall = readDecOrFrac(bw.text);
                          double headerSizeOD = readDecOrFrac(hsod.text);
                          double degreeLateral = readDecOrFrac(dl.text);
                          double centerToCenter = readDecOrFrac(c2c.text);
                          setState(() {
                            var (o4, o8, w, t) = _calculateLateralOrdinates(
                                branchSizeOD,
                                branchWall,
                                headerSizeOD,
                                degreeLateral,
                                centerToCenter);
                            ordinates4 = o4;
                            ordinates8 = o8;
                            wrapToWrap = w;
                            takeOff = t;
                          });
                        },
                        child: Text('Calculate'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            displayFraction =
                                !displayFraction; // Toggle the display mode
                          });
                        },
                        child: Text('Toggle Dec / Frac'),
                      ),
                      Text(
                        'Ordinates:',
                        style: TextStyle(fontSize: 20),
                      ),
                      if (ordinates8.isNotEmpty)
                        ...ordinates8
                            .asMap()
                            .entries
                            .map(
                              (entry) => Text(
                                '${entry.key}: ${formatDouble(entry.value, displayFraction)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                            .toList(),
                      SizedBox(height: 10),
                      Text(
                        'Wrap to Wrap: ${formatDouble(wrapToWrap, displayFraction)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Take Off: ${formatDouble(takeOff, displayFraction)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bsod.dispose();
    bw.dispose();
    super.dispose();
  }
}

(List<double>, List<double>, double, double) _calculateLateralOrdinates(
    double branchSizeOD,
    double branchWall,
    double headerSizeOD,
    double degreeLateral,
    double centerToCenter) {
  const double pi = 3.1415926535897932;
  List<double> _4ordinates = [];
  List<double> _8ordinates = [];
  List<double> xDimensionBranch = [];

  double wrapToWrap = 0;
  double takeOff = 0;

  double branchIDRadius = ((branchSizeOD - (2 * branchWall)) / 2);
  double headerRadiusOD = (headerSizeOD / 2);

  _4ordinates.add(0);
  _8ordinates.add(0);
  xDimensionBranch.add(0);

  for (var i = 1; i <= 4; i++) {
    var s = sin(((90 / 4) * i) * pi / 180);
    xDimensionBranch.add(branchIDRadius * s);
    var xDimensionsHeader = xDimensionBranch[i] / headerRadiusOD;
    var degreeAtRadPt = acos(xDimensionsHeader) * 180 / pi;
    var sineOfDegrees = sin((degreeAtRadPt * pi / 180));
    var sinesXHeadRad = headerRadiusOD * sineOfDegrees;
    _4ordinates.add(headerRadiusOD - sinesXHeadRad);
  }

  for (var i = 1; i <= 8; i++) {
    var addSubDim = 0.0;
    switch (i) {
      case 1:
        addSubDim = branchIDRadius - xDimensionBranch[3];
        break;
      case 2:
        addSubDim = branchIDRadius - xDimensionBranch[2];
        break;
      case 3:
        addSubDim = branchIDRadius - xDimensionBranch[1];
        break;
      case 4:
        addSubDim = branchIDRadius - xDimensionBranch[0];
        break;
      case 5:
        addSubDim = branchIDRadius + xDimensionBranch[1];
        break;
      case 6:
        addSubDim = branchIDRadius + xDimensionBranch[2];
        break;
      case 7:
        addSubDim = branchIDRadius + xDimensionBranch[3];
        break;
      case 8:
        addSubDim = branchIDRadius * 2;
        break;
    }
    var cotanOfXDim = 1 / (tan(degreeLateral * pi / 180)) * addSubDim;
    if (i == 4) {
      takeOff = cotanOfXDim +
          (1 / (sin(degreeLateral * pi / 180)) * headerSizeOD / 2);
    }
    var cosecOfAngle = 0.0;
    switch (i) {
      case 1:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[1];
        break;
      case 2:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[2];
        break;
      case 3:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[3];
        break;
      case 4:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[4];
        break;
      case 5:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[3];
        break;
      case 6:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[2];
        break;
      case 7:
        cosecOfAngle = 1 / (sin(degreeLateral * pi / 180)) * _4ordinates[1];
        break;
      case 8:
        cosecOfAngle = 0;
        break;
    }
    _8ordinates.add(cotanOfXDim + cosecOfAngle);
  }

  wrapToWrap = centerToCenter - (2 * takeOff);

  return (_4ordinates, _8ordinates, wrapToWrap, takeOff);
}
