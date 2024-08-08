import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/juniors/junior_progress.dart';

class ProgressLineChart extends StatefulWidget {
  final JuniorProgress data;
  const ProgressLineChart({super.key, required this.data});

  @override
  State<ProgressLineChart> createState() => _ProgressLineChartState();
}

class _ProgressLineChartState extends State<ProgressLineChart> {
  static const double pointWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final numberOfPoints = widget.data.values.length;
            final chartContentWidth = numberOfPoints * pointWidth;
            const chartHeight = 364.0;

            final shouldScroll = chartContentWidth > constraints.maxWidth;

            return SingleChildScrollView(
              scrollDirection: shouldScroll ? Axis.horizontal : Axis.vertical,
              child: SizedBox(
                width: shouldScroll ? chartContentWidth : constraints.maxWidth,
                height: chartHeight,
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: LineChart(mainData())),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = '';
    int intValue = value.toInt();

    if (intValue >= 0 && intValue <= widget.data.values.last.x) {
      text = '$intValue';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Transform.translate(
        offset: const Offset(0, 0),
        child: Transform.rotate(
          angle: -0.785398,
          child: Text(text, style: style),
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return Text('${value.toInt()}', style: style);
  }

  LineChartData mainData() {
    final minX = widget.data.values.first.x.toDouble();
    final maxX = widget.data.values.last.x.toDouble();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 32,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: 18,
      lineBarsData: [
        LineChartBarData(
          spots: widget.data.values
              .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
              .toList(),
          isCurved: false,
          color: Colors.red,
          dotData: const FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
}
