# Fuel & Service Tracker (Flutter)

Offline-first Android app for tracking petrol fills, mileage trends, and service schedule.

## Features
- Odometer dashboard with distance + mileage estimate
- Add/Edit/Delete petrol entries with auto mileage and price/litre
- History list + mileage trend chart
- Service tracker with due-soon/overdue alerts
- Dark mode support, smooth Material 3 UI
- Local-only storage using SQLite (`sqflite`)

## Run
```bash
flutter pub get
flutter run
```

## Build APK
```bash
flutter build apk --release
```
APK output path:
`build/app/outputs/flutter-apk/app-release.apk`

## Notes
- Works fully offline.
- No paid APIs or subscriptions.
