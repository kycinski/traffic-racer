import 'package:flutter/material.dart';

class Car extends StatelessWidget {
  var left;
  var top;
  var width;
  var height;
  // const Car({super.key});
  Car({this.left, this.top, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        color: Colors.red,
        child: SizedBox(
          height: height,
          width: width,
        ),
      ),
    );
  }
}
