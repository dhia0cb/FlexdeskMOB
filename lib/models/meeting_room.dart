import '../widgets/space_enum.dart';

class MeetingRoom {
  final int id;
  final String name;
  final int size;
  final List<String> equipmentAvailable;
  final Type? type; 
  final Status status;
  final double? x;
  final double? y;
  final int? floorId;

  const MeetingRoom({
    required this.id,
    required this.name,
    required this.size,
    required this.equipmentAvailable,
    required this.type,
    required this.status,
    this.x,
    this.y,
    this.floorId,
  });

  factory MeetingRoom.fromJson(Map<String, dynamic> json) {
    return MeetingRoom(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Room',
      size: json['size'] ?? 0,
      equipmentAvailable: List<String>.from(json['equipmentAvailable'] ?? []),
      type: _parseType(json['type']),
      status: _parseStatus(json['status']),
      x: (json['x'] is int) ? json['x'].toDouble() : json['x'],
      y: (json['y'] is int) ? json['y'].toDouble() : json['y'],
      floorId: json['floorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'equipmentAvailable': equipmentAvailable,
      'type': type?.name,
      'status': status.name,
      'x': x,
      'y': y,
      'floorId': floorId,
    };
  }

  static Type _parseType(dynamic value) {
    if (value == null) return Type.private;
    if (value is String) {
      if (value.toLowerCase() == 'public') return Type.public;
      return Type.private;
    }
    return Type.private;
  }

  static Status _parseStatus(dynamic value) {
    if (value == null) return Status.open;
    if (value is String) {
      if (value.toLowerCase() == 'open') return Status.open;
      if (value.toLowerCase() == 'close' || value.toLowerCase() == 'closed') return Status.close;
    }
    return Status.open;
  }

  MeetingRoom copyWith({
    int? id,
    String? name,
    int? size,
    List<String>? equipmentAvailable,
    Type? type,
    Status? status,
    double? x,
    double? y,
    int? floorId,
  }) {
    return MeetingRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      equipmentAvailable: equipmentAvailable ?? [...this.equipmentAvailable],
      type: type ?? this.type,
      status: status ?? this.status,
      x: x ?? this.x,
      y: y ?? this.y,
      floorId: floorId ?? this.floorId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingRoom &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}