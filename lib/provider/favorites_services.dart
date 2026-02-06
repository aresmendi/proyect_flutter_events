import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_events';

  // Obtener lista de IDs de favoritos
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Guardar lista de IDs de favoritos
  static Future<void> saveFavorites(List<String> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favoriteIds);
  }

  // Añadir un favorito
  static Future<void> addFavorite(String eventId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(eventId)) {
      favorites.add(eventId);
      await saveFavorites(favorites);
    }
  }

  // Eliminar un favorito
  static Future<void> removeFavorite(String eventId) async {
    final favorites = await getFavorites();
    favorites.remove(eventId);
    await saveFavorites(favorites);
  }

  // Verificar si un evento es favorito
  static Future<bool> isFavorite(String eventId) async {
    final favorites = await getFavorites();
    return favorites.contains(eventId);
  }

  // Limpiar todos los favoritos
  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}