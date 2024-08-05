import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state_notifier.dart';
import '../noData/no_data_screen.dart';
import 'player_card.dart';

class SquadScreen extends StatelessWidget {
  static const String id = 'squad_screen';

  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final squad = appStateNotifier.state.players?.players;

    if (squad == null) {
      return const NoDataFoundScreen();
    }

    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 8,
        ),
        itemCount: squad.length,
        itemBuilder: (context, index) {
          final player = squad[index];
          return PlayerCard(player: player);
        },
      ),
    );
  }
}
