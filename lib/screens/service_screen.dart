import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/service_entry.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/odometer_input.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final _odo = TextEditingController();
  final _interval = TextEditingController(text: '2500');
  DateTime _date = DateTime.now();
  ServiceEntry? _editing;

  @override
  void dispose() {
    _odo.dispose();
    _interval.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final currentOdo = app.latestFuel?.odometer ?? 0;
        final latestService = app.latestService;
        final nextDue = latestService?.nextDue ?? 0;
        final remain = nextDue - currentOdo;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Engine Oil / Service Tracker', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: [
                    OdometerInput(controller: _odo),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _interval,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Service interval (km)'),
                    ),
                    ListTile(
                      title: const Text('Service date'),
                      subtitle: Text(DateFormat.yMMMd().format(_date)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: _date,
                        );
                        if (selected != null) setState(() => _date = selected);
                      },
                    ),
                    FilledButton(
                      onPressed: () async {
                        final odo = double.tryParse(_odo.text);
                        final interval = double.tryParse(_interval.text) ?? 2500;
                        if (odo == null || interval <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid service input')));
                          return;
                        }
                        await app.saveService(
                          ServiceEntry(
                            id: _editing?.id,
                            odometer: odo,
                            date: _date,
                            interval: interval,
                          ),
                        );
                        setState(() {
                          _editing = null;
                          _odo.clear();
                          _interval.text = '2500';
                          _date = DateTime.now();
                        });
                      },
                      child: Text(_editing == null ? 'Save service' : 'Update service'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current odometer: ${currentOdo.toStringAsFixed(1)} km'),
                    Text('Next service due: ${nextDue.toStringAsFixed(1)} km'),
                    Text('Remaining: ${remain.toStringAsFixed(1)} km'),
                    Text('Alert: ${app.serviceStatus(currentOdo)}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...app.serviceEntries.map(
                (entry) => Card(
                  child: ListTile(
                    title: Text('${DateFormat.yMMMd().format(entry.date)} • ${entry.odometer.toStringAsFixed(1)} km'),
                    subtitle: Text('Interval ${entry.interval.toStringAsFixed(0)} km • Next ${entry.nextDue.toStringAsFixed(0)} km'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _editing = entry;
                              _odo.text = entry.odometer.toStringAsFixed(0);
                              _interval.text = entry.interval.toStringAsFixed(0);
                              _date = entry.date;
                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => app.removeService(entry.id!),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
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
}
