import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/format.dart';

class SquadSummaryCard extends StatelessWidget {
  const SquadSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppStateNotifier>(context).state.user;
    final userStats = Provider.of<AppStateNotifier>(context).state.userStats;

    if (user == null || userStats == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Squad Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Spartan MB',
                      )),
                ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              const Text('Total value: '),
              Text(
                  '${formatNumber(userStats.players.totalValue.value)} ${userStats.players.totalValue.currency}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              const Text('Reputation: '),
              Text('${user.team.rank}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              const Text('Avg. marks: '),
              Text('${userStats.players.averageMarks}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              const Text('Avg. form: '),
              Text(
                  '${userStats.players.averageFormSkill} (${skillsLevelsList[userStats.players.averageFormSkill]})',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
          ],
        ),
      ),
    );
  }
}
