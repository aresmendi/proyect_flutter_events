import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import 'image_loader.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    super.key,
    required this.event,
    required this.selected,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Event event;
  final bool selected;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: selected ? 6 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // evita que la imagen sobresalga
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen arriba
            AspectRatio(
              aspectRatio: 16 / 9, // Esto fuerza que la imagen tenga tamaño definido
              child: ImageLoader(event: event, size: 180),
            ),

            // Info abajo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Descripción
                  Text(
                    event.description.isEmpty
                        ? 'Sin descripción'
                        : event.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Fecha y precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(event.date),
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'es', symbol: '€')
                            .format(event.price),
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Botón favoritos al final, alineado a la derecha
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Favoritos',
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
