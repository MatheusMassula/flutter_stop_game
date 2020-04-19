import 'package:flutter/material.dart';
import 'dart:math';

class CircularTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onTap;

  const CircularTimer({
    Key key,
    @required this.seconds,
    this.onTap,
  }) : assert(seconds > 0), super(key: key);

  @override
  CircularTimerState createState() => CircularTimerState();
}

class CircularTimerState extends State<CircularTimer> with TickerProviderStateMixin {
  AnimationController controller;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          alignment: FractionalOffset.center,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child) {
                      return CustomPaint(
                        painter: TimerPainter(
                          animation: controller,
                          backgroundColor: Colors.white,
                          color: Colors.green,
                        )
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return Icon(controller.isAnimating
                              ? Icons.pause
                              : Icons.play_arrow);
                          },
                        ),
                        onPressed: () {
                          if (controller.isAnimating) {
                            setState(() {
                              controller.stop(canceled: true);
                            });
                          } else {
                            controller.reverse(
                              from: _reverseControllerValue(controller.value)
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _reverseControllerValue(double currentValue) {
    if(currentValue == 0.0) {
      widget.onTap();
      return 1.0;
    }
    else {
      return currentValue;
    }
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
      color != old.color ||
      backgroundColor != old.backgroundColor;
  }
}