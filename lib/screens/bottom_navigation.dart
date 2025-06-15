import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_mobile/models/space_provider.dart';
import 'package:front_mobile/screens/home_tab.dart';
import 'package:front_mobile/screens/my_bookings_screen.dart';
import 'package:front_mobile/screens/floor_map_screen.dart'; 

import 'package:front_mobile/auth/user.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSpaces();
  }

  Future<void> _loadSpaces() async {
    final spaceProvider = context.read<SpaceProvider>();
    try {
      await spaceProvider.fetchSpaces();
      setState(() {
        _loading = false;
      });
    } catch (e) {
      debugPrint('Failed to load spaces: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userId = userProvider.userId;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> screens = [
      const HomeTab(),

      const FloorMapScreen(),

      if (userId != null)
        MyBookingsScreen(userId: userId)
      else
        const Center(child: Text("Please login")),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Floor Map"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "My Bookings"),
        ],
      ),
    );
  }
}
