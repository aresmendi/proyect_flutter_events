import 'package:flutter/material.dart';
import 'package:proyect_flutter_events/widgets/image_loader.dart';
import '../provider/selected_event_notifier.dart';
import '../provider/events_service.dart';  // ⬅️ AÑADE ESTO
import '../models/event.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatefulWidget {
  const EventListItem({
    super.key,
    required this.event,
    required this.onTapCallBack,
  });
  final Event event;
  final Function(Event) onTapCallBack;

  @override
  State<EventListItem> createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  @override
  Widget build(BuildContext context) {
    bool selected =
        context.watch<SelectedEventNotifier>().selectedEvent == widget.event;
    
    return ListTile(
      onTap: () => {widget.onTapCallBack(widget.event)},
      style: ListTileStyle.drawer,
      selected: selected,
      leading: ImageLoader(event: widget.event, size: 50),
      title: Text(
        widget.event.title,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w500,
        ),
      ),
      focusColor: Colors.grey[300],
      selectedTileColor: Colors.blue[100],
      hoverColor: Colors.grey[300],
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.event.description,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('dd/MM/yyyy').format(widget.event.date),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            NumberFormat.currency(locale: 'es', symbol: '€').format(widget.event.price),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () async {
          await context.read<EventsService>().toggleFavorite(widget.event);
          setState(() {});
        },
        icon: Icon(
          widget.event.isFavorite ? Icons.star : Icons.star_border,
          color: widget.event.isFavorite ? Colors.amber : Colors.grey,
        ),
        tooltip: 'Favoritos',
      ),
    );
  }
}