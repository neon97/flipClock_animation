import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class ClockAnimation extends StatefulWidget {
  final Duration timerDuration;
  final int limit;
  final int start;
  final int onTime;
  final bool showhour;
  final String ampm;
  ClockAnimation(
      {this.timerDuration,
      this.limit,
      this.start,
      this.onTime,
      this.showhour,
      this.ampm});

  @override
  _ClockAnimationState createState() => _ClockAnimationState();
}

class _ClockAnimationState extends State<ClockAnimation>
    with SingleTickerProviderStateMixin {
//datatypes
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _start = widget.onTime;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 99.0,
                  width: 200.0,
                  decoration: _boxDecoration(true),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(top: 5.0, child: _timeText()),
                      //show am/pm
                      widget.showhour
                          ? Positioned(
                              top: 10.0,
                              left: 10.0,
                              child: Text(widget.ampm ?? "",
                                  style: GoogleFonts.fredokaOne(
                                      fontSize: 18,
                                      color: whiteColor)),
                            )
                          : SizedBox.shrink(),
                    ],
                  )),
              Divider(
                height: 4.0,
                color: Colors.black,
              ),
              Stack(
                children: [
                  Container(
                      height: 99.0,
                      width: 200.0,
                      decoration: _boxDecoration(false),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(bottom: 15.0, child: _timeText())
                        ],
                      )),
                  AnimatedBuilder(
                      animation: _animation,
                      child: Container(
                          height: 100.0,
                          width: 200.0,
                          decoration: _boxDecoration(false),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _animation.value > 4.71
                                  ? Positioned(bottom: 15.0, child: _timeText())
                                  : Positioned(
                                      top: 95.0,
                                      child: Transform(
                                          transform: Matrix4.rotationX(math.pi),
                                          child: _timeText()))
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
              color: Colors.black,
              height: 4.0,
              width: 200.0,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(bool top) => BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(top ? 10 : 0),
          topRight: Radius.circular(top ? 10 : 0),
          bottomLeft: Radius.circular(top ? 0 : 10),
          bottomRight: Radius.circular(top ? 0 : 10)),
      color: Color.fromRGBO(20, 20, 20, 1));

  Text _timeText() {
    return Text(
      _start.toString().padLeft(2, '0'),
      style: GoogleFonts.fredokaOne(
          fontSize: 150.0, color: whiteColor),
    );
  }

  Timer _timer;
  int _start;

  void startTimer() {
    Duration oneSec = widget.timerDuration;
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == widget.limit) {
          setState(() {
            _start = widget.start;
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
