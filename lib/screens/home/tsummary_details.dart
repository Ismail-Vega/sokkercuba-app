import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/training/training_report.dart';
import '../../state/app_state_notifier.dart';

class TrainingSummaryDetails extends StatelessWidget {
  final int week;
  final VoidCallback onBack;

  const TrainingSummaryDetails({
    super.key,
    required this.week,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final training = Provider.of<AppStateNotifier>(context).state.training;
    final players = training?.players ?? [];

    final Map<String, TrainingReport> changes = {};

    for (var player in players) {
      final index = player.report.indexWhere((report) => report.week == week);
      if (index != -1 &&
          (player.report[index].skillsChange.up != 0 ||
              player.report[index].skillsChange.down != 0)) {
        changes[player.player.name.full] = player.report[index];
      }
    }

    final tableRows = <TableRow>[];

    changes.forEach((playerName, report) {
      String lastDisplayedPlayer = "";
      final skillsChange = report.skillsChange;

      final skills = {
        'Stamina': skillsChange.stamina,
        'Pace': skillsChange.pace,
        'Technique': skillsChange.technique,
        'Passing': skillsChange.passing,
        'Keeper': skillsChange.keeper,
        'Defending': skillsChange.defending,
        'Playmaking': skillsChange.playmaking,
        'Striker': skillsChange.striker,
      };

      for (var entry in skills.entries) {
        final skill = entry.key;
        final value = entry.value;

        if (value != 0) {
          tableRows.add(TableRow(
            decoration: BoxDecoration(
              border: lastDisplayedPlayer != playerName
                  ? const Border(top: BorderSide(color: Colors.blue))
                  : null,
            ),
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    lastDisplayedPlayer != playerName ? playerName : "",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(skill),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        value > 0 ? Icons.add : Icons.remove,
                        color: value > 0 ? Colors.green : Colors.red,
                      ),
                      Text(value.abs().toString()),
                    ],
                  ),
                ),
              ),
            ],
          ));
          lastDisplayedPlayer = playerName;
        }
      }
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Week: $week",
            ),
            ElevatedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.white),
              iconAlignment: IconAlignment.end,
              label: const Text(
                'Back',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text("Player"),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text("Skill"),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text("Change"),
                  ),
                ),
              ],
            ),
            ...tableRows,
          ],
        ),
      ],
    );
  }
}
