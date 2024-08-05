import 'package:flutter/material.dart';

import '../../models/juniors/junior_progress.dart';
import '../../models/juniors/juniors.dart';
import '../../models/news/news_junior.dart';
import '../../utils/skill_parser.dart';
import '../../utils/skills_checker.dart';
import '../noData/no_data_screen.dart';

class JuniorsScreen extends StatelessWidget {
  final Juniors? juniors;
  final Map<int, JuniorProgress>? progress;
  final List<NewsJunior> potentialData;

  const JuniorsScreen(
      {super.key,
      required this.juniors,
      required this.progress,
      required this.potentialData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: juniors?.juniors != null && juniors!.juniors!.isNotEmpty
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
                        vertical: 16.0, horizontal: 20.0),
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
                })
              ],
            )
          : const NoDataFoundScreen(),
    );
  }
}

class JuniorTile extends StatefulWidget {
  final Junior junior;
  final JuniorProgress? progress;
  final NewsJunior? potential;

  const JuniorTile(
      {super.key,
      required this.junior,
      required this.progress,
      this.potential});

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

    return Card(
      color: Colors.blueAccent,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    junior.fullName.full,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(0.5),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Text('Age: ${junior.age}'),
                          ),
                          TableCell(
                            child: Text(
                              'Level: ${parseSkillToText(junior.skill)}',
                              style: TextStyle(
                                color: getJuniorLevelColor(progress
                                    ?.values), // Set the text color here
                              ),
                            ),
                          ),
                          TableCell(
                            child: Text('Weeks: ${junior.weeksLeft}'),
                          ),
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Level: ${junior.skill}'),
                  //Text('Formation: ${junior.formation}'),
                  Text('Weeks Left: ${junior.weeksLeft}'),
                  const SizedBox(height: 10),
                  // Example of a placeholder for the graph widget
                  Container(
                    height: 200,
                    color: Colors.blue[900],
                    child: const Center(child: Text('Graph will be here')),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
