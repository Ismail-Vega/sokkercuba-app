import 'package:flutter/material.dart';

class TableLegend extends StatelessWidget {
  const TableLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                color: Colors.green[400],
                size: 16,
              ), // Dark green dot
              const SizedBox(width: 8),
              const Text('Advanced Training'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Row(
              children: [
                Icon(Icons.circle,
                    color: Colors.grey[700], size: 16), // Light green dot
                const SizedBox(width: 8),
                const Text('Formation Training'),
              ],
            ),
          ),
        ]),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: Colors.red, size: 16), // Red dot
                SizedBox(width: 8),
                Text('Missing Training'),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.red, size: 16), // Cross icon
                  SizedBox(width: 8),
                  Text('Injury'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
