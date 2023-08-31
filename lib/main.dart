import 'dart:math';

import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Home'),
      ),
      body: ElevatedButton(
        child: Text('Lateral Calculator'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LateralCalculator(),
            ),
          );
        },
      ),
    );
  }
}

class LateralCalculator extends StatefulWidget {
  @override
  _LateralCalculatorState createState() => _LateralCalculatorState();
}

class _LateralCalculatorState extends State<LateralCalculator> {
  TextEditingController _BSOD = TextEditingController();
  TextEditingController _BW = TextEditingController();
  TextEditingController _HSOD = TextEditingController();
  TextEditingController _DI = TextEditingController();
  TextEditingController _OC = TextEditingController();
  List<double> _ordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _BSOD,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Branch Size OD'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _BW,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Branch Wall'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _HSOD,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Header Size OD'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _DI,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Degrees Lateral'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _OC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ordinance Count'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double branchSizeOD = double.tryParse(_BSOD.text) ?? 0;
                double branchWall = double.tryParse(_BW.text) ?? 0;
                double headerSizeOD = double.tryParse(_HSOD.text) ?? 0;
                double degreeIntersect = double.tryParse(_DI.text) ?? 0;
                int ordinatesCount = int.tryParse(_OC.text) ?? 0;
                
                double branchIDRadius = ((branchSizeOD - ( 2 * branchWall ) ) / 2 );
                double headerRadiusOD = (headerSizeOD / 2);
                const double pi = 3.1415926535897932;
                setState(() {
                  _ordinates.clear();
                  _ordinates.add(0);
                  for (var i = 1; i <= ordinatesCount; i++) {
                    var s = sin( ((degreeIntersect / ordinatesCount) * i ) * pi / 180 );
                    var xDimensionBranch = branchIDRadius * s; 
                    var xDimensionsHeader = xDimensionBranch / headerRadiusOD;
                    var degreeAtRadPt = acos(xDimensionsHeader)*180/pi;
                    var sineOfDegrees = sin((degreeAtRadPt * pi / 180));
                    var sinesXHeadRad = headerRadiusOD * sineOfDegrees;
                    _ordinates.add(headerRadiusOD - sinesXHeadRad);
                  }
                });
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              'Ordinates: $_ordinates',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _BSOD.dispose();
    _BW.dispose();
    super.dispose();
  }
}
