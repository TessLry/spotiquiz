import 'package:flutter/material.dart';

class SelectNbQuestion extends StatefulWidget {
  final ValueChanged<int> onToggle;

  const SelectNbQuestion({super.key, required this.onToggle});

  @override
  State<SelectNbQuestion> createState() => _SelectNbQuestionState();
}

class _SelectNbQuestionState extends State<SelectNbQuestion> {
  List<int> list = [5, 10, 15, 20, 30, 40, 50];
  int dropdownValue = 5;

  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Nombre de questions :'),
        const SizedBox(width: 10),
        DropdownMenu<int>(
          initialSelection: list.first,
          onSelected: (int? value) {
            setState(() {
              dropdownValue = value!;
              widget.onToggle(dropdownValue);
            });
          },
          dropdownMenuEntries: list.map<DropdownMenuEntry<int>>((int value) {
            return DropdownMenuEntry<int>(
                value: value, label: value.toString());
          }).toList(),
        ),
      ],
    );
  }
}
