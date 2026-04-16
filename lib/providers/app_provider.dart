import 'dart:math';

import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/fuel_entry.dart';
import '../models/service_entry.dart';

class AppProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<FuelEntry> fuelEntries = [];
  List<ServiceEntry> serviceEntries = [];

  bool loading = true;

  Future<void> loadAll() async {
    loading = true;
    notifyListeners();
    fuelEntries = await _db.getFuelEntries();
    serviceEntries = await _db.getServiceEntries();
    loading = false;
    notifyListeners();
  }

  FuelEntry? get latestFuel => fuelEntries.isEmpty ? null : fuelEntries.first;

  double get avgMileage {
    if (fuelEntries.isEmpty) return 0;
    final total = fuelEntries.fold<double>(0, (sum, e) => sum + e.mileage);
    return total / fuelEntries.length;
  }

  double get bestMileage {
    if (fuelEntries.isEmpty) return 0;
    return fuelEntries.map((e) => e.mileage).reduce(max);
  }

  double distanceFromLast(double currentOdometer) {
    final last = latestFuel;
    if (last == null) return 0;
    return max(0, currentOdometer - last.odometer);
  }

  double estimatedMileage(double currentOdometer) {
    final dist = distanceFromLast(currentOdometer);
    if (dist == 0) return avgMileage;
    return avgMileage;
  }

  Future<void> saveFuel(FuelEntry entry) async {
    await _db.upsertFuelEntry(entry);
    await loadAll();
  }

  Future<void> removeFuel(int id) async {
    await _db.deleteFuelEntry(id);
    await loadAll();
  }

  Future<void> saveService(ServiceEntry entry) async {
    await _db.upsertServiceEntry(entry);
    await loadAll();
  }

  Future<void> removeService(int id) async {
    await _db.deleteServiceEntry(id);
    await loadAll();
  }

  ServiceEntry? get latestService => serviceEntries.isEmpty ? null : serviceEntries.first;

  String serviceStatus(double currentOdometer) {
    final service = latestService;
    if (service == null) return 'No service record yet';
    final remaining = service.nextDue - currentOdometer;
    if (remaining <= 0) return 'Service overdue';
    if (remaining <= 300) return 'Service due soon';
    return 'Service healthy';
  }
}
