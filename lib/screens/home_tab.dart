import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_mobile/auth/user.dart';
import 'package:front_mobile/services/api_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? role;
  String? team;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userProvider = context.read<UserProvider>();
    final userId = userProvider.userId;
    if (userId == null) return;

    try {
      final userDetails = await ApiService().getUserDetails(userId.toString());
      if (!mounted) return;

      setState(() {
        role = userDetails.role;
        team = userDetails.team;
      });
    } catch (e) {
  debugPrint('Erreur lors du chargement des détails utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.userName ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<UserProvider>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, $userName!", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            if (role != null) Text("Role: $role"),
            if (team != null) Text("Team: $team"),
          ],
        ),
      ),
    );
  }
}
