/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */
// test\presentation\cubit\screens\profile_screen_test.dart
import 'package:bloc_test/bloc_test.dart'; // Provides MockCubit
// Imports from your project
import 'package:flightapp/presentation/cubit/user_cubit.dart';
import 'package:flightapp/presentation/cubit/user_state.dart';
import 'package:flightapp/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// FIX: Extend 'MockCubit' (singular), not 'MockCubits'.
// This provides the missing implementations for streams and state emission.
class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

void main() {
  testWidgets('renders ErrorDisplay when state is UserError', (tester) async {
    // Arrange
    final mockCubit = MockUserCubit();

    // Stub the state to return UserError immediately
    when(() => mockCubit.state).thenReturn(
      const UserError('System Down'),
    );

    // Act: Pump the widget tree with the Mock Cubit injected
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCubit>.value(
          value: mockCubit,
          child: const UserProfileScreen(),
        ),
      ),
    );

    // Assert: Verify the specific UI component appears
    expect(find.text('System Alert'), findsOneWidget);
    expect(find.text('System Down'), findsOneWidget);

    // Ensure the loading spinner is GONE
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
