import 'dart:io';
import 'package:flutter/material.dart';
import '../models/event.dart';

class ImageLoader extends StatelessWidget{
  const ImageLoader({super.key,
    required this.event,
    required this.size});
    
    final Event event;
    final double size;
  
   @override
  Widget build(BuildContext context) {
    if (event.image.isEmpty) {
      return Icon(Icons.image_outlined, size: size);
    }

    if (Uri.parse(event.image).isAbsolute) {
      // Si la imagen es una URL, se carga desde la red
      return Image.network(event.image,
          loadingBuilder: buildLoader,
          frameBuilder: buildImage,
          errorBuilder: buildError,
          fit: BoxFit.cover,
          width: size,
          height: size);
    } else {
      // Si la imagen es una ruta local, se carga desde el dispositivo
      return Image.file(File(event.image),
          frameBuilder: buildImage,
          errorBuilder: buildError,
          fit: BoxFit.cover,
          width: size,
          height: size);
    }
  }

  /// Muestra un indicador de progreso
  Widget buildLoader(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    final totalBytes = loadingProgress?.expectedTotalBytes;
    final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
    if (totalBytes != null && bytesLoaded != null) {
      return CircularProgressIndicator(
        backgroundColor: Colors.white70,
        value: bytesLoaded / totalBytes,
        color: Colors.blue[900],
        strokeWidth: 5.0,
      );
    } else {
      return child;
    }
  }

  /// Muestra un icono de error
  Widget buildError(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return Icon(
      Icons.image_not_supported_outlined,
      semanticLabel: 'Error al cargar la imagen',
      size: size,
      color: Colors.red[200],
    );
  }

  /// Muestra la imagen con una animación de entrada
  Widget buildImage(BuildContext context, Widget child, int? frame,
      bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: child,
    );
  }
}