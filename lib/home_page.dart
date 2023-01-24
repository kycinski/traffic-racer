import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'car.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MyCar variables
  double playerX = 0;
  double playerY = 0.8;

  bool gameHasStarted = false;

  List<Car> enemyCarsList = [];

  var createEnemyCarTimer;
  var enemyCarsMoveTimer;

  var sideList = [-0.65, 0.65];

  // MyCar control
  void moveControl(event) {
    {
      if (gameHasStarted) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
        gameHasStarted = true;
        startGame();
      }
    }
  }

  void moveLeft() {
    setState(() {
      playerX = sideList[0];
    });
  }

  void moveRight() {
    setState(() {
      playerX = sideList[1];
    });
  }

  void enemyCarsMove() {
    setState(() {
      for (var car in enemyCarsList) {
        car.posY = car.posY + 0.05;

        // Remove car after screen
        if (car.posY > 2) {
          enemyCarsList.remove(car);
        }

        // Collision detection
        if (playerX == car.posX &&
            playerY - car.posY <= 0.65 &&
            car.posY - playerY <= 0.65) {
          enemyCarsMoveTimer.cancel();

          gameHasStarted = false;
        }
      }
    });
  }

  randomNumber(min, max) {
    Random random = Random();
    return random.nextInt(max);
  }

  void createEnemyCar() {
    var newCar = Car();
    newCar.posY = -2;
    newCar.posX = sideList[randomNumber(0, 2)];
    setState(() {
      enemyCarsList.add(newCar);
    });
  }

  void startGame() {
    createEnemyCarTimer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      createEnemyCar();
    });
    enemyCarsMoveTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      enemyCarsMove();
    });
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
        onKey: moveControl,
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
                      posX: playerX,
                      posY: playerY,
                      width: carWidth,
                      height: carHeight,
                    ),
                    for (var car in enemyCarsList)
                      Car(
                        width: carWidth,
                        height: carHeight,
                        posX: car.posX,
                        posY: car.posY,
                      ),
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
