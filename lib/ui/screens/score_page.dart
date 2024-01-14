import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/score_cubit.dart';
import 'package:spotiquiz/models/score.dart';
import 'package:spotiquiz/ui/widgets/podium.dart';
import 'package:spotiquiz/utils/colors.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  static List list = [
    {"score": 1300, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 1200, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 1100, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 1000, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 900, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 800, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 700, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 600, "date": "2021-09-01 12:00:00", "nom": "Pnl"},
    {"score": 500, "date": "2021-09-01 12:00:00", "nom": "Pnl"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: BlocBuilder<ScoreCubit, List<Score>>(
      //   builder: (context, state) {
      //     return ListView.builder(
      //       itemCount: state.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           title: Text(state[index].score.toString()),
      //           subtitle: Text(state[index].date.toString()),
      //         );
      //       },
      //     );
      //   },
      // ),
      body: Column(
        children: [
          const Expanded(
            flex: 4,
            child: Podium(),
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "SCORES",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(list[index]["score"].toString()),
                            subtitle: Text(
                                "${list[index]["date"]} ${list[index]["nom"]}"),
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
