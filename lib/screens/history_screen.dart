import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final entries = app.fuelEntries;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('History & Analytics', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Best mileage: ${app.bestMileage.toStringAsFixed(2)} km/l'),
                    const SizedBox(height: 12),
                    SizedBox(height: 220, child: _buildChart(entries)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...entries.map(
                (e) => Card(
                  child: ListTile(
                    title: Text('${DateFormat.yMMMd().format(e.date)} • ${e.odometer.toStringAsFixed(1)} km'),
                    subtitle: Text(
                      'Petrol ${e.liters.toStringAsFixed(2)} L • ₹${e.amount.toStringAsFixed(2)}\nMileage ${e.mileage.toStringAsFixed(2)} km/l',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart(entries) {
    if (entries.isEmpty) {
      return const Center(child: Text('No data yet'));
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < entries.length; i++) {
      spots.add(FlSpot(i.toDouble(), (entries[entries.length - 1 - i].mileage)));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Colors.teal,
            belowBarData: BarAreaData(show: true, color: Colors.teal.withOpacity(.2)),
          ),
        ],
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}
