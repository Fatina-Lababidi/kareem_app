class PlaceEntity {
  final int id;
  final String name;
  final num latitude;
  final num longitude;
  final String description;
  PlaceEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
  });
}

class AllHubEntity {
  final String message;
  final String status;
  final List<PlaceEntity> body;
  AllHubEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}
