import 'package:flutter/material.dart';

class Car extends StatelessWidget {
  var posX;
  var posY;
  var width;
  var height;
  var angle;
  Car({super.key, this.posX, this.posY, this.width, this.height, this.angle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(posX, posY),
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            'lib/images/car.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
