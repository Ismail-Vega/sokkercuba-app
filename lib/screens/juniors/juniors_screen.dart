import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/juniors/junior_progress.dart';
import '../../models/juniors/juniors.dart';
import '../../models/news/news_junior.dart';
import '../../services/toast_service.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/junior_utils.dart';
import '../../utils/skill_parser.dart';
import '../../utils/skills_checker.dart';
import '../noData/no_data_screen.dart';
import 'junior_badge.dart';
import 'progress_line_chart.dart';

class JuniorsScreen extends StatefulWidget {
  static const String id = 'juniors_screen';

  const JuniorsScreen({super.key});

  @override
  State<JuniorsScreen> createState() => _JuniorsScreenState();
}

class _JuniorsScreenState extends State<JuniorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<int, bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _expandedStates = {};
  }

  @override
  Widget build(BuildContext context) {
    final appStateNotifier = Provider.of<AppStateNotifier>(context);
    final juniors = appStateNotifier.state.juniors;
    final progress = appStateNotifier.state.juniorsTraining?.juniors ?? {};
    final potentialData = appStateNotifier.state.news?.juniors ?? [];

    final currentJuniorsList = juniors?.juniors ?? [];
    final prevJuniorsList = juniors?.prevJuniors ?? [];

    if (_expandedStates.isEmpty) {
      final allJuniors = [
        ...currentJuniorsList,
        ...prevJuniorsList,
      ];
      _expandedStates = {for (var junior in allJuniors) junior.id: false};
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Current Juniors'),
              Tab(text: 'Previous Juniors'),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJuniorsTable(currentJuniorsList, progress, potentialData,
                    'No current juniors found.'),
                _buildJuniorsTable(prevJuniorsList, progress, potentialData,
                    'No previous juniors found.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJuniorsTable(
      List<Junior> juniorsList,
      Map<int, JuniorProgress>? progress,
      List<NewsJunior> potentialData,
      String noDataMessage) {
    if (juniorsList.isEmpty) {
      return const NoDataFoundScreen();
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: LayoutBuilder(builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 764;
        return Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isWideScreen ? 764 : double.infinity),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        color: Colors.blue[900],
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
                                    final juniorProgress = progress?[junior.id];
                                    final index = potentialData.indexWhere(
                                        (item) => item.id == junior.id);
                                    final potential = index != -1
                                        ? potentialData[index]
                                        : null;
                                    return [
                                      _buildDataRow(junior, juniorProgress,
                                          potential, isExpanded),
                                    ];
                                  }),
                                ],
                              ),
                            ),
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
    final isNewJunior = junior.startWeek == trainingWeek &&
        (progress?.values == null || progress!.values.length <= 1);

    final skillPops = calculateSkillPops(progress?.values ?? []);
    final avgWeeksPop = calculateAverageWeeksPop(progress?.values ?? []);
    final isCrack = skillPops >= 6 && avgWeeksPop < 3.6;

    final showBadgeAnimation = junior.weeksLeft == 0 || isNewJunior || isCrack;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.1, color: Colors.white),
        ),
      ),
      children: [
        Stack(children: [
          GestureDetector(
            onTap: () => _toggleExpansion(junior.id, progress, context),
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
            top: 0,
            right: 0,
            child: JuniorBadge(
              weeksLeft: junior.weeksLeft,
              isNew: isNewJunior,
              showAnimation: showBadgeAnimation,
              isCrack: isCrack,
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
            onTap: () => _toggleExpansion(junior.id, progress, context),
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
      onTap: () => _toggleExpansion(id, progress, context),
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

  void _toggleExpansion(
      int id, JuniorProgress? progress, BuildContext context) {
    final toastService = ToastService(context);

    setState(() {
      _expandedStates[id] = !_expandedStates[id]!;
      if (_expandedStates[id]! && progress != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDetailsDialog(id, progress);
        });
      } else {
        toastService.showToast(
          "This junior doesn't have graph data!",
          backgroundColor: Colors.deepOrangeAccent,
        );
      }
    });
  }

  void _showDetailsDialog(int id, JuniorProgress? progress) {
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
                      height: 364, child: ProgressLineChart(data: progress))
                  : const Center(child: NoDataFoundScreen()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _expandedStates[id] = false;
                    });
                  },
                  child: const Text('Close'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
