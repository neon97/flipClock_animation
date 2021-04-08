import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flipio Clock",
      home: _AnimatedWidgetExample(),
    );
  }
}

class _AnimatedWidgetExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AnimatedWidgetExampleState();
}

class _AnimatedWidgetExampleState extends State<_AnimatedWidgetExample>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );

    _animation = Tween<double>(
      end: math.pi,
      begin: math.pi * 2,
    ).animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });

    // _controller.forward();     //when you are not using the timer
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flippio Clock"),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.ac_unit),
          //     onPressed: () {
          //       print(_animation.value);
          //       _controller.reset();
          //       setState(() {
          //         _count++;
          //       });
          //       _controller.forward();
          //       print(_animation.value);
          //     },
          //   )
          // ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(50.0),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 99.0,
                          width: 200.0,
                          color: Colors.green,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  top: 40.0,
                                  child: Text(
                                    _start.toString(),
                                    style: TextStyle(fontSize: 100.0),
                                  ))
                            ],
                          )),
                      SizedBox(
                        height: 2.0,
                      ),
                      Stack(
                        children: [
                          Container(
                              height: 99.0,
                              width: 200.0,
                              color: Colors.green,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                      bottom: 40.0,
                                      child: Text(
                                        _start.toString(),
                                        style: TextStyle(fontSize: 100.0),
                                      ))
                                ],
                              )),
                          AnimatedBuilder(
                              animation: _animation,
                              child: Container(
                                  height: 99.0,
                                  width: 200.0,
                                  color: Colors.green,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _animation.value > 4.71
                                          ? Positioned(
                                              bottom: 40.0,
                                              child: Text(
                                                _start.toString(),
                                                style:
                                                    TextStyle(fontSize: 100.0),
                                              ),
                                            )
                                          : Positioned(
                                              top: 60.0,
                                              child: Transform(
                                                transform:
                                                    Matrix4.rotationX(math.pi),
                                                child: Text(
                                                  _start.toString(),
                                                  style: TextStyle(
                                                      fontSize: 100.0),
                                                ),
                                              ))
                                    ],
                                  )),
                              builder: (context, child) {
                                return Transform(
                                    alignment: Alignment.topCenter,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.003)
                                      ..rotateX(_animation.value),
                                    child: child);
                              })
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 99),
                    child: Container(
                      color: Colors.white,
                      height: 2.0,
                      width: 200.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Timer _timer;
  int _start = 00;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 60) {
          setState(() {
            _start = 00;
          });
        } else {
          _controller.reset();
          setState(() {
            _start++;
          });
          _controller.forward();
        }
      },
    );
  }

  double angle = 2 * math.pi;

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
