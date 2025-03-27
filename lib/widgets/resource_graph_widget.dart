import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResourceUsage {
  final int timeIndex;
  final double usage;
  ResourceUsage(this.timeIndex, this.usage);
}

class ResourceChart extends StatelessWidget {
  final List<double> cpuData;
  final List<double> ramData;

  const ResourceChart({
    super.key,
    required this.cpuData,
    required this.ramData,
  });

  @override
  Widget build(BuildContext context) {
    //! Build data lists for CPU and RAM usage
    final List<ResourceUsage> cpuUsageList = [];
    final List<ResourceUsage> ramUsageList = [];

    for (int i = 0; i < cpuData.length; i++) {
      cpuUsageList.add(ResourceUsage(i, cpuData[i]));
    }
    for (int i = 0; i < ramData.length; i++) {
      ramUsageList.add(ResourceUsage(i, ramData[i]));
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          isVisible: false,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          interval: 20,
          labelFormat: '{value}%',
        ),
        legend: const Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          //! CPU Usage line
          LineSeries<ResourceUsage, int>(
            dataSource: cpuUsageList,
            xValueMapper: (ResourceUsage usage, _) => usage.timeIndex,
            yValueMapper: (ResourceUsage usage, _) => usage.usage,
            name: 'CPU Usage',
            markerSettings: const MarkerSettings(isVisible: true),
            color: Colors.blue,
          ),
          //! RAM Usage line
          LineSeries<ResourceUsage, int>(
            dataSource: ramUsageList,
            xValueMapper: (ResourceUsage usage, _) => usage.timeIndex,
            yValueMapper: (ResourceUsage usage, _) => usage.usage,
            name: 'RAM Usage',
            markerSettings: const MarkerSettings(isVisible: true),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
