
import '../widgets/space_enum.dart';

class Desk {
  final int id;
  final String checkinReference;
  final Type type; 
  final Status status; 
  final double? x;
  final double? y;
  final int? floorId;

  Desk({
    required this.id,
    required this.checkinReference,
    this.type = Type.public, 
    this.status = Status.open, 
    this.x,
    this.y,
    this.floorId,
  });

  factory Desk.fromJson(Map<String, dynamic> json) {
    return Desk(
      id: json['id'],
      checkinReference: json['checkinReference'] ?? '',
      type: _parseType(json['type']),
      status: _parseStatus(json['status']),
      x: json['x'] is num ? json['x'].toDouble() : null,
      y: json['y'] is num ? json['y'].toDouble() : null,
      floorId: json['floorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkinReference': checkinReference,
      'type': type.name,
      'status': status.name,
      'x': x,
      'y': y,
      'floorId': floorId,
    };
  }

  static Type _parseType(dynamic value) {
    if (value == null) return Type.public;
    if (value is String) {
      if (value.toLowerCase() == 'private') return Type.private;
      return Type.public;
    }
    return Type.public;
  }

  static Status _parseStatus(dynamic value) {
    if (value == null) return Status.open;
    if (value is String) {
      if (value.toLowerCase() == 'close' || value.toLowerCase() == 'closed') {
        return Status.close;
      }
      return Status.open;
    }
    return Status.open;
  }
 Desk copyWith({
    int? id,
    String? checkinReference,
    Type? type,
    Status? status,
    double? x,
    double? y,
    int? floorId,
  }) {
    return Desk(
      id: id ?? this.id,
      checkinReference: checkinReference ?? this.checkinReference,
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
      other is Desk &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}