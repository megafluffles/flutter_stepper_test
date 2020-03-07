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

class _MyAppState extends State<MyApp> {

  final double _initialValue = 123456.7;
  double _currentValue;

  _MyAppState() {

    _currentValue = _initialValue;
  
  }

  void updateValue(int decimalPlace, int value) {

    // if (value < 0 || value > 9) {
      
    //   throw UnimplementedError();
    
    // }

    String valueString = reverse(_currentValue.toString().replaceAll(".", ""));
    String beforeString = valueString.substring(0, decimalPlace + 1);
    String afterString = valueString.substring(decimalPlace + 2);
    String withoutDecimalPlace = reverse(beforeString + value.toString() + afterString);
    String newString = withoutDecimalPlace.substring(0, withoutDecimalPlace.length - 1) + "." +
      withoutDecimalPlace.substring(withoutDecimalPlace.length - 1);

    setState(() {
      _currentValue = double.parse(newString);
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

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(_currentValue.toString(), style: TextStyle(fontSize: 64),),
              FittedBox(
                child: Row(
                children: <Widget>[
                  getCounter(5, _currentValue),
                  getCounter(4, _currentValue),
                  getCounter(3, _currentValue),
                  getCounter(2, _currentValue),
                  getCounter(1, _currentValue),
                  getCounter(0, _currentValue),
                  Text(".",style: TextStyle(fontSize: 128),),
                  getCounter(-1, _currentValue),
                  ],
              )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: RaisedButton(child: Text("Set"), onPressed: null,)
              )
            ],
          ),
        ),
      ),
    );
  }
}
