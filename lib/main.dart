import 'package:flutter/material.dart';
import 'math.dart';

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
                        controller: _BSOD,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Branch Size OD'),
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
                        decoration:
                            InputDecoration(labelText: 'Header Size OD'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _DI,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Degrees Lateral'),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _OC,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Ordinance Count'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          double branchSizeOD =
                              double.tryParse(_BSOD.text) ?? 0;
                          double branchWall = double.tryParse(_BW.text) ?? 0;
                          double headerSizeOD =
                              double.tryParse(_HSOD.text) ?? 0;
                          double degreeIntersect =
                              double.tryParse(_DI.text) ?? 0;
                          int ordinatesCount = int.tryParse(_OC.text) ?? 0;

                          setState(() {
                            _ordinates = calculateOrdinates(
                              branchSizeOD,
                              branchWall,
                              headerSizeOD,
                              degreeIntersect,
                              ordinatesCount,
                            );
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
                      Text(
                        'Ordinates:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      if (_ordinates.isNotEmpty)
                        ..._ordinates
                            .asMap()
                            .entries
                            .map(
                              (entry) => Text(
                                'Ordinate ${entry.key}: ${entry.value.toStringAsFixed(4)}',
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
    _BSOD.dispose();
    _BW.dispose();
    super.dispose();
  }
}
