// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/events_service.dart';
import '../provider/selected_event_notifier.dart';
import '../models/event.dart';
import '../widgets/event_list.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventList(
        onTapCallBack: (Event event) {
          // Marca el evento como seleccionado
          context.read<SelectedEventNotifier>().selectedEvent = event;
          
          // Navega a la pantalla de detalle
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          ).then((_) {
            // Limpia la selección al volver
            context.read<SelectedEventNotifier>().clear();
            // Actualiza la lista
            context.read<EventsService>().updateEvents();
          });
        },
      ),
    );
  }
}