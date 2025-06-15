class Floor {
  final int id;
  final String name;
  final int buildingId;

  Floor({
    required this.id,
    required this.name,
    required this.buildingId,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    int? buildingId = json['buildingId'] is int ? json['buildingId'] : null;

    if (buildingId == null && json['building'] != null) {
      Map<String, dynamic> buildingJson = json['building'];
      buildingId = buildingJson['id'] is int ? buildingJson['id'] : -1;
    }

    return Floor(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Floor',
      buildingId: buildingId ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'buildingId': buildingId,
    };
  }
}