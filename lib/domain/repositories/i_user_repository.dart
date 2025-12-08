/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */
// File: lib/domain/repositories/i_user_repository.dart
// Dart
import 'package:flightapp/domain/entities/user.dart';

// Abstract Contract.
// The Domain defines WHAT it needs, not HOW to get it.
abstract class IUserRepository {
  Future<User> getUserProfile();
}
