class Booking {
  final int id;
  final String startTime;
  final String endTime;
  final String spaceType;
  final dynamic space; 
  final String? status;
  final int spaceId;
  final int userId;
  final int bookFor;

  const Booking({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.spaceType,
    this.space,
    this.status,
    required this.spaceId,
    required this.userId,
    required this.bookFor,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      spaceType: json['spaceType'],
      space: json['desk'] ?? json['meetingRoom'],
      status: json['status'],
      spaceId: json['spaceId'],
      userId: json['userId'],
      bookFor: json['bookFor'],
    );
  }
}