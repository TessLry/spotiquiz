import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Countdown extends StatefulWidget {
  final int timeLeft;
  final AnimationController animationController;

  const Countdown({
    super.key,
    required this.timeLeft,
    required this.animationController,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.timeLeft.toString(),
      style: TextStyle(
        fontSize: 50 - widget.timeLeft * 5,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    )
        .animate(controller: widget.animationController)
        .fadeIn()
        .slideY()
        .then()
        .shake();
  }
}
