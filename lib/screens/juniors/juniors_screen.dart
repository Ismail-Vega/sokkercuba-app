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
import 'junior_badge.dart';
import 'progress_line_chart.dart';

class JuniorsScreen extends StatefulWidget {
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
  State<JuniorsScreen> createState() => _JuniorsScreenState();
}

class _JuniorsScreenState extends State<JuniorsScreen> {
  late Map<int, bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = {};

    if (widget.juniors?.juniors != null) {
      for (var junior in widget.juniors!.juniors!) {
        _expandedStates[junior.id] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final juniorsList = widget.juniors?.juniors;

    if (juniorsList == null || juniorsList.isEmpty) {
      return const NoDataFoundScreen();
    }

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
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.2, color: Colors.white),
                                      ),
                                    ),
                                    children: [
                                      _buildHeaderCell('Name'),
                                      _buildHeaderCell('Age'),
                                      _buildHeaderCell('Level'),
                                      _buildHeaderCell('Projected Level'),
                                      _buildHeaderCell('Pops'),
                                      _buildHeaderCell('Weeks/Pop'),
                                      _buildHeaderCell('Weeks'),
                                      _buildHeaderCell('Pos'),
                                    ],
                                  ),
                                  ...juniorsList.expand((junior) {
                                    final isExpanded =
                                        _expandedStates[junior.id] ?? false;
                                    final progress =
                                        widget.progress?[junior.id];
                                    int index = widget.potentialData.indexWhere(
                                        (item) => item.id == junior.id);
                                    NewsJunior? potential = index != -1
                                        ? widget.potentialData[index]
                                        : null;

                                    return [
                                      _buildDataRow(junior, progress, potential,
                                          isExpanded),
                                    ];
                                  }),
                                ],
                              ),
                            )
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
      }),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TableRow _buildDataRow(
    Junior junior,
    JuniorProgress? progress,
    NewsJunior? potential,
    bool isExpanded,
  ) {
    final trainingWeek =
        Provider.of<AppStateNotifier>(context).state.trainingWeek;
    final isNewJunior =
        progress?.values == null ? true : progress!.values.length <= 1;
    final showBadgeAnimation = junior.weeksLeft == 0 ||
        (junior.startWeek == trainingWeek && isNewJunior);

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.1, color: Colors.white),
        ),
      ),
      children: [
        Stack(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedStates[junior.id] = !_expandedStates[junior.id]!;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_expandedStates[junior.id]!) {
                    _showDetailsDialog(progress);
                  }
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                junior.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: JuniorBadge(
              weeksLeft: junior.weeksLeft,
              isNew: junior.startWeek == trainingWeek,
              showAnimation: showBadgeAnimation,
            ),
          ),
        ]),
        _buildDataCell(
          '${junior.age}',
          junior.id,
          progress,
        ),
        TableCell(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expandedStates[junior.id] = !isExpanded;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_expandedStates[junior.id]!) {
                    _showDetailsDialog(progress);
                  }
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  text: '${parseSkillToText(junior.skill)} [${junior.skill}]',
                  style: TextStyle(
                    color: getJuniorLevelColor(progress?.values),
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildDataCell(
          potential == null
              ? 'Unknown'
              : estimateFinalLevel(
                  progress?.values ?? [],
                  potential.potentialMin,
                  potential.potentialMax,
                  junior.weeksLeft,
                ),
          junior.id,
          progress,
        ),
        _buildDataCell(
          '${calculateSkillPops(progress?.values ?? [])}',
          junior.id,
          progress,
        ),
        _buildDataCell(
          calculateAverageWeeksPop(progress?.values ?? []).toStringAsFixed(2),
          junior.id,
          progress,
        ),
        _buildDataCell(
          '${junior.weeksLeft}',
          junior.id,
          progress,
        ),
        _buildDataCell(
          potential?.position ?? 'outfield',
          junior.id,
          progress,
        ),
      ],
    );
  }

  Widget _buildDataCell(
    String text,
    int id,
    JuniorProgress? progress, {
    Color textColor = Colors.white,
    bool isBold = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedStates[id] = !_expandedStates[id]!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_expandedStates[id]!) {
              _showDetailsDialog(progress);
            }
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(JuniorProgress? progress) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        insetPadding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Skill level chart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              progress != null
                  ? SizedBox(
                      height: 364,
                      child: ProgressLineChart(data: progress),
                    )
                  : const Center(
                      child: NoDataFoundScreen(),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
