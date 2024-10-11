import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/player/player.dart';
import '../../services/api_client.dart';
import '../../services/toast_service.dart';
import '../../services/transfers.dart';
import '../../state/actions.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/format.dart';
import '../../utils/transfers_parser.dart';
import '../squad/player_card.dart';
import 'scoring_system.dart';

class Scouting extends StatefulWidget {
  static const String id = 'scouting_screen';

  const Scouting({super.key});

  @override
  State<Scouting> createState() => _ScoutingState();
}

class _ScoutingState extends State<Scouting> {
  List<TeamPlayer> transfersPlayers = [];
  bool isLoading = false;
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleDailyTransferFetch();
    });
  }

  void _scheduleDailyTransferFetch() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime.local(
      now.year,
      now.month,
      now.day,
      8,
    );

    if (now.isAfter(scheduledTime)) {
      _fetchTransfers();
    }

    final durationUntil8AM =
        scheduledTime.add(const Duration(days: 1)).difference(now);
    Timer(durationUntil8AM, _fetchTransfers);
  }

  Future<void> _fetchTransfers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final appStateNotifier =
          Provider.of<AppStateNotifier>(context, listen: false);
      String? countryName = appStateNotifier.state.user?.team.country?.name;

      if (countryName != null) {
        List<TeamPlayer> fetchedPlayers = await fetchTransfersByCountry(
            apiClient, countryName, appStateNotifier.state.observedPlayers);

        appStateNotifier.dispatch(StoreAction(
            StoreActionTypes.updateObservedPlayers, fetchedPlayers));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching transfers: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _removePlayer(TeamPlayer player) {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final updatedObservedPlayers =
        List<TeamPlayer>.from(appStateNotifier.state.observedPlayers)
          ..removeWhere((p) => p.id == player.id);

    appStateNotifier.dispatch(StoreAction(
      StoreActionTypes.updateObservedPlayers,
      updatedObservedPlayers,
    ));
  }

  @override
  Widget build(BuildContext wContext) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: const Text('Player Position Scores'),
      ),
      body: Consumer<AppStateNotifier>(
        builder: (context, appStateNotifier, child) {
          final players =
              filteredPlayers(appStateNotifier.state.observedPlayers);
          final observedPlayers = sortedPlayers(players);

          return ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(0.7),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.2),
                      },
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Age',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Score',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Pos',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...observedPlayers.map((player) {
                          List<MapEntry<String, dynamic>> scores =
                              filterAndSortPlayerScores(player.info);

                          return TableRow(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showPlayerDialog(wContext, player),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${player.info.name.name} ${player.info.name.surname}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _showPlayerDialog(wContext, player),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(player.info.characteristics.age
                                      .toString()),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _showPlayerDialog(wContext, player),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(scores.first.value['score']
                                          .toStringAsFixed(2)),
                                      const SizedBox(width: 4.0),
                                      Row(
                                        children: List.generate(
                                          scores.first.value['stars'],
                                          (index) => const Icon(
                                            Icons.star,
                                            size: 10.0,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(scores.first.key),
                                    GestureDetector(
                                      onTap: () => _removePlayer(player),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPlayerDialog(BuildContext parentContext, TeamPlayer player) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.blue[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        insetPadding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 432,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () =>
                          _showSendToNtManagerDialog(parentContext, player),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlayerCard(player: player),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSendToNtManagerDialog(BuildContext pContext, TeamPlayer player) {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Send to:"),
          backgroundColor: Colors.blue[900],
          content: TextField(
            controller: usernameController,
            decoration:
                const InputDecoration(hintText: "Enter NT Manager username"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final toastService = ToastService(pContext);
                final ntManager = usernameController.text.trim();

                if (ntManager.isNotEmpty) {
                  if (pContext.mounted) {
                    Navigator.of(pContext).pop();
                    Navigator.of(pContext).pop();
                  }
                  bool success = await _sendProposalToNtManager(
                      pContext, player, ntManager);

                  if (success) {
                    toastService.showToast(
                      'Email sent successfully',
                      backgroundColor: Colors.green,
                    );
                  } else {
                    toastService.showToast(
                      'Failed to send email',
                      backgroundColor: Colors.red,
                    );
                  }
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _sendProposalToNtManager(
      BuildContext context, TeamPlayer player, String ntManager) async {
    final toastService = ToastService(context);
    final apiClient = ApiClient();
    await apiClient.initCookieJar();

    try {
      final checkResponse = await apiClient.fetchData(
        '/mailbox.php',
        queryParameters: {
          'xml': 'checkLogin',
          'login': ntManager,
        },
      );

      if (checkResponse == null || checkResponse == '0') {
        toastService.showToast(
          'NT Manager not found',
          backgroundColor: Colors.red,
        );
        return false;
      }

      final userId = int.tryParse(checkResponse);
      if (userId == null || userId == 0) {
        toastService.showToast(
          'NT Manager not found',
          backgroundColor: Colors.red,
        );
        return false;
      }

      final playerInfo = formatPlayerInfo(player);

      final response = await apiClient.sendData('/sent.php', {
        'sendmail': '1',
        'back': 'mailbox',
        'typeto': 'login',
        'send_to': ntManager,
        'title': 'Player Proposal for NT',
        'text': playerInfo,
        'mailtype': 'sokker',
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Origin': 'https://sokker.org',
        'Referer': 'https://sokker.org/mailbox/',
      });

      return response != null && response.data.toString().trim() == 'OK';
    } catch (e) {
      if (kDebugMode) {
        print("Error sending email: $e");
      }
      toastService.showToast(
        'An error occurred while sending the proposal',
        backgroundColor: Colors.red,
      );
      return false;
    }
  }
}
