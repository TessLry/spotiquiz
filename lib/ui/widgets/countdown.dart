import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Coutdown extends StatefulWidget {
  final int timeLeft;
  final AnimationController animationController;

  const Coutdown({
    super.key,
    required this.timeLeft,
    required this.animationController,
  });

  @override
  State<Coutdown> createState() => _CoutdownState();
}

class _CoutdownState extends State<Coutdown> {
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
