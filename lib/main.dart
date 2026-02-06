import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/events_service.dart';
import 'provider/selected_event_notifier.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventsService()),
        ChangeNotifierProvider(create: (_) => SelectedEventNotifier()),
      ],
      child: MaterialApp(
        title: 'Gestión de Eventos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}