class Event {
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String descriptionKey = 'description';
  static const String dateKey = 'date';
  static const String priceKey = 'price';
  static const String imageKey = 'image';
  static String isFavoriteKey = 'isFavorite';

  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final double price;
  final String image;
  bool isFavorite;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    required this.image,
    this.isFavorite = false,
  });

  Event.fromJson(Map<String, dynamic> json)
    : id = json[idKey],
      title = json[titleKey] != null ? json[titleKey].toString() : 'Sin título',
      description = json[descriptionKey] != null
          ? json[descriptionKey].toString()
          : 'Sin descripción',
      date = json[dateKey] != null
          ? DateTime.parse(json[dateKey].toString())
          : DateTime.now(),
      price = double.tryParse(json[priceKey].toString()) ?? 0.0,
      image = json[imageKey] != null ? json[imageKey].toString() : '',
      isFavorite = false;

  Map<String, dynamic> toJson() {
    if (id == null) {
      return {
        titleKey: title,
        descriptionKey: description,
        dateKey: date.toIso8601String(),
        priceKey: price,
        imageKey: image,
        isFavoriteKey: isFavorite,
      };
    } else {
      return {
        idKey: id,
        titleKey: title,
        descriptionKey: description,
        dateKey: date.toIso8601String(),
        priceKey: price,
        imageKey: image,
        isFavoriteKey: isFavorite,
      };
    }
  }
}
