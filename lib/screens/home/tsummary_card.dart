import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/tsummary/tsummary.dart';
import '../../state/app_state_notifier.dart';

class TSummaryCard extends StatelessWidget {
  const TSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateNotifier>(context).state;
    final tsummary = appState.tsummary;

    if (tsummary == null) {
      return const SizedBox.shrink();
    }

    List<Week> weeks = tsummary.weeks;

    return Card(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Training Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Spartan MB',
                      )),
                ]),
            const SizedBox(height: 8),
            SizedBox(
              height: 324.0, // Adjust the height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Allows vertical scrolling
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(child: Text("")),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(
                                child: Text("MAIN TEAM",
                                    textAlign: TextAlign.center)),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(
                                child: Text("JUNIORS",
                                    textAlign: TextAlign.center)),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(child: Text("Date")),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Center(child: Text("No."))),
                                Expanded(
                                    child: Center(child: Text("Skills Up"))),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Center(child: Text("No."))),
                                Expanded(
                                    child: Center(child: Text("Levels Up"))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...weeks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final week = entry.value;
                      return TableRow(
                        decoration: index != weeks.length - 1
                            ? BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            Colors.blue[900] ?? Colors.blue)),
                              )
                            : null,
                        children: [
                          TableCell(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(week.gameDay.date.value),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            week.stats.advanced.toString()))),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            week.stats.skillsUp.toString()))),
                              ],
                            ),
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            week.juniors.number.toString()))),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            week.juniors.skillsUp.toString()))),
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
      ),
    );
  }
}
