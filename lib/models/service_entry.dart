class ServiceEntry {
  ServiceEntry({
    this.id,
    required this.odometer,
    required this.date,
    this.interval = 2500,
  });

  int? id;
  double odometer;
  DateTime date;
  double interval;

  double get nextDue => odometer + interval;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'odometer': odometer,
      'date': date.toIso8601String(),
      'interval': interval,
    };
  }

  factory ServiceEntry.fromMap(Map<String, dynamic> map) {
    return ServiceEntry(
      id: map['id'] as int?,
      odometer: (map['odometer'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      interval: (map['interval'] as num?)?.toDouble() ?? 2500,
    );
  }
}
