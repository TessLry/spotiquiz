import 'package:flutter/material.dart';

class SelectNbQuestion extends StatefulWidget {
  const SelectNbQuestion({super.key});

  @override
  State<SelectNbQuestion> createState() => _SelectNbQuestionState();
}

class _SelectNbQuestionState extends State<SelectNbQuestion> {
  List<String> list = ["5", "10", "15", "20", "50", "100"];
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Sélectionner le nombre de questions :'),
        const SizedBox(width: 10),
        DropdownMenu<String>(
          initialSelection: list.first,
          onSelected: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          dropdownMenuEntries:
              list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ],
    );
  }
}
