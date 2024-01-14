import 'package:flutter/material.dart';
import 'package:spotiquiz/utils/colors.dart';

class Podium extends StatelessWidget {
  const Podium({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PodiumItem(height: 140, nb: "2"),
          PodiumItem(height: 210, nb: "1"),
          PodiumItem(height: 100, nb: "3"),
        ],
      ),
      Positioned(
        bottom: 0,
        left: MediaQuery.of(context).size.width * 0.4 - 10,
        child: PodiumItem(height: 210, nb: "1"),
      )
    ]);
  }
}

class PodiumItem extends StatelessWidget {
  final double height;
  final String nb;
  const PodiumItem({super.key, required this.height, required this.nb});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: height,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: nb == "1"
                ? [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ]
                : null),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                nb,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Score",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}
