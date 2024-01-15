import 'package:flutter/material.dart';

class ScrollableText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final int lenghtOverflow;

  const ScrollableText(
      {super.key,
      required this.text,
      this.textStyle,
      required this.lenghtOverflow});

  @override
  State<ScrollableText> createState() => _ScrollableTextState();
}

class _ScrollableTextState extends State<ScrollableText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= widget.lenghtOverflow) {
      return Text(
        widget.text,
        style: widget.textStyle,
        overflow: TextOverflow.clip,
        softWrap: false,
      );
    }

    //TODO essayer de right 0 à left 0

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(-_controller.value * 100, 0),
              child: Text(
                widget.text,
                style: widget.textStyle,
                overflow: TextOverflow.clip,
              ),
            );
          },
        ),
      ),
    );
  }
}
