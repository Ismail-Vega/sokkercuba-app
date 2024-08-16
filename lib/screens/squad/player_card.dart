import 'package:flutter/material.dart';

import '../../models/player/player.dart';
import '../../themes/custom_extension.dart';
import '../../utils/constants.dart';
import '../../utils/format_numbers.dart';
import '../../utils/skills_checker.dart';

class PlayerCard extends StatelessWidget {
  final TeamPlayer player;

  const PlayerCard({super.key, required this.player});

  Widget renderCard(int yellow, int red, double iconSize) {
    if (red > 0) {
      return Icon(
        Icons.rectangle,
        color: Colors.red,
        size: iconSize,
      );
    }
    if (yellow == 1) {
      return Icon(
        Icons.looks_one,
        color: const Color(0xFFFFEB3B),
        size: iconSize,
      );
    }
    if (yellow == 2) {
      return Icon(
        Icons.looks_two,
        color: const Color(0xFFFFEB3B),
        size: iconSize,
      );
    }
    return Text(
      "0",
      style: TextStyle(fontSize: iconSize),
    );
  }

  Widget renderInjury(int days, double textSize, double iconSize) {
    if (days == 0) {
      return Text('None', style: TextStyle(fontSize: textSize));
    }

    return Row(
      children: [
        Icon(Icons.local_hospital, color: Colors.red, size: iconSize),
        Text('($days)', style: TextStyle(fontSize: textSize)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>()!;
    final Color skillThemeColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: customTheme.mediumFontSize,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    'Age: ${player.info.characteristics.age}',
                    style: TextStyle(fontSize: customTheme.smallFontSize),
                  ),
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
                    _buildInfoTable(skillThemeColor, customTheme),
                    const SizedBox(height: 4),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 4),
                    _buildSkillsTable(skillThemeColor, customTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(
      Color textSpanColor, CustomThemeExtension customTheme) {
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
            '${formatNumber(player.info.value?.value)} ${(player.info.value?.currency)}',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          'Wage',
          Text(
            '${formatNumber(player.info.wage?.value)} ${player.info.wage?.currency}',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'Tact disc',
          Text(
            '${skillsLevelsList[player.info.skills.tacticalDiscipline]} [${player.info.skills.tacticalDiscipline}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          'Form',
          Text(
            '${skillsLevelsList[player.info.skills.form]} [${player.info.skills.form}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'Height',
          Text('${player.info.characteristics.height} cm',
              style: TextStyle(fontSize: customTheme.smallFontSize)),
          'Weight',
          Text('${player.info.characteristics.weight.toStringAsFixed(1)} kg',
              style: TextStyle(fontSize: customTheme.smallFontSize)),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'BMI',
          Text(player.info.characteristics.bmi.toStringAsFixed(2),
              style: TextStyle(fontSize: customTheme.smallFontSize)),
          'Cards',
          renderCard(player.info.stats.cards.yellow,
              player.info.stats.cards.red, customTheme.smallFontSize),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'NT cards',
          renderCard(player.info.nationalStats.cards.yellow,
              player.info.nationalStats.cards.red, customTheme.smallFontSize),
          'Injury',
          renderInjury(player.info.injury.daysRemaining,
              customTheme.smallFontSize, customTheme.smallFontSize),
          textSpanColor,
          customTheme,
        ),
      ],
    );
  }

  Widget styledTextWidget(
      {required Widget child,
      required Color defaultColor,
      required double fontSize,
      Color? color}) {
    return DefaultTextStyle(
      style: TextStyle(
          color: color ?? defaultColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize),
      child: child,
    );
  }

  Widget _buildSkillsTable(
      Color textSpanColor, CustomThemeExtension customTheme) {
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
            '${skillsLevelsList[player.info.skills.stamina]} [${player.info.skills.stamina}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          'keeper',
          Text(
            '${skillsLevelsList[player.info.skills.keeper]} [${player.info.skills.keeper}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'pace',
          Text(
            '${skillsLevelsList[player.info.skills.pace]} [${player.info.skills.pace}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          'defending',
          Text(
            '${skillsLevelsList[player.info.skills.defending]} [${player.info.skills.defending}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'technique',
          Text(
            '${skillsLevelsList[player.info.skills.technique]} [${player.info.skills.technique}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          'playmaking',
          Text(
            '${skillsLevelsList[player.info.skills.playmaking]} [${player.info.skills.playmaking}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          textSpanColor,
          customTheme,
        ),
        _buildTableRow(
          'passing',
          Text(
            '${skillsLevelsList[player.info.skills.passing]} [${player.info.skills.passing}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          'striker',
          Text(
            '${skillsLevelsList[player.info.skills.striker]} [${player.info.skills.striker}]',
            style: TextStyle(fontSize: customTheme.smallFontSize),
          ),
          textSpanColor,
          customTheme,
        ),
      ],
    );
  }

  String parseSkill2(String skill) {
    if (skill == 'defending') return 'defender';
    if (skill == 'playmaking') return 'playmaker';

    return skill;
  }

  TableRow _buildTableRow(String skill1, Widget value1, String skill2,
      Widget value2, Color skillThemeColor, CustomThemeExtension customTheme) {
    return TableRow(
      children: [
        _buildSkillCell(
          skill1,
          styledTextWidget(
            child: value1,
            color: getSkillChangeColor(player.info, skill1),
            fontSize: customTheme.smallFontSize,
            defaultColor: skillThemeColor,
          ),
        ),
        const TableCell(
          child: Padding(padding: EdgeInsets.all(4.0), child: Text("")),
        ),
        _buildSkillCell(
          parseSkill2(skill2),
          styledTextWidget(
            child: value2,
            color: getSkillChangeColor(player.info, skill2),
            fontSize: customTheme.smallFontSize,
            defaultColor: skillThemeColor,
          ),
        ),
      ],
    );
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
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
            value,
          ],
        ),
      ),
    );
  }
}
