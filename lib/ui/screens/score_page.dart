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
    List<Score> scores = BlocProvider.of<ScoreCubit>(context).state;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Podium(top3: triDecroissant(scores).take(3).toList()),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.primary, width: 2.0),
                  left: BorderSide(color: AppColors.primary, width: 2.0),
                  right: BorderSide(color: AppColors.primary, width: 2.0),
                  bottom: BorderSide(color: AppColors.primary, width: 0.0),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
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
                        itemCount: scores.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: scores[index].image == null
                                ? const Icon(Icons.album, size: 50)
                                : Image.network(scores[index].image!,
                                    fit: BoxFit.cover, width: 50, height: 50),
                            title: Text("${scores[index].score} points"),
                            titleTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            subtitle: Text(
                                "${scores[index].name}\n${formatDate(scores[index].date)}"),
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
      ),
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
