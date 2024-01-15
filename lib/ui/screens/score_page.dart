import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/score_cubit.dart';
import 'package:spotiquiz/models/score.dart';
import 'package:spotiquiz/ui/widgets/podium.dart';
import 'package:spotiquiz/utils/colors.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Score> scores =
        triDecroissant(BlocProvider.of<ScoreCubit>(context).state);

    if (scores.isEmpty) {
      return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Vous n'avez pas encore de score",
              style: TextStyle(
                fontSize: 16.0,
              ),
            )),
            SizedBox(height: 20),
            Center(child: Text("Jouez pour en avoir !"))
          ]);
    }

    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Podium(top3: scores.take(3).toList()),
        ),
        Expanded(
          flex: 6,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "SCORES",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: scores.length - 3 > 0 ? scores.length - 3 : 0,
                      itemBuilder: (context, index) {
                        final actualIndex = index + 3;
                        return ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${actualIndex + 1}",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                            ],
                          ),
                          trailing: scores[actualIndex].image == null
                              ? const Icon(Icons.album, size: 50)
                              : Image.network(scores[actualIndex].image!,
                                  fit: BoxFit.cover, width: 50, height: 50),
                          title: Text("${scores[actualIndex].score} points"),
                          titleTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          subtitle: Text(
                              "${scores[actualIndex].name}\n${formatDate(scores[actualIndex].date)}"),
                          isThreeLine: true,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

List<Score> triDecroissant(List<Score> scores) {
  scores.sort((a, b) => b.score.compareTo(a.score));
  return scores;
}
