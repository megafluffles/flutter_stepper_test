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

  Widget getCounter(double factor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepperTouch(
            initialValue: 0,
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
              FittedBox(
                child: Row(
                children: <Widget>[
                  getCounter(100000),
                  getCounter(10000),
                  getCounter(1000),
                  getCounter(100),
                  getCounter(10),
                  getCounter(1),
                  Text(".",style: TextStyle(color: Colors.white, fontSize: 128),),
                  getCounter(0.1)
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
