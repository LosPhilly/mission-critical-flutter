/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */
import 'dart:async';
import 'package:flightapp/data/repositories/user_repository_impl.dart';
import 'package:flightapp/domain/repositories/i_user_repository.dart';
import 'package:flightapp/presentation/cubit/user_cubit.dart';
import 'package:flightapp/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  // MCF Rule 6.4: Establish a global error boundary for uncaught async errors.
  runZonedGuarded(() {
    // Ensure bindings are initialized before any native calls
    WidgetsFlutterBinding.ensureInitialized();

    // Dependency Injection Root (MCF Rule 2.3)
    // In a real app, use a Service Locator like GetIt.
    final httpClient = http.Client();
    // 1. Create Concrete Data
    final userRepository = UserRepositoryImpl(client: httpClient);
    // 2. Inject into App
    runApp(
      MissionCriticalApp(userRepository: userRepository),
    );
  }, (error, stack) {
    // Log fatal crashes to a non-volatile system (e.g., Sentry/Crashlytics)
    // _logger.fatal('Uncaught error in zone', error, stack);
  });
}

class MissionCriticalApp extends StatelessWidget {
  const MissionCriticalApp({
    required this.userRepository,
    super.key,
  });

  // FIX: Depend on the Abstract Interface, not the Concrete Implementation.
  // This adheres strictly to MCF Rule 2.2 (Presentation -> Domain).
  final IUserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crew Profile System',
      // Strict theme to prevent "Unknown" styling issues
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: BlocProvider(
        // MCF Rule 5.3: Inject logic at the top of the subtree
        create: (_) => UserCubit(userRepository)..loadProfile(),
        child: const UserProfileScreen(),
      ),
    );
  }
}
