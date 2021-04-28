import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SampleAnimation(),
    );
  }
}

class SampleAnimation extends StatefulWidget {
  SampleAnimation();

  @override
  State<StatefulWidget> createState() {
    return SampleAnimationState();
  }
}

class SampleAnimationState extends State<SampleAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Path _path;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    _path = drawPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: CustomPaint(
              painter: PathPainter(_path),
            ),
          ),
          Positioned(
            top: calculate(_animation.value).dy,
            left: calculate(_animation.value).dx,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10)),
              width: 10,
              height: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath() {
    Size size = Size(300, 300);
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 2);
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
///////////////////////////////
///
// import 'package:flutter/material.dart';

// void main() {
//   runApp(new Test());
// }

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> with TickerProviderStateMixin {
//   AnimationController _resizableController;

//   static Color colorVariation(int note) {
//     if (note <= 1) {
//       return Colors.blue[50];
//     } else if (note > 1 && note <= 2) {
//       return Colors.blue[100];
//     } else if (note > 2 && note <= 3) {
//       return Colors.blue[200];
//     } else if (note > 3 && note <= 4) {
//       return Colors.blue[300];
//     } else if (note > 4 && note <= 5) {
//       return Colors.blue[400];
//     } else if (note > 5 && note <= 6) {
//       return Colors.blue;
//     } else if (note > 6 && note <= 7) {
//       return Colors.blue[600];
//     } else if (note > 7 && note <= 8) {
//       return Colors.blue[700];
//     } else if (note > 8 && note <= 9) {
//       return Colors.blue[800];
//     } else if (note > 9 && note <= 10) {
//       return Colors.blue[900];
//     }
//   }

//   AnimatedBuilder getContainer() {
//     return new AnimatedBuilder(
//         animation: _resizableController,
//         builder: (context, child) {
//           return Container(
//             //color: colorVariation((_resizableController.value *100).round()),
//             padding: EdgeInsets.all(24),
//             child: Text("SAMPLE"),
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.all(Radius.circular(12)),
//               border: Border.all(
//                   color:
//                       colorVariation((_resizableController.value * 10).round()),
//                   width: 10),
//             ),
//           );
//         });
//   }

//   @override
//   void initState() {
//     _resizableController = new AnimationController(
//       vsync: this,
//       duration: new Duration(
//         milliseconds: 500,
//       ),
//     );
//     _resizableController.addStatusListener((animationStatus) {
//       switch (animationStatus) {
//         case AnimationStatus.completed:
//           _resizableController.reverse();
//           break;
//         case AnimationStatus.dismissed:
//           _resizableController.forward();
//           break;
//         case AnimationStatus.forward:
//           break;
//         case AnimationStatus.reverse:
//           break;
//       }
//     });
//     _resizableController.forward();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             backgroundColor: Colors.white,
//             body: Center(child: getContainer())));
//   }
// }
