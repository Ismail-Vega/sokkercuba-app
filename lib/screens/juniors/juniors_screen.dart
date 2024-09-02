import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/juniors/junior_progress.dart';
import '../../models/juniors/juniors.dart';
import '../../models/news/news_junior.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/junior_utils.dart';
import '../../utils/skill_parser.dart';
import '../../utils/skills_checker.dart';
import '../noData/no_data_screen.dart';
import 'junior_card_header.dart';
import 'progress_line_chart.dart';

class JuniorsScreen extends StatelessWidget {
  final Juniors? juniors;
  final Map<int, JuniorProgress>? progress;
  final List<NewsJunior> potentialData;

  const JuniorsScreen({
    super.key,
    required this.juniors,
    required this.progress,
    required this.potentialData,
  });

  @override
  Widget build(BuildContext context) {
    return juniors?.juniors != null && juniors!.juniors!.isNotEmpty
        ? ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Text(
                          'Junior team, ${juniors?.juniors?.length ?? 0} juniors',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ...juniors!.juniors!.map((junior) {
                int index =
                    potentialData.indexWhere((item) => item.id == junior.id);
                NewsJunior? potential =
                    index != -1 ? potentialData[index] : null;

                return JuniorTile(
                  junior: junior,
                  progress: progress?[junior.id],
                  potential: potential,
                );
              }),
            ],
          )
        : const NoDataFoundScreen();
  }
}

class JuniorTile extends StatefulWidget {
  final Junior junior;
  final JuniorProgress? progress;
  final NewsJunior? potential;

  const JuniorTile({
    super.key,
    required this.junior,
    required this.progress,
    this.potential,
  });

  @override
  State<JuniorTile> createState() => _JuniorTileState();
}

class _JuniorTileState extends State<JuniorTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final junior = widget.junior;
    final progress = widget.progress;
    final potential = widget.potential;
    final trainingWeek =
        Provider.of<AppStateNotifier>(context).state.trainingWeek;

    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JuniorRow(
                    juniorFullName: junior.fullName.full,
                    isExpanded: _isExpanded,
                    weeksLeft: junior.weeksLeft,
                    isNew: junior.startWeek == trainingWeek,
                  ),
                  const SizedBox(height: 8.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                              ),
                              children: [
                                TableCell(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 8.0, 8.0, 0),
                                      child: Text('Age'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Level'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Projected Level'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Pops'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Weeks/pop'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Weeks'),
                                    ),
                                  ),
                                ),
                                const TableCell(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                                    child: Text('Pos'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                              ),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 8.0, 8.0, 0),
                                    child: Text('${junior.age}'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 8.0, 0),
                                    child: Text.rich(
                                      TextSpan(
                                        text:
                                            '${parseSkillToText(junior.skill)} [${junior.skill}]',
                                        style: TextStyle(
                                          color: getJuniorLevelColor(
                                              progress?.values),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      potential == null
                                          ? 'unknown'
                                          : estimateFinalLevel(
                                              progress?.values ?? [],
                                              potential.potentialMin,
                                              potential.potentialMax,
                                              junior.weeksLeft),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${calculateSkillPops(progress?.values ?? [])}'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(calculateAverageWeeksPop(
                                            progress?.values ?? [])
                                        .toStringAsFixed(2)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${junior.weeksLeft}'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(potential?.position ?? "outfield"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 364,
                    color: Colors.blue,
                    child: progress != null
                        ? ProgressLineChart(
                            data: progress,
                          )
                        : const Center(
                            child: NoDataFoundScreen(),
                          ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
