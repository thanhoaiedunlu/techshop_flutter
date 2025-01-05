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
        title: const Text('Biểu đồ doanh thu'),
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
            // Tìm giá trị doanh thu lớn nhất
            final maxRevenue = data.map((item) => item.revenue).reduce((a, b) => a > b ? a : b);
            // Kiểm tra xem doanh thu tối đa có lớn hơn 1 tỷ hay không
            final bool isBillion = maxRevenue >= 1000000000;
            final unit = isBillion ? 1000000000 : 1000000; // Đơn vị hiển thị
            final unitLabel = isBillion ? 'Tỷ VND' : 'Triệu VND'; // Nhãn đơn vị

            return Container(
              color: Colors.white, // Nền trắng cho toàn màn hình
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                  backgroundColor: Colors.white, // Nền trắng cho biểu đồ
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxRevenue / unit).toDouble() + (isBillion ? 0.1 : 10), // Giá trị tối đa
                  barGroups: data
                      .map(
                        (item) => BarChartGroupData(
                      x: item.month,
                      barRods: [
                        BarChartRodData(
                          toY: (item.revenue / unit).toDouble(),
                          width: 16,
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.lightBlueAccent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Doanh Thu ($unitLabel)'),
                      axisNameSize: 20,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: isBillion ? 0.5 : 10, // Khoảng cách nhãn
                        getTitlesWidget: (value, meta) => Text(
                          isBillion ? value.toStringAsFixed(1) : '${value.toInt()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Tháng'),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'T${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        interval: 1, // Hiển thị mỗi tháng
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Colors.black),
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
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