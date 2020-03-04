import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stepper_touch_test_jb/stepper.dart';
import 'package:vector_math/vector_math_64.dart';

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

  Widget getCounter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepperTouch(
            initialValue: 5,
            direction: Axis.vertical,
            withSpring: false,
            onChanged: (int value) => print('new value $value'),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform(
                transform: Matrix4.diagonal3(Vector3(0.5, 0.5, 0.5)),
                child: Row(
                children: <Widget>[
                  getCounter(),
                  getCounter(),
                  getCounter()
                  ],
              ))
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Transform(
              //     transform: Matrix4.diagonal3(Vector3(0.5, 0.5, 0.5)),
              //     child: StepperTouch(
              //     initialValue: 5,
              //     onChanged: (int value) => print('new value $value'),
              //   )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
