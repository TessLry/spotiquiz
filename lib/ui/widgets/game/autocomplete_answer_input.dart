import 'package:flutter/material.dart';
import 'package:spotiquiz/models/track.dart';
import 'package:spotiquiz/utils/colors.dart';

class AutocompleteAnswerInput extends StatefulWidget {
  final TextEditingController textFieldController;
  final List<Track> trackList;
  final Function(String) handleSubmit;

  const AutocompleteAnswerInput(
      {super.key,
      required this.textFieldController,
      required this.trackList,
      required this.handleSubmit});

  @override
  State<AutocompleteAnswerInput> createState() =>
      _AutocompleteAnswerInputState();
}

class _AutocompleteAnswerInputState extends State<AutocompleteAnswerInput> {
  List<Track> _autoCompleteTracks = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 0, left: 40, right: 40),
          child: TextField(
            cursorColor: AppColors.primary,
            controller: widget.textFieldController,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                ),
                fillColor: AppColors.primary,
                prefixIcon: Icon(Icons.music_note),
                prefixIconColor: AppColors.primary,
                labelText: 'Réponse',
                labelStyle: TextStyle(color: AppColors.primary)),
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  _autoCompleteTracks = [];
                  return;
                }
                _autoCompleteTracks = widget.trackList
                    .where((track) =>
                        track.name.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: _autoCompleteTracks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_autoCompleteTracks[index].name),
                    onTap: () {
                      //TODO handleSubmit renvoie un booleen et faire affichage rouge animation si faux !
                      widget.handleSubmit(_autoCompleteTracks[index].name);
                      widget.textFieldController.clear();
                      setState(() {
                        _autoCompleteTracks = [];
                      });
                    },
                  );
                }))
      ],
    );
  }
}
