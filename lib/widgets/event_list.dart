import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyect_flutter_events/provider/events_service.dart';
import 'package:proyect_flutter_events/provider/selected_event_notifier.dart';
import 'package:proyect_flutter_events/screens/event_add_screen.dart';
import '../models/event.dart';
import 'event_list_item.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.onTapCallBack});
  final Function(Event) onTapCallBack;
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool showFilters = false;

  bool? sortDateEvents;
  bool? sortPriceEvents;
  bool? showFavoritesEvents;
  bool? showLastEvents;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sortDateEvents = context.watch<EventsService>().sortDateEvents;
    sortPriceEvents = context.watch<EventsService>().sortPriceEvents;
    showFavoritesEvents = context.watch<EventsService>().showFavoritesEvents;
    showLastEvents = context.watch<EventsService>().showLastEvents;

    final service = context.watch<EventsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de eventos'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordenar Eventos',
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_outlined),
            tooltip: 'Nuevo Evento',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventAdd()),
              ).then((value) => {service.updateEvents()});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          if (showFilters)
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Favoritos'),
                  selected: showFavoritesEvents ?? false,
                  onSelected: (value) {
                    service.showFavorites();
                  },
                ),
                FilterChip(
                  label: const Text('Próximos'),
                  selected: showLastEvents ?? false,
                  onSelected: (value) {
                    service.showLast();
                  },
                ),
                FilterChip(
                  label: const Text('Ordenar por fecha'),
                  selected: sortDateEvents ?? false,
                  onSelected: (value) {
                    service.sortDate();
                  },
                ),
                FilterChip(
                  label: const Text('Ordenar por precio'),
                  selected: sortPriceEvents ?? false,
                  onSelected: (value) {
                    service.sortPrice();
                  },
                ),
              ],
            ),

          // Lista de eventos
          Expanded(
  child: service.loading
      ? const Center(child: CircularProgressIndicator())
      : service.filteredEvents.isEmpty
          ? const Center(child: Text('No hay eventos'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: service.filteredEvents.length,
              itemBuilder: (context, index) {
                final event = service.filteredEvents[index];
                final selectedEvent =
                    context.watch<SelectedEventNotifier>().selectedEvent;
                final bool selected =
                    selectedEvent != null && selectedEvent.id == event.id;

                return EventListItem(
                  event: event,
                  selected: selected,
                  onTap: () {
                    // Marca como seleccionado y dispara callback
                    context.read<SelectedEventNotifier>().selectedEvent = event;
                    widget.onTapCallBack(event);
                  },
                  isFavorite: event.isFavorite,
                  onFavoriteToggle: () {
                    context.read<EventsService>().toggleFavorite(event);
                  },
                );
              },
            ),
),
        ],
      ),
    );
  }
}
