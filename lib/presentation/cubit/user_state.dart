/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */
import 'package:equatable/equatable.dart'; // 1. Add this package
import 'package:flightapp/domain/entities/user.dart';

// 2. Extend Equatable to enable value comparison
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => []; // Default empty props
}

// State 1: Initial
class UserInitial extends UserState {
  const UserInitial();
}

// State 2: Loading
class UserLoading extends UserState {
  const UserLoading();
}

// State 3: Success
class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);

  // 3. Include data in props so UserLoaded(A) == UserLoaded(A)
  @override
  List<Object?> get props => [user];
}

// State 4: Failure
class UserError extends UserState {
  final String message;
  const UserError(this.message);

  // 4. Include message in props so errors compare correctly
  @override
  List<Object?> get props => [message];
}
