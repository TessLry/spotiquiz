import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/score_cubit.dart';
import 'package:spotiquiz/models/score.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScoreCubit, List<Score>>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state[index].score.toString()),
                subtitle: Text(state[index].date.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
