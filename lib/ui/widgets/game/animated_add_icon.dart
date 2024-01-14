import 'package:flutter/material.dart';
import 'package:spotiquiz/utils/colors.dart';

class AnimatedAddIcon extends StatefulWidget {
  final bool isAdd;
  final VoidCallback onTap;

  const AnimatedAddIcon({Key? key, required this.onTap, required this.isAdd})
      : super(key: key);

  @override
  State<AnimatedAddIcon> createState() => _AnimatedAddIconState();
}

class _AnimatedAddIconState extends State<AnimatedAddIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        setState(() {
          if (widget.isAdd) {
            _controller.forward();
          } else {
            _controller.reverse();
          }

          widget.onTap();
        });
      },
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1.25, end: 1).animate(anim)
                    : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
          child: widget.isAdd
              ? const Icon(
                  Icons.done,
                  key: ValueKey('icon1'),
                  color: AppColors.primary,
                )
              : const Icon(
                  Icons.add,
                  key: ValueKey('icon2'),
                )),
    ));
  }
}
