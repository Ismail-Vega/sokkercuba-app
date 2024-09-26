import 'package:flutter/material.dart';

import '../../constants/squad.dart';

class SortDropdown extends StatelessWidget {
  final SortCriteria selectedCriteria;
  final ValueChanged<SortCriteria?> onCriteriaChanged;

  const SortDropdown({
    super.key,
    required this.selectedCriteria,
    required this.onCriteriaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SortCriteria>(
      isDense: true,
      value: selectedCriteria,
      onChanged: onCriteriaChanged,
      dropdownColor: Colors.blue[900],
      focusColor: Colors.transparent,
      style: const TextStyle(
        fontSize: 10,
        height: 1.0,
      ),
      items: const [
        DropdownMenuItem(
          value: SortCriteria.hasSkillChanges,
          child: Text('Has Skill Changes'),
        ),
        DropdownMenuItem(
          value: SortCriteria.name,
          child: Text('Name'),
        ),
        DropdownMenuItem(
          value: SortCriteria.age,
          child: Text('Age'),
        ),
        DropdownMenuItem(
          value: SortCriteria.stamina,
          child: Text('Stamina'),
        ),
        DropdownMenuItem(
          value: SortCriteria.pace,
          child: Text('Pace'),
        ),
        DropdownMenuItem(
          value: SortCriteria.technique,
          child: Text('Technique'),
        ),
        DropdownMenuItem(
          value: SortCriteria.passing,
          child: Text('Passing'),
        ),
        DropdownMenuItem(
          value: SortCriteria.keeper,
          child: Text('Keeper'),
        ),
        DropdownMenuItem(
          value: SortCriteria.defending,
          child: Text('Defending'),
        ),
        DropdownMenuItem(
          value: SortCriteria.playmaking,
          child: Text('Playmaking'),
        ),
        DropdownMenuItem(
          value: SortCriteria.striker,
          child: Text('Striker'),
        ),
      ],
    );
  }
}
