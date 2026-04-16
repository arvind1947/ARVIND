import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/fuel_entry.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/odometer_input.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _odo = TextEditingController();
  final _liters = TextEditingController();
  final _amount = TextEditingController();
  DateTime _date = DateTime.now();
  FuelEntry? _editing;

  @override
  void dispose() {
    _odo.dispose();
    _liters.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final odometer = double.tryParse(_odo.text);
        final liters = double.tryParse(_liters.text);
        final amount = double.tryParse(_amount.text);

        final last = app.latestFuel;
        final distance = (odometer != null && last != null) ? (odometer - last.odometer).clamp(0, double.infinity) : 0;
        final mileage = (liters == null || liters <= 0) ? 0 : distance / liters;
        final pricePerLiter = (liters == null || liters <= 0 || amount == null) ? 0 : amount / liters;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(_editing == null ? 'Add Entry' : 'Edit Entry', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: [
                    OdometerInput(controller: _odo),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _liters,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Petrol filled (liters)'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _amount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Total amount (₹)'),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text('Date'),
                      subtitle: Text(DateFormat.yMMMd().format(_date)),
                      trailing: const Icon(Icons.calendar_month),
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
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price/L: ₹${pricePerLiter.toStringAsFixed(2)}'),
                        Text('Mileage: ${mileage.toStringAsFixed(2)} km/l'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () async {
                        if (odometer == null || liters == null || liters <= 0 || amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter valid odometer, liters and amount.')),
                          );
                          return;
                        }

                        await app.saveFuel(
                          FuelEntry(
                            id: _editing?.id,
                            odometer: odometer,
                            date: _date,
                            liters: liters,
                            amount: amount,
                            mileage: mileage,
                          ),
                        );
                        _clearForm();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry saved')));
                        }
                      },
                      child: Text(_editing == null ? 'Save entry' : 'Update entry'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text('Recent entries', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...app.fuelEntries.take(5).map(
                (entry) => Card(
                  child: ListTile(
                    title: Text('${DateFormat.yMMMd().format(entry.date)} • ${entry.odometer.toStringAsFixed(1)} km'),
                    subtitle: Text('₹${entry.amount.toStringAsFixed(0)} • ${entry.liters}L • ${entry.mileage.toStringAsFixed(2)} km/l'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _editing = entry;
                              _odo.text = entry.odometer.toStringAsFixed(0);
                              _liters.text = entry.liters.toString();
                              _amount.text = entry.amount.toString();
                              _date = entry.date;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => app.removeFuel(entry.id!),
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

  void _clearForm() {
    setState(() {
      _editing = null;
      _odo.clear();
      _liters.clear();
      _amount.clear();
      _date = DateTime.now();
    });
  }
}
