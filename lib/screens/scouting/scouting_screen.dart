import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/player/player.dart';
import '../../services/api_client.dart';
import '../../services/toast_service.dart';
import '../../services/transfers.dart';
import '../../state/actions.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/transfers_parser.dart';
import '../squad/player_card.dart';
import 'scoring_system.dart';

class Scouting extends StatefulWidget {
  static const String id = 'scouting_screen';

  const Scouting({super.key});

  @override
  State<Scouting> createState() => _ScoutingState();
}

class _ScoutingState extends State<Scouting>
    with SingleTickerProviderStateMixin {
  List<TeamPlayer> transfersPlayers = [];
  bool isLoading = false;
  ApiClient apiClient = ApiClient();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchTransfers(
      String? countryName, List<TeamPlayer> statePlayers) async {
    if (countryName == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<TeamPlayer> fetchedPlayers =
          await fetchTransfersByCountry(apiClient, countryName, statePlayers);

      setState(() {
        transfersPlayers = fetchedPlayers;
      });

      if (_tabController != null) {
        _tabController!.animateTo(1);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching transfers: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _showPlayerDialog(BuildContext context, TeamPlayer player) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.blue[900],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        insetPadding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 432,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlayerCard(player: player),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _updateObservedPlayers(BuildContext context,
      AppStateNotifier appStateNotifier, TeamPlayer player, String action) {
    final toastService = ToastService(context);

    StoreActionTypes type = action == "delete"
        ? StoreActionTypes.delObservedPlayer
        : StoreActionTypes.addObservedPlayer;

    appStateNotifier.dispatch(
      StoreAction(type, player, notify: true),
    );

    toastService.showToast(
      '${player.info.name.name} ${action == "delete" ? "removed from" : "added to"} observed players!',
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: const Text('Player Position Scores'),
      ),
      body: Consumer<AppStateNotifier>(
          builder: (context, appStateNotifier, child) {
        String lastDisplayedPos = "";
        final players = filteredPlayers(appStateNotifier.state.observedPlayers);

        final transfersPlayersFiltered = filteredPlayers(transfersPlayers);
        final observedPlayers = sortedPlayers(players);
        final transfersPlayersSorted = sortedPlayers(transfersPlayersFiltered);

        final countryName =
            appStateNotifier.state.user?.team.country?.name ?? "";

        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _fetchTransfers(countryName, observedPlayers),
                      icon: SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.0)
                              : const Icon(Icons.sync, color: Colors.white),
                        ),
                      ),
                      label: const Text('Fetch Transfers'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 8.0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Observed Players"),
                          Tab(text: "Transfer Players"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1.5),
                                },
                                children: [
                                  const TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Age',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Score',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            'Pos',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...observedPlayers.map((player) {
                                    List<MapEntry<String, dynamic>> scores =
                                        filterAndSortPlayerScores(player.info);

                                    TableRow row = TableRow(
                                      decoration: BoxDecoration(
                                        border:
                                            lastDisplayedPos != scores.first.key
                                                ? const Border(
                                                    top: BorderSide(
                                                        color: Colors.blue),
                                                  )
                                                : null,
                                      ),
                                      children: [
                                        GestureDetector(
                                          onTap: () => _showPlayerDialog(
                                              context, player),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${player.info.name.name} ${player.info.name.surname}',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _showPlayerDialog(
                                              context, player),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(player
                                                .info.characteristics.age
                                                .toString()),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _showPlayerDialog(
                                              context, player),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(scores
                                                .first.value['score']
                                                .toStringAsFixed(2)),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(scores.first.key),
                                                GestureDetector(
                                                  onTap: () =>
                                                      _updateObservedPlayers(
                                                          context,
                                                          appStateNotifier,
                                                          player,
                                                          "delete"),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );

                                    lastDisplayedPos = scores.first.key;
                                    return row;
                                  }),
                                ],
                              ),
                            ),
                            transfersPlayersSorted.isEmpty
                                ? const Center(
                                    child:
                                        Text('No transfer players available.'))
                                : SingleChildScrollView(
                                    child: Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(1),
                                      },
                                      children: [
                                        const TableRow(
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Age',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Score',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0),
                                                child: Text(
                                                  'Pos',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...transfersPlayersSorted.map((player) {
                                          List<MapEntry<String, dynamic>>
                                              scores =
                                              filterAndSortPlayerScores(
                                                  player.info);
                                          TableRow row = TableRow(
                                            decoration: BoxDecoration(
                                              border: lastDisplayedPos !=
                                                      scores.first.key
                                                  ? const Border(
                                                      top: BorderSide(
                                                          color: Colors.blue),
                                                    )
                                                  : null,
                                            ),
                                            children: [
                                              GestureDetector(
                                                onTap: () => _showPlayerDialog(
                                                    context, player),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${player.info.name.name} ${player.info.name.surname}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => _showPlayerDialog(
                                                    context, player),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(player
                                                      .info.characteristics.age
                                                      .toString()),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => _showPlayerDialog(
                                                    context, player),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(scores
                                                          .first.value['score']
                                                          .toStringAsFixed(2)),
                                                      const SizedBox(
                                                          width: 4.0),
                                                      Row(
                                                        children: List.generate(
                                                          scores.first
                                                              .value['stars'],
                                                          (index) => const Icon(
                                                            Icons.star,
                                                            size: 10.0,
                                                            color:
                                                                Colors.yellow,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(scores.first.key),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _updateObservedPlayers(
                                                                context,
                                                                appStateNotifier,
                                                                player,
                                                                player.isObserved ==
                                                                        true
                                                                    ? "delete"
                                                                    : "add"),
                                                        child: Icon(
                                                          player.isObserved ==
                                                                  true
                                                              ? Icons.remove
                                                              : Icons.add,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                          lastDisplayedPos = scores.first.key;
                                          return row;
                                        }),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
