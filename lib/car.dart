import 'package:flutter/material.dart';

class Car extends StatelessWidget {
  var posX;
  var posY;
  var width;
  var height;
  Car({this.posX, this.posY, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(posX, posY),
      child: Container(
        child: SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            'lib/images/car.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
