/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */
// File: lib/domain/entities/user.dart
// Pure Dart. No Flutter dependencies.
import 'address.dart';
import 'company.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.isAdmin,
    required this.address,
    required this.company,
  });
  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final bool isAdmin;

  // New Complex Types
  final Address address;
  final Company company;
}
