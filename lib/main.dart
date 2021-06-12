import 'dart:async';
import 'package:flip_animatin/clock_animation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flipio Clock",
      home: AnimatedClock(),
    );
  }
}

class AnimatedClock extends StatefulWidget {
  @override
  _AnimatedClockState createState() => _AnimatedClockState();
}

class _AnimatedClockState extends State<AnimatedClock> {
  //datatypes
  static DateTime _currentTime = DateTime.now();

  Stream _timer = Stream.periodic(Duration(seconds: 1), (i) {
    _currentTime = _currentTime.add(Duration(seconds: 1));
    return _currentTime;
  });

  bool _listnerStarted = false;

  _listenToTime() {
    _timer.listen((event) {
      print(event);
      _currentTime = DateTime.parse(event.toString());
    });
    _listnerStarted = true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    !_listnerStarted ? _listenToTime() : print("listener is working");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: OrientationBuilder(
          builder: (context, _layout) {
            if (_layout == Orientation.portrait)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClockAnimation(
                    orientation: _layout,
                    timerDuration:
                        Duration(minutes: 60 - _currentTime.minute.toInt()),
                    limit: 23,
                    start: 00,
                    onTime: _currentTime.hour.toInt(),
                  ),
                  ClockAnimation(
                    orientation: _layout,
                    timerDuration:
                        Duration(seconds: 60 - _currentTime.second.toInt()),
                    limit: 59,
                    start: 00,
                    onTime: _currentTime.minute.toInt(),
                  ),
                ],
              );
            else
              return Padding(
                padding: EdgeInsets.symmetric(vertical: height / 2 - 110),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClockAnimation(
                      orientation: _layout,
                      timerDuration:
                          Duration(minutes: 60 - _currentTime.minute.toInt()),
                      limit: 23,
                      start: 00,
                      onTime: _currentTime.hour.toInt(),
                    ),
                    ClockAnimation(
                      orientation: _layout,
                      timerDuration:
                          Duration(seconds: 60 - _currentTime.second.toInt()),
                      limit: 59,
                      start: 00,
                      onTime: _currentTime.minute.toInt(),
                    ),
                    ClockAnimation(
                      orientation: _layout,
                      timerDuration: Duration(seconds: 1),
                      limit: 59,
                      start: 00,
                      onTime: _currentTime.second.toInt(),
                    ),
                  ],
                ),
              );
          },
        ),
      ),
    );
  }
}
