// ignore_for_file: strict_top_level_inference

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../provider/favorites_services.dart';
import 'package:http/http.dart' as http;

class EventsService extends ChangeNotifier {
  static const int timeout = 3;
  static const String host = 'localhost';
  static const int port = 3000;
  static const String path = '/eventos';

  List<Event> events = [];
  List<Event> filteredEvents = [];
  String lastError = '';
  bool _loading = false;

  String searchFilter = '';
  bool? sortDateEvents;
  bool? sortPriceEvents;
  bool? showLastEvents;
  bool? showFavoritesEvents;

  bool get loading => _loading;

  EventsService() {
    updateEvents();
  }

  updateEvents() {
    getEvents().then((value) {
      events = value;
      filteredEvents = value;
      applyFilters();
    });
  }

  Future<void> toggleFavorite(Event event) async {
    event.isFavorite = !event.isFavorite;
    
    if (event.isFavorite) {
      await FavoritesService.addFavorite(event.id!);
    } else {
      await FavoritesService.removeFavorite(event.id!);
    }
    
    notifyListeners();
  }

  ///GET ALL
  Future<List<Event>> getEvents() async {
    setError('');
    _loading = true;
    notifyListeners();
    try {
      final uri = Uri.parse('http://$host:$port$path');
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List jsonList = jsonDecode(response.body);
        List<Event> events = [];

        final favoriteIds = await FavoritesService.getFavorites();

        for (var item in jsonList) {
          Event event = Event.fromJson(item);
          event.isFavorite = favoriteIds.contains(event.id);
          events.add(event);
        }
        this.events = events;
        _loading = false;
        notifyListeners();
        return events;
      } else {
        setError('Error al obtener listado de eventos. ${response.statusCode}');
        _loading = false;
        return [];
      }
    } catch (e) {
      setError('Error al obtener listado de eventos. $e');
      _loading = false;
      return events;
    }
  }


  //POST
  Future<Event?> addEvent(Event event) async {
    _loading = true;
    setError('');
    notifyListeners();
    try {
      final uri = Uri.parse('http://$host:$port$path');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(event),
          )
          .timeout(const Duration(seconds: timeout));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _loading = false;
        return Event.fromJson(jsonDecode(response.body));
      } else {
        setError('Error al crear evento. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al crear el evento. $e');
      _loading = false;
      return null;
    }
  }

  //Delete
  Future<Event?> removeEvent(String id) async {
    _loading = true;
    setError('');
    try {
      final uri = Uri.parse('http://$host:$port$path/$id');
      final response = await http
          .delete(uri)
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await FavoritesService.removeFavorite(id);
        _loading = false;
        return Event.fromJson(jsonDecode(response.body));
      } else {
        setError('Error al borrar evento. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al borrar evento. $e');
      _loading = false;
      return null;
    }
  }

  //Get por id
  Future<Event?> getEvent(String id) async {
    _loading = true;
    setError('');
    notifyListeners();

    try {
      final uri = Uri.parse('http://$host:$port$path/$id');
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _loading = false;
        Event event = Event.fromJson(jsonDecode(response.body));
        event.isFavorite = await FavoritesService.isFavorite(event.id!);
        return event;
      } else {
        setError('Error al obtener evento. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al obtener evento. $e');
      _loading = false;
      return null;
    }
  }

  //Put
  Future<Event?> modifyEvent(Event event) async {
    _loading = true;
    setError('');
    notifyListeners();
    try {
      final uri = Uri.parse('http://$host:$port$path/${event.id}');
      final response = await http
          .put(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(event),
          )
          .timeout(const Duration(seconds: timeout));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _loading = false;
        return Event.fromJson(jsonDecode(response.body));
      } else {
        setError('Error al modificar el evento. ${response.statusCode}');
        _loading = false;
        return null;
      }
    } catch (e) {
      setError('Error al modificar el evento. $e');
      _loading = false;
      return null;
    }
  }

  void setError(String error) {
    lastError = error;
  }

  filterEvents(String value) {
    searchFilter = value;
    applyFilters();
  }

  showLast() {
    showLastEvents = showLastEvents == null ? true : !showLastEvents!;
    applyFilters();
  }

  showFavorites() {
    showFavoritesEvents = showFavoritesEvents == null
        ? true
        : !showFavoritesEvents!;
    applyFilters();
  }

  sortDate() {
    sortDateEvents = sortDateEvents == null ? true : !sortDateEvents!;
    resetSortPrice();
    applyFilters();
  }

  sortPrice() {
    sortPriceEvents = sortPriceEvents == null ? true : !sortPriceEvents!;
    resetSortDate();
    applyFilters();
  }

  resetSortDate() => sortDateEvents = null;
  resetSortPrice() => sortPriceEvents = null;

  applyFilters() {
    filteredEvents = events
        .where(
          (element) => element.description.toLowerCase().contains(
            searchFilter.toLowerCase(),
          ),
        )
        .toList();
    if (sortDateEvents != null) {
      filteredEvents.sort((a, b) => a.date.compareTo(b.date));
    }
    if (sortPriceEvents != null) {
      filteredEvents.sort((a, b) => a.price.compareTo(b.price));
    }
    if (showFavoritesEvents != null) {
      filteredEvents = filteredEvents
          .where((event) => event.isFavorite)
          .toList();
    }
    if (showLastEvents != null) {
      filteredEvents = filteredEvents
          .where((event) => event.date.isAfter(DateTime.now()))
          .toList();
    }
    notifyListeners();
  }
}
