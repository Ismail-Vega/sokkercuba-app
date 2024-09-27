import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/tsummary/tsummary.dart';
import '../../state/app_state_notifier.dart';
import 'tsummary_details.dart';

class TSummaryCard extends StatefulWidget {
  const TSummaryCard({super.key});

  @override
  State<TSummaryCard> createState() => _TSummaryCardState();
}

class _TSummaryCardState extends State<TSummaryCard> {
  int? selectedWeek;
  bool showAllWeeks = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateNotifier>(context).state;
    final tsummary = appState.tsummary;
    final trainingWeek = appState.trainingWeek;

    if (tsummary == null) {
      return const SizedBox.shrink();
    }

    List<Week> weeks = tsummary.weeks;
    List<Week> displayedWeeks = showAllWeeks ? weeks : weeks.take(5).toList();

    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Stack(
              children: [
                Center(
                  child: Text(
                    'Training Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Spartan MB',
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Tooltip(
                    message: 'Click on any row to view details.',
                    child:
                        Icon(Icons.help_outline, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 364.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: selectedWeek == null
                    ? Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1.5),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                ),
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Center(child: Text("")),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Center(
                                          child: Text(
                                        "MAIN TEAM",
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Center(
                                          child: Text(
                                        "JUNIORS",
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              const TableRow(
                                children: [
                                  TableCell(
                                    child: SizedBox(height: 8.0),
                                  ),
                                  TableCell(
                                    child: SizedBox(height: 8.0),
                                  ),
                                  TableCell(
                                    child: SizedBox(height: 8.0),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Center(child: Text("Date")),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              child:
                                                  Center(child: Text("No."))),
                                          Expanded(
                                              child: Center(
                                                  child: Text("Skills Up"))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              child:
                                                  Center(child: Text("No."))),
                                          Expanded(
                                              child: Center(
                                                  child: Text("Levels Up"))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...displayedWeeks.asMap().entries.where((entry) {
                                final value = entry.value;
                                return !(trainingWeek != null &&
                                    value.week == (trainingWeek + 1));
                              }).map((entry) {
                                final index = entry.key;
                                final week = entry.value;

                                return TableRow(
                                  decoration: index != weeks.length - 1
                                      ? const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.blue)),
                                        )
                                      : null,
                                  children: [
                                    TableCell(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedWeek = week.week;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Center(
                                            child:
                                                Text(week.gameDay.date.value),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedWeek = week.week;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: Text(week
                                                        .stats.advanced
                                                        .toString()))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(week
                                                        .stats.skillsUp
                                                        .toString()))),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedWeek = week.week;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: Text(week
                                                        .juniors.number
                                                        .toString()))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(week
                                                        .juniors.skillsUp
                                                        .toString()))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                          if (weeks.length > 5)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showAllWeeks = !showAllWeeks;
                                });
                              },
                              child: Text(
                                showAllWeeks
                                    ? 'Show Less'
                                    : 'Show All (${weeks.length - 5} more)',
                              ),
                            ),
                        ],
                      )
                    : TrainingSummaryDetails(
                        week: selectedWeek!,
                        onBack: () {
                          setState(() {
                            selectedWeek = null;
                          });
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
