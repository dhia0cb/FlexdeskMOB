import 'package:flutter/material.dart';
import 'package:front_mobile/services/api_service.dart';
import 'package:front_mobile/models/user.dart';
import 'package:front_mobile/widgets/space_type_enum.dart'; // only this is needed

class BookingFormScreen extends StatefulWidget {
  final String spaceType;
  final int spaceId;

  const BookingFormScreen({
    super.key,
    required this.spaceType,
    required this.spaceId,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  List<User> users = [];
  int? selectedUserId;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final fetchedUsers = await ApiService().fetchUsers();
      if (!mounted) return;
      setState(() {
        users = fetchedUsers;
        selectedUserId = users.isNotEmpty ? users.first.id : null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load users: $e")),
      );
    }
  }

  String getFormattedTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  SpaceType parseSpaceType(String type) {
    switch (type.toLowerCase()) {
      case 'desk':
        return SpaceType.desk;
      case 'meeting_room':
        return SpaceType.meetingRoom;
      default:
        throw Exception("Invalid space type: $type");
    }
  }

  void _submitBooking() async {
    if (selectedUserId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a user to book for.")),
      );
      return;
    }

    final startTime = getFormattedTime(selectedStartTime);
    final endTime = getFormattedTime(selectedEndTime);
    final SpaceType convertedSpaceType = parseSpaceType(widget.spaceType);

    try {
      await ApiService().bookSpace(
        selectedUserId!,
        selectedUserId!,
        convertedSpaceType,
        widget.spaceId,
        startTime,
        endTime,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booked successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking failed: $e")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (!mounted || picked == null) return;
    setState(() => selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: isStart ? selectedStartTime : selectedEndTime,
    );
    if (!mounted || newTime == null) return;
    setState(() {
      if (isStart) {
        selectedStartTime = newTime;
      } else {
        selectedEndTime = newTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book a Space")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: selectedUserId,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedUserId = value);
                }
              },
              items: users.map((user) {
                return DropdownMenuItem<int>(
                  value: user.id,
                  child: Text("User ${user.id}"), // ← changed here
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Select User"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Date: "),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Start Time: "),
                TextButton(
                  onPressed: () => _selectTime(context, true),
                  child: Text(getFormattedTime(selectedStartTime)),
                ),
              ],
            ),
            Row(
              children: [
                const Text("End Time: "),
                TextButton(
                  onPressed: () => _selectTime(context, false),
                  child: Text(getFormattedTime(selectedEndTime)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitBooking,
              child: const Text("Book Now"),
            ),
          ],
        ),
      ),
    );
  }
}
