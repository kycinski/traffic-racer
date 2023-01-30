import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'car.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MyCar variables
  double playerX = 0.65;
  double playerY = 0.8;
  double carAngle = 0;

  double score = 0;
  bool gameHasStarted = false;
  bool collision = false;

  List<Car> enemyCarsList = [];

  Timer? createEnemyCarTimer;
  Timer? enemyCarsMoveTimer;
  Timer? changeSideTimer;

  var sideList = [-0.65, 0.65];

  // MyCar control
  void keyboardControl(event) {
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

  void touchControl(details) {
    if (gameHasStarted) {
      if (details.localPosition.dx < (MediaQuery.of(context).size.width / 2)) {
        moveLeft();
      } else {
        moveRight();
      }
    } else {
      gameHasStarted = true;
      startGame();
    }
  }

  void moveLeft() {
    changeSideTimer?.cancel();
    changeSideTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (playerX > sideList[0]) {
        setState(() {
          playerX -= 0.05;
          carAngle = -0.3;
        });
      }

      if (playerX <= sideList[0]) {
        changeSideTimer?.cancel();
        carAngle = 0;
      }
    });
  }

  void moveRight() {
    changeSideTimer?.cancel();
    changeSideTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (playerX < sideList[1]) {
        setState(() {
          playerX += 0.05;
          carAngle = 0.3;
        });
      }

      if (playerX >= sideList[1]) {
        changeSideTimer?.cancel();
        carAngle = 0;
      }
    });
  }

  void enemyCarsMove() {
    setState(() {
      enemyCarsList.removeWhere((car) {
        // Remove after screen
        if (car.posY > 2) {
          return true;
        }
        // else move a car
        car.posY = car.posY + 0.05;

        // Collision detection
        if (((playerX < 0
                    ? car.posX + playerX >= 0.1
                    : car.posX + playerX <= -0.1) ||
                playerX == car.posX) &&
            (playerY - car.posY <= 0.65 && car.posY - playerY <= 0.65)) {
          enemyCarsMoveTimer?.cancel();
          changeSideTimer?.cancel();
          createEnemyCarTimer?.cancel();
          gameHasStarted = false;
          collision = true;
          _showDialog();
        }
        return false;
      });
    });
  }

  randomNumber(min, max) {
    Random random = Random();
    return random.nextInt(max);
  }

  void createEnemyCar() {
    var newCar = Car();
    newCar.posY = -2.0;
    newCar.posX = sideList[randomNumber(0, 2)];
    setState(() {
      enemyCarsList.add(newCar);
    });
  }

  void startGame() {
    if (collision) {
      resetGame();
      collision = false;
      gameHasStarted = false;
    } else {
      createEnemyCarTimer =
          Timer.periodic(const Duration(milliseconds: 2000), (timer) {
        createEnemyCar();
        score += 1;
      });
      enemyCarsMoveTimer =
          Timer.periodic(const Duration(milliseconds: 50), (timer) {
        enemyCarsMove();
      });
    }
  }

  void resetGame() {
    setState(() {
      Navigator.pop(context);
      enemyCarsList.clear();
      playerX = 0.65;
      carAngle = 0;
      score = 0;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("GAME OVER\n SCORE: $score"),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double totalWidth = mediaQuery.width;
    double carWidth = totalWidth * 1 / 3;
    double carHeight = mediaQuery.height * 0.25;
    String startText = "TAP TO PLAY";
    if (kIsWeb) {
      carWidth = mediaQuery.width * 0.1;
      totalWidth = mediaQuery.width * 0.3;
      startText = "PRESS SPACE TO START";
    }
    return Scaffold(
      backgroundColor: Colors.green,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: keyboardControl,
        child: GestureDetector(
          onTapDown: touchControl,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: totalWidth,
                  height: mediaQuery.height,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Car(
                        posX: playerX,
                        posY: playerY,
                        width: carWidth,
                        height: carHeight,
                        angle: carAngle,
                      ),
                      for (var car in enemyCarsList)
                        Car(
                          width: carWidth,
                          height: carHeight,
                          posX: car.posX,
                          posY: car.posY,
                          angle: 0.0,
                        ),
                      Container(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? score.toString() : startText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
