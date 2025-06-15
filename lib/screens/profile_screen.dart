import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/my_bookings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("${user.firstName} ${user.lastName}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(user.role, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBookingsScreen(userId: 6)),
                );
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text("My Bookings"),
            ),
          ],
        ),
      ),
    );
  }
}