import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/add_entry_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/service_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FuelTrackerApp());
}

class FuelTrackerApp extends StatelessWidget {
  const FuelTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..loadAll(),
      child: MaterialApp(
        title: 'Fuel & Service Tracker',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const RootScreen(),
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    AddEntryScreen(),
    HistoryScreen(),
    ServiceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _screens[_index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.speed), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.local_gas_station), label: 'Add Entry'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'History'),
          NavigationDestination(icon: Icon(Icons.build_circle), label: 'Service'),
        ],
      ),
    );
  }
}
