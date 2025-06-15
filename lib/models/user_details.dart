class UserDetails {
  final String role;
  final String team;

  UserDetails({required this.role, required this.team});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      role: json['role'] ?? '',
      team: json['team'] ?? '',
    );
  }
}
