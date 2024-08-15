import 'package:flutter/material.dart';

import '../../models/player/player.dart';
import '../../utils/constants.dart';
import '../../utils/format_numbers.dart';
import '../../utils/skills_checker.dart';

class PlayerCard extends StatelessWidget {
  final TeamPlayer player;

  const PlayerCard({super.key, required this.player});

  Widget renderCard(int yellow, int red) {
    if (red > 0) {
      return const Icon(
        Icons.rectangle,
        color: Colors.red,
        size: 16,
      );
    }
    if (yellow == 1) {
      return const Icon(
        Icons.looks_one,
        color: Color(0xFFFFEB3B),
        size: 16,
      );
    }
    if (yellow == 2) {
      return const Icon(
        Icons.looks_two,
        color: Color(0xFFFFEB3B),
        size: 16,
      );
    }
    return const Text("0");
  }

  Widget renderInjure(int days) {
    if (days == 0) {
      return const Text('None');
    }

    return Row(children: [
      const Icon(
        Icons.local_hospital,
        color: Colors.red,
        size: 16,
      ),
      Text('($days)')
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color skillThemeColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.blue[900],
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      player.info.name.full,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text('Age: ${player.info.characteristics.age}'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0, left: 8, right: 8),
              child: Divider(thickness: 1, color: Colors.grey),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    _buildInfoTable(skillThemeColor),
                    const SizedBox(height: 4),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 4),
                    _buildSkillsTable(skillThemeColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(Color textSpanColor) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(0.5),
        2: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildTableRow(
            'Value',
            Text(
                '${formatNumber(player.info.value?.value)} ${(player.info.value?.currency)}'),
            'Wage',
            Text(
                '${formatNumber(player.info.wage?.value)} ${player.info.wage?.currency}'),
            textSpanColor),
        _buildTableRow(
            'Tact disc',
            Text(
                '${skillsLevelsList[player.info.skills.tacticalDiscipline]} [${player.info.skills.tacticalDiscipline}]'),
            'Form',
            Text(
                '${skillsLevelsList[player.info.skills.form]} [${player.info.skills.form}]'),
            textSpanColor),
        _buildTableRow(
            'Height',
            Text('${player.info.characteristics.height} cm'),
            'Weight',
            Text('${player.info.characteristics.weight.toStringAsFixed(1)} kg'),
            textSpanColor),
        _buildTableRow(
            'BMI',
            Text(player.info.characteristics.bmi.toStringAsFixed(2)),
            'Cards',
            renderCard(
                player.info.stats.cards.yellow, player.info.stats.cards.red),
            textSpanColor),
        _buildTableRow(
            'NT cards',
            renderCard(player.info.nationalStats.cards.yellow,
                player.info.nationalStats.cards.red),
            'Injury',
            renderInjure(player.info.injury.daysRemaining),
            textSpanColor),
      ],
    );
  }

  Widget styledTextWidget(
      {required Widget child, required Color defaultColor, Color? color}) {
    return DefaultTextStyle(
      style:
          TextStyle(color: color ?? defaultColor, fontWeight: FontWeight.bold),
      child: child,
    );
  }

  Widget _buildSkillsTable(Color textSpanColor) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(0.5),
        2: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildTableRow(
            'stamina',
            Text(
                '${skillsLevelsList[player.info.skills.stamina]} [${player.info.skills.stamina}]'),
            'keeper',
            Text(
                '${skillsLevelsList[player.info.skills.keeper]} [${player.info.skills.keeper}]'),
            textSpanColor),
        _buildTableRow(
            'pace',
            Text(
                '${skillsLevelsList[player.info.skills.pace]} [${player.info.skills.pace}]'),
            'defending',
            Text(
                '${skillsLevelsList[player.info.skills.defending]} [${player.info.skills.defending}]'),
            textSpanColor),
        _buildTableRow(
            'technique',
            Text(
                '${skillsLevelsList[player.info.skills.technique]} [${player.info.skills.technique}]'),
            'playmaking',
            Text(
                '${skillsLevelsList[player.info.skills.playmaking]} [${player.info.skills.playmaking}]'),
            textSpanColor),
        _buildTableRow(
            'passing',
            Text(
                '${skillsLevelsList[player.info.skills.passing]} [${player.info.skills.passing}]'),
            'striker',
            Text(
                '${skillsLevelsList[player.info.skills.striker]} [${player.info.skills.striker}]'),
            textSpanColor),
      ],
    );
  }

  String parseSkill2(String skill) {
    if (skill == 'defending') return 'defender';
    if (skill == 'playmaking') return 'playmaker';

    return skill;
  }

  TableRow _buildTableRow(String skill1, Widget value1, String skill2,
      Widget value2, Color skillThemeColor) {
    return TableRow(children: [
      _buildSkillCell(
          skill1,
          styledTextWidget(
              child: value1,
              color: getSkillChangeColor(player.info, skill1),
              defaultColor: skillThemeColor)),
      const TableCell(
          child: Padding(padding: EdgeInsets.all(4.0), child: Text(""))),
      _buildSkillCell(
          parseSkill2(skill2),
          styledTextWidget(
              child: value2,
              color: getSkillChangeColor(player.info, skill2),
              defaultColor: skillThemeColor)),
    ]);
  }

  Widget _buildSkillCell(String skill, Widget value) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                skill,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            value,
          ],
        ),
      ),
    );
  }
}
