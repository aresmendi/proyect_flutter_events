// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../provider/events_service.dart';
import '../widgets/image_loader.dart';
import 'event_edit_screen.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.event});

  final Event event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.event.isFavorite;
  }

  void _toggleFavorite() async {
    await context.read<EventsService>().toggleFavorite(widget.event);
    setState(() {
      isFavorite = widget.event.isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Añadido a favoritos' : 'Eliminado de favoritos',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${widget.event.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final service = context.read<EventsService>();
              final result = await service.removeEvent(widget.event.id!);

              if (result != null && mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Evento eliminado correctamente'),
                  ),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${service.lastError}')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _editEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditScreen(event: widget.event),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: _editEvent,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar',
            onPressed: _deleteEvent,
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
            tooltip: 'Favorito',
            onPressed: _toggleFavorite,
          ),
        ],
      ),

      // 👇 AQUÍ está la magia
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 800;

          return SingleChildScrollView(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen (desktop)
                      Expanded(
                        flex: 4,
                        child: _buildImage(),
                      ),
                      // Info
                      Expanded(
                        flex: 6,
                        child: _buildInfo(context),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Imagen (móvil)
                      _buildImage(),
                      _buildInfo(context),
                    ],
                  ),
          );
        },
      ),
    );
  }

  /// Imagen del evento (usa ImageLoader)
  Widget _buildImage() {
    if (widget.event.image.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: const Icon(Icons.image_outlined, size: 100),
      );
    }

    return SizedBox(
      height: 300,
      child: ImageLoader(
        event: widget.event,
        size: double.infinity,
      ),
    );
  }

  /// Información del evento
  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd/MM/yyyy').format(widget.event.date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.euro, size: 20),
              const SizedBox(width: 8),
              Text(
                NumberFormat.currency(
                  locale: 'es',
                  symbol: '€',
                ).format(widget.event.price),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Descripción',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.event.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
