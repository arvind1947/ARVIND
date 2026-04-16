class FuelEntry {
  FuelEntry({
    this.id,
    required this.odometer,
    required this.date,
    required this.liters,
    required this.amount,
    required this.mileage,
  });

  int? id;
  double odometer;
  DateTime date;
  double liters;
  double amount;
  double mileage;

  double get pricePerLiter => liters == 0 ? 0 : amount / liters;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'odometer': odometer,
      'date': date.toIso8601String(),
      'liters': liters,
      'amount': amount,
      'mileage': mileage,
    };
  }

  factory FuelEntry.fromMap(Map<String, dynamic> map) {
    return FuelEntry(
      id: map['id'] as int?,
      odometer: (map['odometer'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      liters: (map['liters'] as num).toDouble(),
      amount: (map['amount'] as num).toDouble(),
      mileage: (map['mileage'] as num).toDouble(),
    );
  }
}
