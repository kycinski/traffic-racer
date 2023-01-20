import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'car.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // My car variables
  double playerX = 120;

  // MyCar control
  void moveLeft() {
    setState(() {
      playerX = 40;
    });
  }

  void moveRight() {
    setState(() {
      playerX = 200;
    });
  }

  void enemyCarsMove() {
    setState(() {});
  }

  void startGame() {
    //...
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double carWidth = mediaQuery.width * 0.1;
    double carHeight = mediaQuery.height * 0.25;
    return Scaffold(
      backgroundColor: Colors.green,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            moveLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
          } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
            startGame();
          }
        },
        child: Column(
          children: [
            Center(
              child: Container(
                width: mediaQuery.width * 0.3,
                height: mediaQuery.height,
                color: Colors.black,
                child: Stack(
                  children: [
                    Car(
                      left: playerX,
                      top: 500,
                      width: carWidth,
                      height: carHeight,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
