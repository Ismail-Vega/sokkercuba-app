import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/squad.dart';
import '../../models/player/player.dart';
import '../../state/app_state_notifier.dart';
import '../noData/no_data_screen.dart';
import 'player_card.dart';
import 'player_sort.dart';

class SquadScreen extends StatefulWidget {
  static const String id = 'squad_screen';

  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> {
  SortCriteria _sortCriteria = SortCriteria.hasSkillChanges;
  List<TeamPlayer> _sortedSquad = [];

  @override
  void initState() {
    super.initState();
    _updateSortedSquad();
  }

  @override
  Widget build(BuildContext context) {
    final appStateNotifier = Provider.of<AppStateNotifier>(context);
    final squad = appStateNotifier.state.players?.players;

    if (squad == null) {
      return const NoDataFoundScreen();
    }

    if (_sortedSquad != squad) {
      _updateSortedSquad();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth <= 390) {
      childAspectRatio = 1.05;
    } else if (screenWidth < 600) {
      childAspectRatio = 1.05;
    } else if (screenWidth >= 600 && screenWidth <= 764) {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    } else if (screenWidth > 764 && screenWidth <= 1200) {
      crossAxisCount = 2;
      childAspectRatio = 1;
    } else if (screenWidth > 1200) {
      crossAxisCount = 3;
      childAspectRatio = 0.9;
    }

    return Column(
      children: [
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
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _sortedSquad.length,
            itemBuilder: (context, index) {
              final player = _sortedSquad[index];
              return PlayerCard(player: player);
            },
          ),
        ),
      ],
    );
  }

  void _updateSortedSquad() {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final squad = appStateNotifier.state.players?.players;

    if (squad == null) return;

    List<TeamPlayer> sortedSquad = List.from(squad);

    switch (_sortCriteria) {
      case SortCriteria.hasSkillChanges:
        sortedSquad.sort((a, b) {
          final aHasChanges =
              a.info.skillsChange?.up != 0 || a.info.skillsChange?.down != 0;
          final bHasChanges =
              b.info.skillsChange?.up != 0 || b.info.skillsChange?.down != 0;
          if (aHasChanges && !bHasChanges) return -1;
          if (!aHasChanges && bHasChanges) return 1;
          return 0;
        });
        break;
      case SortCriteria.name:
        sortedSquad
            .sort((a, b) => a.info.name.full.compareTo(b.info.name.full));
        break;
      case SortCriteria.age:
        sortedSquad.sort((a, b) =>
            a.info.characteristics.age.compareTo(b.info.characteristics.age));
        break;
      case SortCriteria.stamina:
        sortedSquad.sort(
            (a, b) => b.info.skills.stamina.compareTo(a.info.skills.stamina));
        break;
      case SortCriteria.pace:
        sortedSquad
            .sort((a, b) => b.info.skills.pace.compareTo(a.info.skills.pace));
        break;
      case SortCriteria.technique:
        sortedSquad.sort((a, b) =>
            b.info.skills.technique.compareTo(a.info.skills.technique));
        break;
      case SortCriteria.passing:
        sortedSquad.sort(
            (a, b) => b.info.skills.passing.compareTo(a.info.skills.passing));
        break;
      case SortCriteria.keeper:
        sortedSquad.sort(
            (a, b) => b.info.skills.keeper.compareTo(a.info.skills.keeper));
        break;
      case SortCriteria.defending:
        sortedSquad.sort((a, b) =>
            b.info.skills.defending.compareTo(a.info.skills.defending));
        break;
      case SortCriteria.playmaking:
        sortedSquad.sort((a, b) =>
            b.info.skills.playmaking.compareTo(a.info.skills.playmaking));
        break;
      case SortCriteria.striker:
        sortedSquad.sort(
            (a, b) => b.info.skills.striker.compareTo(a.info.skills.striker));
        break;
    }

    setState(() {
      _sortedSquad = sortedSquad;
    });
  }
}
