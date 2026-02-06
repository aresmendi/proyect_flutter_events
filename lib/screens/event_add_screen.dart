import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/event.dart';
import '../provider/events_service.dart';

class EventAdd extends StatefulWidget {
  const EventAdd({super.key});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  
  DateTime _selectedDate = DateTime.now();
  String _imagePath = '';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        price: double.tryParse(_priceController.text) ?? 0.0,
        image: _imagePath,
      );

      final service = context.read<EventsService>();
      final result = await service.addEvent(event);

      if (result != null && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento creado correctamente')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${service.lastError}')),
        );
      }
    }
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar cambios'),
        content: const Text('¿Estás seguro de que quieres descartar los cambios?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pop(context); // Vuelve al listado
            },
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo evento'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showDiscardDialog,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Campo Título
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título es obligatorio';
                      }
                      if (value.length < 5 || value.length > 50) {
                        return 'El título debe tener entre 5 y 50 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
            
                  // Campo Descripción
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length < 5 || value.length > 255) {
                          return 'La descripción debe tener entre 5 y 255 caracteres';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
            
                  // Selector de Fecha
                  ListTile(
                    title: const Text('Fecha *'),
                    subtitle: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(height: 16),
            
                  // Campo Precio
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Precio *',
                      border: OutlineInputBorder(),
                      suffixText: '€',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El precio es obligatorio';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return 'El precio debe ser un número positivo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
            
                  // Selector de Imagen
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Seleccionar imagen'),
                  ),
                  const SizedBox(height: 16),
            
                  // Vista previa de la imagen
                  if (_imagePath.isNotEmpty)
                    Column(
                      children: [
                        Image.network(
                          _imagePath,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 50),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
            
                  const SizedBox(height: 24),
            
                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Crear'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _showDiscardDialog,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Descartar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}