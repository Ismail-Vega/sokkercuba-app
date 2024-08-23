import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../mixins/skills_mixin.dart';
import '../../models/player/player.dart';
import '../../models/player/player_info.dart';
import '../../state/app_state_notifier.dart';
import '../../themes/custom_extension.dart';
import '../../utils/constants.dart';
import '../../utils/format.dart';
import '../../utils/get_training_data.dart';
import '../../utils/skills_checker.dart';

class PlayerCard extends StatefulWidget {
  final TeamPlayer player;

  const PlayerCard({super.key, required this.player});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  int? selectedWeek;
  PlayerInfo? selectedPlayerInfo;

  @override
  void initState() {
    super.initState();
    selectedPlayerInfo = widget.player.info;
  }

  void _onWeekSelected(int? week) {
    setState(() {
      selectedWeek = week;

      if (week != null && widget.player.skillsHistory != null) {
        selectedPlayerInfo =
            widget.player.skillsHistory![week]?.info ?? widget.player.info;
      } else {
        selectedPlayerInfo = widget.player.info;
      }
    });
  }

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
    final mediumPadding = customTheme.mediumPadding;
    final state = Provider.of<AppStateNotifier>(context).state;
    final trainingWeek = state.trainingWeek;
    final players = state.training?.players;
    final noSelection = selectedWeek == null || selectedWeek == trainingWeek;
    final report = noSelection
        ? getPlayerTrainingReport(players, widget.player.id, trainingWeek)
        : null;
    final skillsHistory = widget.player.skillsHistory;
    final prevState =
        trainingWeek != null && skillsHistory != null && noSelection
            ? skillsHistory[trainingWeek - 1]?.info
            : null;
    final player = selectedPlayerInfo ?? widget.player.info;

    return Card(
      color: Colors.blue[900],
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(mediumPadding, 0, mediumPadding, 0),
              child: Row(
                children: [
                  Text(
                    player.name.full,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: customTheme.mediumFontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Age: ${player.characteristics.age}',
                      style: TextStyle(fontSize: customTheme.smallFontSize),
                    ),
                  ),
                  if (widget.player.skillsHistory != null &&
                      widget.player.skillsHistory!.isNotEmpty)
                    DropdownButton<int>(
                        value: selectedWeek,
                        dropdownColor: Colors.blue[900],
                        hint: const Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Show History",
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.0,
                            ),
                          ),
                        ),
                        items: widget.player.skillsHistory!.keys
                            .toList()
                            .reversed
                            .map((week) {
                          final date = widget.player.skillsHistory![week]?.date;

                          return DropdownMenuItem<int>(
                            value: week,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                "Week: $week (${formatDateTime(date, isShort: true)})",
                                style: const TextStyle(
                                  fontSize: 10,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: _onWeekSelected,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.0,
                        ),
                        isDense: true,
                        underline: const SizedBox(),
                        focusColor: Colors.transparent),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Divider(thickness: 1, color: Colors.grey),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: mediumPadding, vertical: 0),
                child: Column(
                  children: [
                    _buildInfoTable(report, prevState, player, skillThemeColor,
                        customTheme),
                    const Divider(thickness: 1, color: Colors.grey),
                    _buildSkillsTable(
                        report, player, skillThemeColor, customTheme),
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
      SkillMethods? report,
      PlayerInfo? prevState,
      PlayerInfo player,
      Color textSpanColor,
      CustomThemeExtension customTheme) {
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
            styledTextWidget(
              child: Text(
                '${formatNumber(player.value?.value)} ${(player.value?.currency)}',
                style: TextStyle(fontSize: customTheme.smallFontSize),
              ),
              color: getValueChangeColor(prevState, player),
              fontSize: customTheme.smallFontSize,
              defaultColor: textSpanColor,
            ),
            'Wage',
            styledTextWidget(
              child: Text(
                '${formatNumber(player.wage?.value)} ${player.wage?.currency}',
                style: TextStyle(fontSize: customTheme.smallFontSize),
              ),
              fontSize: customTheme.smallFontSize,
              defaultColor: textSpanColor,
            ),
            customTheme),
        _buildTableRow(
          'Tact disc',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.tacticalDiscipline]} [${player.skills.tacticalDiscipline}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color: report != null
                ? getSkillChangeColor(report, 'tacticalDiscipline')
                : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'Form',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.form]} [${player.skills.form}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color: report != null ? getSkillChangeColor(report, 'form') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          customTheme,
        ),
        _buildTableRow(
          'Team work',
          styledTextWidget(
            child: Text(
                '${skillsLevelsList[player.skills.teamwork]} [${player.skills.teamwork}]',
                style: TextStyle(fontSize: customTheme.smallFontSize)),
            color:
                report != null ? getSkillChangeColor(report, 'teamwork') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'Exp',
          styledTextWidget(
            child: Text(
                '${skillsLevelsList[player.skills.experience]} [${player.skills.experience}]',
                style: TextStyle(fontSize: customTheme.smallFontSize)),
            color: report != null
                ? getSkillChangeColor(report, 'experience')
                : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          customTheme,
        ),
        _buildTableRow(
          'BMI',
          styledTextWidget(
            child: Text(player.characteristics.bmi.toStringAsFixed(2),
                style: TextStyle(fontSize: customTheme.smallFontSize)),
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'Cards',
          styledTextWidget(
            child: renderCard(player.stats.cards.yellow, player.stats.cards.red,
                customTheme.smallFontSize),
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          customTheme,
        ),
        _buildTableRow(
          'NT cards',
          styledTextWidget(
            child: renderCard(player.nationalStats.cards.yellow,
                player.nationalStats.cards.red, customTheme.smallFontSize),
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'Injury',
          styledTextWidget(
            child: renderInjury(player.injury.daysRemaining,
                customTheme.smallFontSize, customTheme.smallFontSize),
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
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

  Widget _buildSkillsTable(SkillMethods? report, PlayerInfo player,
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
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.stamina]} [${player.skills.stamina}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color:
                report != null ? getSkillChangeColor(report, 'stamina') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'keeper',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.keeper]} [${player.skills.keeper}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color:
                report != null ? getSkillChangeColor(report, 'keeper') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          customTheme,
        ),
        _buildTableRow(
          'pace',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.pace]} [${player.skills.pace}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color: report != null ? getSkillChangeColor(report, 'pace') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'defending',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.defending]} [${player.skills.defending}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color: report != null
                ? getSkillChangeColor(report, 'defending')
                : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          customTheme,
        ),
        _buildTableRow(
          'technique',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.technique]} [${player.skills.technique}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color: report != null
                ? getSkillChangeColor(report, 'technique')
                : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'playmaking',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.playmaking]} [${player.skills.playmaking}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color: report != null
                ? getSkillChangeColor(report, 'playmaking')
                : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          customTheme,
        ),
        _buildTableRow(
          'passing',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.passing]} [${player.skills.passing}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color:
                report != null ? getSkillChangeColor(report, 'passing') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
          'striker',
          styledTextWidget(
            child: Text(
              '${skillsLevelsList[player.skills.striker]} [${player.skills.striker}]',
              style: TextStyle(fontSize: customTheme.smallFontSize),
            ),
            color:
                report != null ? getSkillChangeColor(report, 'striker') : null,
            fontSize: customTheme.smallFontSize,
            defaultColor: textSpanColor,
          ),
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
      Widget value2, CustomThemeExtension customTheme) {
    return TableRow(
      children: [
        _buildSkillCell(skill1, value1, customTheme.smallFontSize,
            customTheme.smallPadding),
        const TableCell(
          child: Padding(padding: EdgeInsets.all(4.0), child: Text("")),
        ),
        _buildSkillCell(parseSkill2(skill2), value2, customTheme.smallFontSize,
            customTheme.smallPadding),
      ],
    );
  }

  Widget _buildSkillCell(
      String skill, Widget value, double fontSize, double padding) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                skill,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis, fontSize: fontSize),
              ),
            ),
            value,
          ],
        ),
      ),
    );
  }
}
