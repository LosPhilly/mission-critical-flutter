import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // VIOLATION: Infrastructure in UI
import 'dart:convert';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // VIOLATION: Mutable state inside the Widget (MCF Rule 4.1.1)
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  // VIOLATION: Business Logic & Data Access inside the UI (MCF Rule 2.1.2)
  Future<void> _fetchUser() async {
    try {
      final response = await http.get(Uri.parse('https://api.example.com/me'));
      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      // VIOLATION: Silent failure / ad-hoc error handling
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const CircularProgressIndicator();

    // VIOLATION: Domain Logic (isAdmin check) embedded in UI (MCF Rule 2.7)
    final bool isAdmin = _userData?['role'] == 'ADMIN';

    return Scaffold(
      body: Column(
        children: [
          Text(_userData?['name'] ?? 'Unknown'),
          if (isAdmin) const Icon(Icons.shield), // Logic leaking into View
        ],
      ),
    );
  }
}
