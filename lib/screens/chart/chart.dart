import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/Revenue.dart';
import '../../shared/services/chart/chartService.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});
  @override
  State<Chart> createState() => _ChartState();
}
class _ChartState extends State<Chart> {
  late Future<List<Revenue>> revenueData;
  @override
  void initState() {
    super.initState();
    revenueData = ChartService().getRevenueData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Chart'),
      ),
      body: FutureBuilder<List<Revenue>>(
        future: revenueData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .map(
                            (item) => FlSpot(
                          item.month.toDouble(), // x month
                          item.revenue.toDouble(), // y revenue
                        ),
                      )
                          .toList(),
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                      ),
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.lightBlueAccent.withOpacity(0.1)
                          ],
                        ),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Revenue'),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Month'),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}

