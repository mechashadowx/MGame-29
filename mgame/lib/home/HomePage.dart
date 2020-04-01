import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int level, lights;
  List<bool> isOn;
  bool isPlay, isAnswering;
  List<int> answer, userAnswer;
  String state;
  Color color;

  @override
  void initState() {
    super.initState();
    level = lights = 1;
    isOn = List();
    for (int i = 0; i < 9; i++) {
      isOn.add(false);
    }
    isPlay = isAnswering = false;
    answer = List();
    userAnswer = List();
    state = 'Go';
  }

  start() {
    setState(() {
      answer.clear();
      userAnswer.clear();
      lights = level;
      isAnswering = false;
      state = 'Wait...';
    });
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        setState(() {
          if (lights > 0) {
            int rand = Random().nextInt(9);
            while (isOn[rand]) {
              rand = Random().nextInt(9);
            }
            for (int i = 0; i < 9; i++) {
              isOn[i] = false;
            }
            answer.add(rand);
            isOn[rand] = true;
          }
          lights--;
          if (lights == -1) {
            for (int i = 0; i < 9; i++) {
              isOn[i] = false;
            }
            state = 'Solve';
            isAnswering = true;
            t.cancel();
          }
        });
      },
    );
  }

  getAnswer(int index) {
    if (isAnswering) {
      setState(() {
        userAnswer.add(index);
        if (userAnswer.length == level) {
          if (!check()) {
            state = 'Reset';
          } else {
            levelUp();
          }
        }
      });
    }
  }

  bool check() {
    for (int i = 0; i < level; i++) {
      if (answer[i] != userAnswer[i]) {
        return false;
      }
    }
    return true;
  }

  levelUp() {
    setState(() {
      level++;
      isAnswering = false;
      state = 'Go';
    });
  }

  reset() {
    setState(() {
      level = 1;
      isAnswering = false;
      state = 'Go';
    });
  }

  click() {
    setState(() {
      // color = Color(0x88AD77A3);
    });
  }

  clickCancle() {
    setState(() {
      // color = Color(0xFFCCDEFA);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFCCDEFA),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(5, (index) {
                int number = index + 1;
                if (number == 4) {
                  number = 2;
                } else if (number == 5) {
                  number = 1;
                }
                List<int> id = List();
                if (index == 0) {
                  id = [0];
                }
                if (index == 1) {
                  id = [1, 2];
                }
                if (index == 2) {
                  id = [3, 4, 5];
                }
                if (index == 3) {
                  id = [6, 7];
                }
                if (index == 4) {
                  id = [8];
                }
                return Container(
                  margin: EdgeInsets.all(data.size.width * 0.25 * 0.05),
                  child: CustomRow(
                    number: number,
                    size: data.size.width * 0.25,
                    isOn: isOn,
                    id: id,
                    getAnswer: getAnswer,
                    click: click,
                    clickCancle: clickCancle,
                    color: color,
                  ),
                );
              }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: data.size.height * 0.05,
              left: data.size.width * 0.05,
            ),
            alignment: Alignment.topLeft,
            child: Text(
              'Level ' + level.toString(),
              style: TextStyle(
                color: Color(0xFFAD77A3),
                fontSize: data.size.width * 0.08,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (state == 'Go') {
                start();
              } else if (state == 'Reset') {
                reset();
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                top: data.size.height * 0.05,
                right: data.size.width * 0.05,
              ),
              alignment: Alignment.topRight,
              child: Text(
                state,
                style: TextStyle(
                  color: Color(0xFFAD77A3),
                  fontSize: data.size.width * 0.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final int number;
  final double size;
  final List<bool> isOn;
  final List<int> id;
  final Function getAnswer, click, clickCancle;
  final Color color;

  CustomRow({
    this.number,
    this.size,
    this.isOn,
    this.id,
    this.getAnswer,
    this.click,
    this.clickCancle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(number, (index) {
            return GestureDetector(
              onTap: () {
                getAnswer(id[index]);
                click();
              },
              onTapCancel: clickCancle,
              child: Container(
                height: size,
                width: size,
                margin: EdgeInsets.all(size * 0.1),
                decoration: BoxDecoration(
                  color: Color(0xFFCCDEFA),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE1EDFF),
                      offset: Offset(-15, -15),
                      blurRadius: 20,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Color(0xFFBACAE3),
                      offset: Offset(15, 15),
                      blurRadius: 20,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: (isOn[id[index]]
                    ? Center(
                        child: Container(
                          height: size * 0.75,
                          width: size * 0.75,
                          decoration: BoxDecoration(
                            color: Color(0xFFAD77A3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          height: size * 0.75,
                          width: size * 0.75,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
              ),
            );
          }),
        ),
      ),
    );
  }
}
