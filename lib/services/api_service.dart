import 'dart:convert';
import 'package:front_mobile/models/building.dart';
import 'package:front_mobile/models/floor.dart';
import 'package:front_mobile/models/user.dart';
import 'package:front_mobile/models/user_details.dart';
import '../widgets/space_enum.dart';
import 'package:http/http.dart' as http;
import '../models/desk.dart';
import '../models/meeting_room.dart';
import '../models/booking.dart';
import '../widgets/space_type_enum.dart';
import '../config.dart';

class ApiService {
  Future<List<Desk>> fetchDesks() async {
    final response = await http.get(Uri.parse(AppConfig.getDesks));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Desk.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load desks');
    }
  }

  Future<List<MeetingRoom>> fetchMeetingRooms() async {
    final response = await http.get(Uri.parse(AppConfig.getMeetingRooms));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => MeetingRoom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meeting rooms');
    }
  }

  Future<void> bookSpace(int userId, int bookFor, SpaceType spaceType, int spaceId, String startTime, String endTime) async {
    final response = await http.post(
      Uri.parse(AppConfig.bookSpace),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "userId": userId,
        "bookFor": bookFor,
        "spaceType": spaceType.name,
        "spaceId": spaceId,
        "startTime": startTime,
        "endTime": endTime
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Booking failed: ${response.body}');
    }
  }

  Future<User> loginUser(String email) async {
    final response = await http.get(Uri.parse("${AppConfig.getUsers}?email=$email"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        throw Exception("User not found");
      }
      return User.fromJson(data.first);
    } else {
      throw Exception("Login failed");
    }
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(AppConfig.getUsers));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
Future<UserDetails> getUserDetails(String userId) async {
  final response = await http.get(Uri.parse('YOUR_API_URL/users/$userId'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return UserDetails.fromJson(data);
  } else {
    throw Exception('Failed to load user details');
  }
}
  Future<List<Booking>> fetchBookingsByUserId(int userId) async {
    final response = await http.get(Uri.parse("${AppConfig.getBookings}?userId=$userId"));


    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load bookings");
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    final url = Uri.parse('${AppConfig.apiUrl}/bookings/$bookingId/cancel'); 
    final response = await http.post(url); 

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to cancel booking: ${response.body}');
    }
  }

  static Future<void> createDesk({
    required String type,
    required String status,
    required double x,
    required double y,
    required int floorId,
    required String checkinReference,
  }) async {
    final response = await http.post(
      Uri.parse(AppConfig.getDesks),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "type": type,
        "status": status,
        "x": x,
        "y": y,
        "floorId": floorId,
        "checkinReference": checkinReference,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add desk');
    }
  }

  static Future<void> createMeetingRoom({
    required String name,
    required int size,
    required List<String> equipmentAvailable,
    required Type type,
    required Status status,
    required double x,
    required double y,
    required int floorId,
  }) async {
    final response = await http.post(
      Uri.parse(AppConfig.getMeetingRooms),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "name": name,
        "size": size,
        "equipmentAvailable": equipmentAvailable,
        "type": type.name,
        "status": status.name,
        "x": x,
        "y": y,
        "floorId": floorId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add meeting room');
    }
  }

  Future<List<Building>> fetchBuildings() async {
    final response = await http.get(Uri.parse(AppConfig.getBuildings));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Building.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load buildings');
    }
  }

  Future<List<Floor>> fetchFloors() async {
    final response = await http.get(Uri.parse(AppConfig.getFloors));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Floor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load floors');
    }
  }
}
