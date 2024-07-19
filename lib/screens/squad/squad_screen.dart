import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../services/api_client.dart';
import '../../state/actions.dart';
import '../../state/app_state_notifier.dart';
import 'player_card.dart';

class SquadScreen extends StatefulWidget {
  static const String id = 'squad_screen';

  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    fetchSquad();
  }

  void _toggleSpinner(bool value) {
    setState(() {
      showSpinner = value;
    });
  }

  void fetchSquad() async {
    try {
      _toggleSpinner(true);
      final apiClient = ApiClient();
      await apiClient.initCookieJar();

      if (mounted) {
        final appStateNotifier =
            Provider.of<AppStateNotifier>(context, listen: false);
        final user = appStateNotifier.state.user;

        if (user != null) {
          final stateSquad = appStateNotifier.state.players;
          final squadResponse = await apiClient.fetchData(
            '/player?filter[team]=${user.team.id}&filter[limit]=200&filter[offset]=0',
          );

          if (squadResponse != null && mounted) {
            final squad = setSquadData(stateSquad, squadResponse);

            appStateNotifier
                .dispatch(StoreAction(StoreActionTypes.setTeam, squad));
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error fetching squad data: $e');
      }
      Fluttertoast.showToast(
          msg: "There was a server error!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      _toggleSpinner(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final squad = appStateNotifier.state.players?.players;

    if (showSpinner) {
      return const Center(child: CircularProgressIndicator());
    }

    if (squad == null) {
      return const SizedBox.shrink();
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
