import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stepper_touch_test_jb/stepper.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0x000000),
        ),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ChangeNotifier {

  final double _initialValue = 123456.7;
  double _currentValue; fasdfasdfas; // is anything actually reading this????

  void updateValue(int decimalPlace, int value) {

    if (value < 0 || value > 9) {
      
      throw UnimplementedError();
    
    }

    String valueString = reverse(_currentValue.toString().replaceAll(".", ""));
    String beforeString = valueString.substring(0, decimalPlace + 1);
    String afterString = valueString.substring(decimalPlace + 2);
    String withoutDecimalPlace = reverse(beforeString + value.toString() + afterString);
    String newString = withoutDecimalPlace.substring(0, withoutDecimalPlace.length - 1) + "." +
      withoutDecimalPlace.substring(withoutDecimalPlace.length - 1);

    setState(() {
      _currentValue = double.parse(newString);
      notifyListeners();
    });

  }

  Widget getCounter(int decimalPlace, double value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepperTouch(
            initialValue: getFactor(decimalPlace, value),
            direction: Axis.vertical,
            withSpring: false,
            onChanged: (int value) {
              updateValue(decimalPlace, value);
              print('new value $value');
            },
          ),
    );
  }

  int getFactor(int decimalPlaces, double value) {

    var valueString = reverse(value.toStringAsFixed(1).replaceAll('.', ''));

    var digitString = valueString.substring(decimalPlaces + 1, decimalPlaces + 2);

    var digit = int.parse(digitString);

    return digit;
  }

  String reverse(String input) {

    print(input);

    return input.split('').reversed.join();

  }

  @override
  Widget build(BuildContext context) {

    _currentValue = _initialValue;
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: Row(
                children: <Widget>[
                  getCounter(5, _initialValue),
                  getCounter(4, _initialValue),
                  getCounter(3, _initialValue),
                  getCounter(2, _initialValue),
                  getCounter(1, _initialValue),
                  getCounter(0, _initialValue),
                  Text(".",style: TextStyle(color: Colors.white, fontSize: 128),),
                  getCounter(-1, _initialValue),
                  ],
              )),
              Text(_currentValue.toString(), style: TextStyle(color: Colors.white, fontSize: 64),)
            ],
          ),
        ),
      ),
    );
  }
}
