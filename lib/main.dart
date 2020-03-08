import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0x000000),
        ),
        home: OdometerEdit(),
      ),
    );

class OdometerEdit extends StatefulWidget {
  @override
  _OdometerEditState createState() => _OdometerEditState();
}

class _OdometerEditState extends State<OdometerEdit> {

  final double _initialValue = 0;
  double _currentValue;

  _OdometerEditState() {

    _currentValue = _initialValue;
  
  }

  void updateValue(int decimalPlace, int value) {

    String valueString = reverse(_currentValue.toString().padLeft(8, "0").replaceAll(".", ""));
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

    var valueString = reverse(value.toStringAsFixed(1).padLeft(8, '0').replaceAll('.', ''));

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
              Text(_currentValue.toString().padLeft(8, "0"), style: TextStyle(fontSize: 64),),
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

/// the concept of the widget inspired
/// from [Nikolay Kuchkarov](https://dribbble.com/shots/3368130-Stepper-Touch).
/// i extended  the functionality to be more useful in real world applications
class StepperTouch extends StatefulWidget {
  const StepperTouch({
    Key key,
    this.initialValue,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.withSpring = true,
  }) : super(key: key);

  /// the orientation of the stepper its horizontal or vertical.
  final Axis direction;

  /// the initial value of the stepper
  final int initialValue;

  /// called whenever the value of the stepper changed
  final ValueChanged<int> onChanged;

  /// if you want a springSimulation to happens the the user let go the stepper
  /// defaults to true
  final bool withSpring;

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<StepperTouch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  int _internalValue;
  double _startAnimationPosX;
  double _startAnimationPosY;

  double _fontSize = 56.0;

  double _borderRadius = 60.0;

  double _plusSize = 40.0;

  double _minusSize = 40.0;

  int get _value => _internalValue;
  set _value(int value) {
    if (value < 0) value = 9;
    else if (value > 9) value = 0;
    
    _internalValue = value;
  }
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 0;
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: widget.direction == Axis.horizontal ? 280.0 : 120.0,
        height: widget.direction == Axis.horizontal ? 120.0 : 280.0,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(_borderRadius),
          color: Colors.white.withOpacity(0.2),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: widget.direction == Axis.horizontal ? 10.0 : null,
                bottom: widget.direction == Axis.horizontal ? null : 10.0,
                child: Icon(Icons.remove, size: _plusSize, color: Colors.white),
              ),
              Positioned(
                right: widget.direction == Axis.horizontal ? 10.0 : null,
                top: widget.direction == Axis.horizontal ? null : 10.0,
                child: Icon(Icons.add, size: _minusSize, color: Colors.white),
              ),
              GestureDetector(
                onHorizontalDragStart: _onPanStart,
                onHorizontalDragUpdate: _onPanUpdate,
                onHorizontalDragEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 5.0,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              child: child, scale: animation);
                        },
                        child: Text(
                          '$_value',
                          key: ValueKey<int>(_value),
                          style: TextStyle(
                              color: Color(0xFF6D72FF), fontSize: _fontSize),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;
    if (widget.direction == Axis.horizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    bool isHor = widget.direction == Axis.horizontal;
    bool changed = false;
    if (_controller.value <= -0.20) {
      setState(() => isHor ? _value-- : _value++);
      changed = true;
    } else if (_controller.value >= 0.20) {
      setState(() => isHor ? _value++ : _value--);
      changed = true;
    }
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
      new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      if (widget.direction == Axis.horizontal) {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
      } else {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed && widget.onChanged != null) {
      widget.onChanged(_value);
    }
  }
}