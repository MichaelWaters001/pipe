import 'dart:math';
import 'package:flutter/material.dart';
import 'fraction.dart';

class NintyIntersection extends StatefulWidget {
  @override
  _NintyIntersectionState createState() => _NintyIntersectionState();
}

class _NintyIntersectionState extends State<NintyIntersection> {
  bool displayFraction = true; // Initially display as fraction
  TextEditingController bsod = TextEditingController();
  TextEditingController bw = TextEditingController();
  TextEditingController hsod = TextEditingController();
  List<double> ordinates = [];

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
                      ElevatedButton(
                        onPressed: () {
                          double branchSizeOD = readDecOrFrac(bsod.text);
                          double branchWall = readDecOrFrac(bw.text);
                          double headerSizeOD = readDecOrFrac(hsod.text);
                          setState(() {
                            ordinates = _calculateOrdinates(
                                branchSizeOD, branchWall, headerSizeOD);
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
                      SizedBox(height: 10),
                      if (ordinates.isNotEmpty)
                        ...ordinates
                            .asMap()
                            .entries
                            .map(
                              (entry) => Text(
                                '${entry.key}: ${formatDouble(entry.value, displayFraction)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                            .toList(),
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

List<double> _calculateOrdinates(
    double branchSizeOD, double branchWall, double headerSizeOD) {
  const degreeIntersect = 90;
  const ordinatesCount = 4;
  const double pi = 3.1415926535897932;
  List<double> ordinates = [];

  double branchIDRadius = ((branchSizeOD - (2 * branchWall)) / 2);
  double headerRadiusOD = (headerSizeOD / 2);

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
