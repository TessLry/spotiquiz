import 'package:flutter/material.dart';
import 'package:spotiquiz/models/score.dart';
import 'package:spotiquiz/ui/widgets/game/scrollable_text.dart';
import 'package:spotiquiz/utils/colors.dart';

class Podium extends StatelessWidget {
  final List<Score> top3;
  const Podium({super.key, required this.top3});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PodiumItem(
              height: 140, nb: "2", score: top3.length > 1 ? top3[1] : null),
          PodiumItem(height: 210, nb: "1", score: top3[0]),
          PodiumItem(
              height: 100, nb: "3", score: top3.length > 2 ? top3[2] : null),
        ],
      ),
      Positioned(
        bottom: 0,
        left: MediaQuery.of(context).size.width * 0.4 - 10,
        child: PodiumItem(height: 210, nb: "1", score: top3[0]),
      )
    ]);
  }
}

class PodiumItem extends StatelessWidget {
  final double height;
  final String nb;
  final Score? score;
  const PodiumItem(
      {super.key, required this.height, required this.nb, this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        score != null
            ? Image.network(score?.image ?? "", width: 50, height: 50)
            : Container(),
        const SizedBox(height: 10),
        Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  score != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${score?.score} pts \n ",
                              style: const TextStyle(fontSize: 15, height: 0.5),
                            ),
                            ScrollableText(
                                text: score?.name ?? "0pts",
                                lenghtOverflow: 13,
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        )
                      : Container(),
                ],
              ),
            )),
      ],
    );
  }
}
