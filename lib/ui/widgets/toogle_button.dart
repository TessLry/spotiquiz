import 'package:flutter/material.dart';
import 'package:spotiquiz/utils/colors.dart';

class ToogleButton extends StatefulWidget {
  final ValueChanged<String> onToggle;

  const ToogleButton({super.key, required this.onToggle});

  @override
  State<ToogleButton> createState() => _ToogleButtonState();
}

class _ToogleButtonState extends State<ToogleButton> {
  List<bool> _selectedSearch = <bool>[true, false];
  static const List<Widget> icons = <Widget>[
    Icon(Icons.person),
    Icon(Icons.album),
  ];
  String _selected = 'artist';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Artiste',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        const SizedBox(width: 10),
        ToggleButtons(
          isSelected: _selectedSearch,
          onPressed: (int index) {
            setState(() {
              _selectedSearch = List<bool>.generate(
                icons.length,
                (int i) => i == index,
              );
              _selected = _selectedSearch[0] ? 'artist' : 'album';
              widget.onToggle(_selected);
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedColor: AppColors.primary,
          children: icons,
        ),
        const SizedBox(width: 10),
        const Text('Album',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ],
    );
  }
}
