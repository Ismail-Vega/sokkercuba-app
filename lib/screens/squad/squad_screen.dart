import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/squad.dart';
import '../../models/player/player.dart';
import '../../models/training/training.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/get_training_data.dart';
import '../noData/no_data_screen.dart';
import 'player_card.dart';
import 'player_sort.dart';

class SquadScreen extends StatefulWidget {
  static const String id = 'squad_screen';

  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen>
    with SingleTickerProviderStateMixin {
  SortCriteria _sortCriteria = SortCriteria.hasSkillChanges;
  List<TeamPlayer> _sortedSquad = [];
  List<TeamPlayer> _sortedPrevSquad = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _updateSortedSquad();
    _updateSortedPrevSquad();
  }

  @override
  Widget build(BuildContext context) {
    final appStateNotifier = Provider.of<AppStateNotifier>(context);
    final squad = appStateNotifier.state.players?.players;
    final prevSquad = appStateNotifier.state.players?.prevPlayers;

    if (squad == null || prevSquad == null) {
      return const NoDataFoundScreen();
    }

    if (_sortedSquad != squad) {
      _updateSortedSquad();
    }

    if (_sortedPrevSquad != prevSquad) {
      _updateSortedPrevSquad();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth <= 420) {
      childAspectRatio = 0.98;
    } else if (screenWidth < 600) {
      childAspectRatio = 1.04;
    } else if (screenWidth >= 600 && screenWidth <= 764) {
      crossAxisCount = 2;
      childAspectRatio = 0.80;
    } else if (screenWidth > 764 && screenWidth <= 1200) {
      crossAxisCount = 2;
      childAspectRatio = 0.90;
    } else if (screenWidth > 1200 && screenWidth <= 1365) {
      crossAxisCount = 3;
      childAspectRatio = 0.85;
    } else if (screenWidth > 1365 && screenWidth <= 1599) {
      crossAxisCount = 3;
      childAspectRatio = 0.90;
    } else if (screenWidth > 1600) {
      crossAxisCount = 3;
      childAspectRatio = 1;
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Squad'),
              Tab(text: 'Previous Players'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text('Sort by: '),
                SortDropdown(
                  selectedCriteria: _sortCriteria,
                  onCriteriaChanged: (criteria) {
                    setState(() {
                      _sortCriteria = criteria ?? _sortCriteria;
                      _updateSortedSquad();
                      _updateSortedPrevSquad();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGrid(_sortedSquad, crossAxisCount, childAspectRatio),
                _buildGrid(_sortedPrevSquad, crossAxisCount, childAspectRatio),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
      List<TeamPlayer> players, int crossAxisCount, double childAspectRatio) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return PlayerCard(player: player);
      },
    );
  }

  void _updateSortedSquad() {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final squad = appStateNotifier.state.players?.players;
    final trainingPlayers = appStateNotifier.state.training?.players;
    final trainingWeek = appStateNotifier.state.trainingWeek;

    if (squad == null || trainingPlayers == null || trainingWeek == null) {
      return;
    }

    List<TeamPlayer> sortedSquad = List.from(squad);
    _sortPlayers(sortedSquad, trainingPlayers, trainingWeek);
    setState(() {
      _sortedSquad = sortedSquad;
    });
  }

  void _updateSortedPrevSquad() {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final prevSquad = appStateNotifier.state.players?.prevPlayers;

    if (prevSquad == null) return;

    List<TeamPlayer> sortedPrevSquad = List.from(prevSquad);
    _sortPlayers(sortedPrevSquad, null, null);

    setState(() {
      _sortedPrevSquad = sortedPrevSquad;
    });
  }

  void _sortPlayers(List<TeamPlayer> players,
      List<PlayerTrainingReport>? trainingPlayers, int? trainingWeek) {
    switch (_sortCriteria) {
      case SortCriteria.hasSkillChanges:
        if (trainingPlayers == null || trainingWeek == null) return;

        players.sort((a, b) {
          final aReports = getPlayerTrainingReport(trainingPlayers, a.id);
          final bReports = getPlayerTrainingReport(trainingPlayers, b.id);

          final reportIndexA =
              aReports?.report.indexWhere((rep) => rep.week == trainingWeek);
          final reportIndexB =
              bReports?.report.indexWhere((rep) => rep.week == trainingWeek);

          final aReport = reportIndexA != null && reportIndexA > -1
              ? aReports?.report[reportIndexA]
              : null;
          final bReport = reportIndexB != null && reportIndexB > -1
              ? bReports?.report[reportIndexB]
              : null;

          final aHasChanges =
              aReport?.skillsChange.up != 0 || aReport?.skillsChange.down != 0;
          final bHasChanges =
              bReport?.skillsChange.up != 0 || bReport?.skillsChange.down != 0;

          if (aHasChanges && !bHasChanges) return -1;
          if (!aHasChanges && bHasChanges) return 1;
          return 0;
        });
        break;
      case SortCriteria.name:
        players.sort((a, b) => a.info.name.full.compareTo(b.info.name.full));
        break;
      case SortCriteria.age:
        players.sort((a, b) =>
            a.info.characteristics.age.compareTo(b.info.characteristics.age));
        break;
      case SortCriteria.stamina:
        players.sort(
            (a, b) => b.info.skills.stamina.compareTo(a.info.skills.stamina));
        break;
      case SortCriteria.pace:
        players
            .sort((a, b) => b.info.skills.pace.compareTo(a.info.skills.pace));
        break;
      case SortCriteria.technique:
        players.sort((a, b) =>
            b.info.skills.technique.compareTo(a.info.skills.technique));
        break;
      case SortCriteria.passing:
        players.sort(
            (a, b) => b.info.skills.passing.compareTo(a.info.skills.passing));
        break;
      case SortCriteria.keeper:
        players.sort(
            (a, b) => b.info.skills.keeper.compareTo(a.info.skills.keeper));
        break;
      case SortCriteria.defending:
        players.sort((a, b) =>
            b.info.skills.defending.compareTo(a.info.skills.defending));
        break;
      case SortCriteria.playmaking:
        players.sort((a, b) =>
            b.info.skills.playmaking.compareTo(a.info.skills.playmaking));
        break;
      case SortCriteria.striker:
        players.sort(
            (a, b) => b.info.skills.striker.compareTo(a.info.skills.striker));
        break;
    }
  }
}
