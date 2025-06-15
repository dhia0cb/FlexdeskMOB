import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'desk.dart';
import 'meeting_room.dart';

const String apiUrl = 'http://10.0.2.2:5000/api';

class SpaceProvider with ChangeNotifier {
  List<Desk> _desks = [];
  List<MeetingRoom> _meetingRooms = [];
  List<int> _bookedDeskIds = [];
  List<int> _bookedRoomIds = [];
  List<Map<String, dynamic>> _users = [];

  List<Desk> get desks => _desks;
  List<MeetingRoom> get meetingRooms => _meetingRooms;
  List<int> get bookedDeskIds => _bookedDeskIds;
  List<int> get bookedRoomIds => _bookedRoomIds;
  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchSpaces() async {
    try {
      final deskUrl = Uri.parse('$apiUrl/desks');
      final meetUrl = Uri.parse('$apiUrl/meetrooms');
      final bookedUrl = Uri.parse('$apiUrl/bookings');
      final usersUrl = Uri.parse('$apiUrl/users');

      final responses = await Future.wait([
        http.get(deskUrl),
        http.get(meetUrl),
        http.get(bookedUrl),
        http.get(usersUrl),
      ]);

      if (responses.any((res) => res.statusCode != 200)) {
        throw Exception("Failed to load some resources");
      }

      final deskData = jsonDecode(responses[0].body) as List;
      final meetData = jsonDecode(responses[1].body) as List;
      final bookedData = jsonDecode(responses[2].body) as List;
      final usersData = jsonDecode(responses[3].body) as List;

      _desks = deskData.map((e) => Desk.fromJson(e)).toList();
      _meetingRooms = meetData.map((e) => MeetingRoom.fromJson(e)).toList();
      _bookedDeskIds = bookedData
          .where((e) => e['spaceType'] == 'desk')
          .map<int>((e) => e['spaceId'] as int)
          .toList();
      _bookedRoomIds = bookedData
          .where((e) => e['spaceType'] == 'meeting_room')
          .map<int>((e) => e['spaceId'] as int)
          .toList();
      _users = usersData.cast<Map<String, dynamic>>();

      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching spaces: $e");
    }
  }

  Future<void> addDesk(Desk desk) async {
    try {
      final url = Uri.parse('$apiUrl/desks');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(desk.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newDesk = Desk.fromJson(responseData);
        _desks.add(newDesk);
        notifyListeners();
      } else {
        throw Exception('Failed to add desk: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding desk: $e');
    }
  }

  Future<void> addMeetingRoom(MeetingRoom room) async {
    try {
      final url = Uri.parse('$apiUrl/meetrooms');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(room.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newRoom = MeetingRoom.fromJson(responseData);
        _meetingRooms.add(newRoom);
        notifyListeners();
      } else {
        throw Exception('Failed to add meeting room: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding meeting room: $e');
    }
  }

  Future<void> bookSpace({
  required int userId,
  required String spaceType,
  required int spaceId,
  required String from,
  required String to,
}) async {
  // Validate time range
  final start = DateTime.tryParse(from);
  final end = DateTime.tryParse(to);

  if (start == null || end == null) {
    throw Exception("Invalid date format.");
  }
  if (!start.isBefore(end)) {
    throw Exception("Start time must be before end time.");
  }

  final url = Uri.parse('$apiUrl/bookings');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      'spaceType': spaceType,
      'spaceId': spaceId,
      'startTime': from,
      'endTime': to,
    }),
  );

  if (response.statusCode != 201 && response.statusCode != 200) {
    throw Exception("Booking failed: ${response.body}");
  }

  await fetchSpaces();
}
}