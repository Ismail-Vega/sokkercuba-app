import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/growth_content.dart';
import '../../components/table_legend.dart';
import '../../models/player/player.dart';
import '../../models/player/player_info.dart';
import '../../models/training/training.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/calculate_skill_growth.dart';
import '../../utils/skills_checker.dart';
import '../../utils/table_utils.dart';

class Training extends StatefulWidget {
  static const String id = 'training_screen';

  const Training({super.key});

  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  TeamPlayer? selectedPlayer;
  List<TeamPlayer> players = [];
  List<PlayerTrainingReport> trainingReports = [];

  int currentPage = 0;
  int rowsPerPage = 10;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      final appStateNotifier =
          Provider.of<AppStateNotifier>(context, listen: false);
      final squad = appStateNotifier.state.players?.players;
      final training = appStateNotifier.state.training?.players;

      if (squad != null && training != null) {
        trainingReports = training;
        players = squad;
      }
    }
  }

  List<TableRow> generateRows(int playerIndex) {
    String lastDisplayedAge = "";
    final filteredReport = getSelectedPlayerReport();
    final skillsHistory =
        playerIndex > -1 ? players[playerIndex].skillsHistory : null;

    return selectedPlayer != null
        ? filteredReport.report.map((report) {
            final kind =
                report.kind.name == 'missing' && report.injury.daysRemaining > 0
                    ? 'injured'
                    : report.kind.name;
            final games =
                '${report.games.minutesOfficial}/${report.games.minutesFriendly}/${report.games.minutesNational}';

            final age = skillsHistory != null
                ? skillsHistory[report.week]
                        ?.info
                        ?.characteristics
                        .age
                        .toString() ??
                    'N/A'
                : 'N/A';

            TableRow row = TableRow(
              decoration: BoxDecoration(
                border: lastDisplayedAge != 'N/A' && lastDisplayedAge != age
                    ? const Border(top: BorderSide(color: Colors.lightBlue))
                    : null,
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text(age)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text(report.week.toString())),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'stamina'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child:
                          Center(child: Text(report.skills.stamina.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'pace'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(child: Text(report.skills.pace.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'technique'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                          child: Text(report.skills.technique.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'passing'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child:
                          Center(child: Text(report.skills.passing.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'keeper'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child:
                          Center(child: Text(report.skills.keeper.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'defending'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                          child: Text(report.skills.defending.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'playmaking'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                          child: Text(report.skills.playmaking.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getSkillChangeColor(report, 'striker'),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child:
                          Center(child: Text(report.skills.striker.toString())),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                        child: Text(
                            report.type.name.substring(0, 3).toUpperCase())),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text(report.formation?.name ?? 'NA')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      getIconForKind(kind),
                      color: getColorForKind(kind),
                      size: 12,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text(games)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text(report.intensity.toString())),
                  ),
                ),
              ],
            );
            lastDisplayedAge = age;
            return row;
          }).toList()
        : [
            const TableRow(
              children: [TableCell(child: Text(''))],
            )
          ];
  }

  void handlePlayerChange(dynamic player) {
    setState(() {
      selectedPlayer = player;
    });
  }

  void handleChangePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  void handleChangeRowsPerPage(int newRowsPerPage) {
    setState(() {
      rowsPerPage = newRowsPerPage;
      currentPage = 0;
    });
  }

  PlayerTrainingReport getSelectedPlayerReport() {
    return trainingReports.firstWhere(
        (player) => player.id == selectedPlayer?.id,
        orElse: () => PlayerTrainingReport(
              id: 0,
              player: PlayerInfo.fromJson({}),
              report: [],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final playerDropdownItems = players.map((player) {
      return DropdownMenuItem<TeamPlayer>(
        value: player,
        child: Text(player.info.name.full),
      );
    }).toList();
    final double screenHeight = MediaQuery.of(context).size.height;
    final playerIndex = players.indexWhere(
      (player) => player.id == selectedPlayer?.id,
    );

    return Scaffold(
        backgroundColor: Colors.blue,
        body: LayoutBuilder(builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 764;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? 764 : double.infinity,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        DropdownButton<dynamic>(
                            focusColor: Colors.blue,
                            menuMaxHeight: screenHeight / 1.5,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            dropdownColor: Colors.blue[900],
                            hint: const Text('Select Player'),
                            value:
                                playerIndex > -1 ? players[playerIndex] : null,
                            onChanged: handlePlayerChange,
                            items: playerDropdownItems,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (selectedPlayer != null &&
                      selectedPlayer!.info.characteristics.age < 25)
                    GrowthDisplay(
                        growth: calculateSkillGrowth(
                            getSelectedPlayerReport().report)),
                  const SizedBox(height: 8),
                  if (selectedPlayer != null)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          color: Colors.blue[900],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Table(
                                    defaultColumnWidth:
                                        const IntrinsicColumnWidth(),
                                    children: [
                                      const TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Age',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Week',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Sta.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Pac.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Tec.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Pas.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Kp.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Def.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Plm.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Str.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Type',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Pos.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Kind',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Games',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text('Eff.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      ...generateRows(playerIndex)
                                          .skip(currentPage * rowsPerPage)
                                          .take(rowsPerPage),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.chevron_left),
                                      onPressed: currentPage > 0
                                          ? () =>
                                              handleChangePage(currentPage - 1)
                                          : null,
                                    ),
                                    Text('${currentPage + 1}'),
                                    IconButton(
                                      icon: const Icon(Icons.chevron_right),
                                      onPressed: (currentPage + 1) *
                                                  rowsPerPage <
                                              getSelectedPlayerReport()
                                                  .report
                                                  .length
                                          ? () =>
                                              handleChangePage(currentPage + 1)
                                          : null,
                                    ),
                                  ],
                                ),
                                DropdownButton<int>(
                                  value: rowsPerPage,
                                  dropdownColor: Colors.blue[900],
                                  items: [10, 25, 50, 100].map((value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('$value rows per page'),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      handleChangeRowsPerPage(value!),
                                ),
                                const SizedBox(height: 16),
                                const TableLegend(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }));
  }
}
