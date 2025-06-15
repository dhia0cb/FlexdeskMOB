class Building {
  final int id;
  final String name;
  final String address;
  final String? city;

  Building({
    required this.id,
    required this.name,
    required this.address,
    this.city,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Building',
      address: json['address'] ?? 'Unknown Address',
      city: json['city'] ?? 'Unknown city',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
    };
  }
}