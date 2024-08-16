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

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    double childAspectRatio = 1;

    if (screenWidth > 320 && screenWidth <= 414) {
      childAspectRatio = 0.90;
    } else if (screenWidth > 414 && screenWidth <= 600) {
      childAspectRatio = 1.05;
    } else if (screenWidth > 600 && screenWidth <= 900) {
      childAspectRatio = 1.35;
    } else if (screenWidth > 900 && screenWidth <= 1200) {
      crossAxisCount = 2;
      childAspectRatio = 1;
    } else if (screenWidth > 1200) {
      crossAxisCount = 3;
      childAspectRatio = 0.9;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: squad.length,
      itemBuilder: (context, index) {
        final player = squad[index];
        return PlayerCard(player: player);
      },
    );
  }
}
