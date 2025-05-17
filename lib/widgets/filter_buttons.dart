import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterButtons extends StatefulWidget {
  const FilterButtons({super.key});

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
  // _FilterButtonsState createState() => _FilterButtonsState();
}

Widget _buttonText(String text) {
  return Text(
    text,
    style: const TextStyle(
      //color: MyColors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

class _FilterButtonsState extends State<FilterButtons> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<bool> selected = [false, false, false];
    selected[selectedIndex] = true;

    return Center(
        child: ToggleButtons(
      //mouseCursor: SystemMouseCursors.click,
      selectedColor: MyColors.grey,
      color: MyColors.black,
      fillColor: MyColors.white,
      isSelected: selected,
      children: [
        _buttonText('All'),
        _buttonText('Moving'),
        _buttonText('Parked'),
      ],
      onPressed: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
    ));
  }
}
