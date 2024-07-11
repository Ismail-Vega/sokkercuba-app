import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/squad/squad.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/constants.dart';
import '../../utils/format_numbers.dart';
import '../../utils/get_player_report.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textSpanColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final cweek = Provider.of<AppStateNotifier>(context).state.cweek;
    final players = cweek?.players;
    final report = getPlayerTrainingReportById(players, player.id);

    return Card(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 8, right: 8),
              child: _buildDivider(),
            ),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      _buildSkillCell('Value:',
                          '${formatNumber(player.info.value.value)} ${player.info.value.currency}'),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('Wage:',
                          '${formatNumber(player.info.wage.value)} ${player.info.wage.currency}'),
                    ]),
                    TableRow(children: [
                      _buildSkillCell('Tact disc:',
                          '${skillsLevelsList[player.info.skills.tacticalDiscipline]} [${player.info.skills.tacticalDiscipline}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.tacticalDiscipline)),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('Form:',
                          '${skillsLevelsList[player.info.skills.form]} [${player.info.skills.form}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.form)),
                    ]),
                    TableRow(children: [
                      _buildSkillCell('Height:',
                          '${player.info.characteristics.height} cm'),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('Weight:',
                          '${player.info.characteristics.weight.toStringAsFixed(1)} kg'),
                    ]),
                    TableRow(
                      children: [
                        _buildSkillCell('BMI:',
                            player.info.characteristics.bmi.toStringAsFixed(2)),
                        const TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "",
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Cards:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textSpanColor)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: renderCard(
                                      player.info.stats.cards.yellow,
                                      player.info.stats.cards.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('NT cards:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textSpanColor)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: renderCard(
                                      player.info.nationalStats.cards.yellow,
                                      player.info.nationalStats.cards.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "",
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Injury:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textSpanColor)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: player.info.injury.daysRemaining > 0
                                        ? Row(
                                            children: [
                                              const Icon(
                                                Icons.local_hospital_sharp,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                              Text(
                                                  '(${player.info.injury.daysRemaining} days)'),
                                            ],
                                          )
                                        : const Text('none'),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildDivider(),
                const SizedBox(height: 4),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      _buildSkillCell('stamina:',
                          '${skillsLevelsList[player.info.skills.stamina]} [${player.info.skills.stamina}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.stamina)),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('keeper:',
                          '${skillsLevelsList[player.info.skills.keeper]} [${player.info.skills.keeper}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.keeper)),
                    ]),
                    TableRow(children: [
                      _buildSkillCell('pace:',
                          '${skillsLevelsList[player.info.skills.pace]} [${player.info.skills.pace}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.pace)),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('defender:',
                          '${skillsLevelsList[player.info.skills.defending]} [${player.info.skills.defending}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.defending)),
                    ]),
                    TableRow(children: [
                      _buildSkillCell('technique:',
                          '${skillsLevelsList[player.info.skills.technique]} [${player.info.skills.technique}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.technique)),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('playmaker:',
                          '${skillsLevelsList[player.info.skills.playmaking]} [${player.info.skills.playmaking}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.playmaking)),
                    ]),
                    TableRow(children: [
                      _buildSkillCell('passing:',
                          '${skillsLevelsList[player.info.skills.passing]} [${player.info.skills.passing}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.passing)),
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "",
                          ),
                        ),
                      ),
                      _buildSkillCell('striker:',
                          '${skillsLevelsList[player.info.skills.striker]} [${player.info.skills.striker}]',
                          color: getSkillChangeColor(
                              report?.report.skillsChange.striker)),
                    ]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() => const Divider(thickness: 1, color: Colors.grey);

  TableCell _buildSkillCell(String skill, String value, {Color? color}) {
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
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
