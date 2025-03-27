import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatelessWidget {
  const PieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: const Legend(isVisible: true),
      series: <PieSeries<_PieData, String>>[
        PieSeries<_PieData, String>(
          explode: true,
          explodeIndex: 0,
          dataSource: pieData,
          xValueMapper: (_PieData data, _) => data.xData,
          yValueMapper: (_PieData data, _) => data.yData,
          dataLabelMapper: (_PieData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String text;
}

// ignore: library_private_types_in_public_api
final List<_PieData> pieData = [
  _PieData('GPU Mining', 30, '30%'),
  _PieData('CPU Mining', 20, '20%'),
  _PieData('ASIC Mining', 15, '15%'),
  _PieData('Cloud Mining', 10, '10%'),
  _PieData('Solo Mining', 25, '25%'),
];
