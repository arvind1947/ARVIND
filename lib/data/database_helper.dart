import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/fuel_entry.dart';
import '../models/service_entry.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'fuel_service_tracker.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE fuel_entries(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            odometer REAL NOT NULL,
            date TEXT NOT NULL,
            liters REAL NOT NULL,
            amount REAL NOT NULL,
            mileage REAL NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE service_entries(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            odometer REAL NOT NULL,
            date TEXT NOT NULL,
            interval REAL NOT NULL DEFAULT 2500
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<FuelEntry>> getFuelEntries() async {
    final db = await database;
    final rows = await db.query('fuel_entries', orderBy: 'date DESC');
    return rows.map(FuelEntry.fromMap).toList();
  }

  Future<int> upsertFuelEntry(FuelEntry entry) async {
    final db = await database;
    if (entry.id == null) {
      return db.insert('fuel_entries', entry.toMap());
    }
    return db.update('fuel_entries', entry.toMap(), where: 'id=?', whereArgs: [entry.id]);
  }

  Future<int> deleteFuelEntry(int id) async {
    final db = await database;
    return db.delete('fuel_entries', where: 'id=?', whereArgs: [id]);
  }

  Future<List<ServiceEntry>> getServiceEntries() async {
    final db = await database;
    final rows = await db.query('service_entries', orderBy: 'date DESC');
    return rows.map(ServiceEntry.fromMap).toList();
  }

  Future<int> upsertServiceEntry(ServiceEntry entry) async {
    final db = await database;
    if (entry.id == null) {
      return db.insert('service_entries', entry.toMap());
    }
    return db.update('service_entries', entry.toMap(), where: 'id=?', whereArgs: [entry.id]);
  }

  Future<int> deleteServiceEntry(int id) async {
    final db = await database;
    return db.delete('service_entries', where: 'id=?', whereArgs: [id]);
  }
}
