/*
 * Mission-Critical Flutter
 * * Copyright (c) 2025 [Carlos Phillips / 505 Tech Support]
 * * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * * Author: [Carlos Phillips]
 * License: MIT (see LICENSE file)
 */
/// lib\data\models\user_model.dart
import 'package:flightapp/domain/entities/address.dart'; // Ensure these entities exist
import 'package:flightapp/domain/entities/company.dart'; // based on previous step
import 'package:flightapp/domain/entities/user.dart';

/// A Data Transfer Object (DTO) that extends the Domain Entity.
/// This keeps the Domain pure (no JSON code in lib/domain).
/// DTO for the main User object.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.phone,
    required super.website,
    required super.isAdmin,
    required super.address, // New required field
    required super.company, // New required field
  });

  /// Factory to parse raw JSON into a safe, typed object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Defensive coding: Handle missing keys or bad types gracefully
    // (MCF Rule 3.5: Explicit Casting)
    return UserModel(
      // FIX: Cast 'id' to int first, then convert to String to prevent crash.
      id: (json['id'] as int).toString(),
      name: json['name'] as String? ?? 'Unknown',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',

      // JSONPlaceholder has no 'role'. We mock it: User ID 1 is the Commander.
      isAdmin: (json['id'] as int) == 1,

      // MCF Rule 3.5: Delegating nested parsing to specific Models
      // Note: You must define AddressModel and CompanyModel similarly
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      company: CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
    );
  }

  /// Convert back to JSON if we needed to send data to the server.
  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id), // Convert back to int for API consistency
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      // No 'role' field in this specific API
      // Serialize nested objects (assuming Models have toJson)
      'address': (address as AddressModel).toJson(),
      'company': (company as CompanyModel).toJson(),
    };
  }
}

// --- Nested Models (Include these in the same file or separate files) ---

class AddressModel extends Address {
  const AddressModel({
    required super.street,
    required super.suite,
    required super.city,
    required super.zipcode,
    required super.geo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] as String? ?? '',
      suite: json['suite'] as String? ?? '',
      city: json['city'] as String? ?? '',
      zipcode: json['zipcode'] as String? ?? '',
      geo: GeoModel.fromJson(json['geo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'suite': suite,
        'city': city,
        'zipcode': zipcode,
        'geo': (geo as GeoModel).toJson(),
      };
}

class GeoModel extends Geo {
  const GeoModel({required super.lat, required super.lng});

  factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(
      lat: json['lat'] as String? ?? '0.0',
      lng: json['lng'] as String? ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class CompanyModel extends Company {
  const CompanyModel({
    required super.name,
    required super.catchPhrase,
    required super.bs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'] as String? ?? 'Unknown Corp',
      catchPhrase: json['catchPhrase'] as String? ?? '',
      bs: json['bs'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'catchPhrase': catchPhrase,
        'bs': bs,
      };
}
