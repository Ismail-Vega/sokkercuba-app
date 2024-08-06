import 'package:flutter/material.dart';

class GrowthDisplay extends StatelessWidget {
  final Map<String, double> growth;

  const GrowthDisplay({super.key, required this.growth});

  @override
  Widget build(BuildContext context) {
    final entries = growth.entries.toList();
    final firstHalf = entries.sublist(0, 4);
    final secondHalf = entries.sublist(4, 8);

    return Card(
      color: Colors.blue[900],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Skill Avg. Talent:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildTableRow(firstHalf),
                  _buildTableRow(secondHalf),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<MapEntry<String, double>> data) {
    return TableRow(
      children: data.map((entry) {
        return TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key.substring(0, 3).toUpperCase()}:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
