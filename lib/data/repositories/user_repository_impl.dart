/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */
import 'dart:convert';
import 'dart:io';
import 'package:flightapp/data/models/user_model.dart';
import 'package:flightapp/domain/entities/user.dart';
// Import Domain Failures to satisfy MCF Rule 2.2
import 'package:flightapp/domain/failures/failure.dart';
import 'package:flightapp/domain/repositories/i_user_repository.dart';
// Required for 'compute' function (MCF Rule 6.5)
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// 1. Define a top-level function (or static method) for the Isolate to run.
// Isolates cannot share memory, so this function must be standalone.
Map<String, dynamic> _parseAndDecode(String responseBody) {
  return json.decode(responseBody) as Map<String, dynamic>;
}

class UserRepositoryImpl implements IUserRepository {
  final http.Client client;

  UserRepositoryImpl({required this.client});

  @override
  Future<User> getUserProfile() async {
    try {
      final response = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
        // FIX: Add Headers to look like a legitimate request.
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'FlightApp/1.0', // Helps bypass basic WAFs
        },
      );

      if (response.statusCode == 200) {
        try {
          // MCF Rule 6.5: Offload heavy JSON decoding to a background thread.
          // The UI thread stays free to animate the CircularProgressIndicator.
          // Explicitly cast 'dynamic' to the expected Map type within the isolate function.
          final jsonMap = await compute(_parseAndDecode, response.body);

          return UserModel.fromJson(jsonMap);
        } catch (e) {
          // MCF Rule 3.6: Exception Wrapping Pattern.
          // Catch TypeError/FormatException and throw a Domain Failure.
          // and rethrow as a safe, standard Exception.
          throw FormatFailure('Data Parsing Failure: $e');
        }
      } else {
        // Convert non-200 status directly to Domain Failure
        // This is where your 403 was caught!
        // proven that MCF Rule 1.3 (Reliability) is being enforced.
        throw ServerFailure(
          'Server Error: ${response.statusCode}',
        );
      }
    } on SocketException {
      // Convert Network Exception directly to Domain Failure
      throw const ConnectionFailure('No Internet Connection');
    }
  }
}
