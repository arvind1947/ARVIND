import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/odometer_input.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _odoController = TextEditingController();

  @override
  void dispose() {
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final odometer = double.tryParse(_odoController.text) ?? 0;
        final distance = app.distanceFromLast(odometer);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Odometer Dashboard', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                GlassCard(child: OdometerInput(controller: _odoController)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _metric(context, 'Last mileage', '${app.latestFuel?.mileage.toStringAsFixed(2) ?? '--'} km/l'),
                        _metric(context, 'Estimated mileage', '${app.estimatedMileage(odometer).toStringAsFixed(2)} km/l'),
                        _metric(context, 'Distance traveled', '${distance.toStringAsFixed(1)} km'),
                        const Divider(),
                        Text('Service status: ${app.serviceStatus(odometer)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _metric(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: Theme.of(context).textTheme.titleMedium)],
      ),
    );
  }
}
