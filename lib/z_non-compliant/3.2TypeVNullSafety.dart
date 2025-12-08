import 'package:flightapp/domain/entities/user.dart';

// VIOLATION: Using the Bang Operator
String getUserNameNonCompliant(User? user) {
  return user!.name; // CRASH RISK: If user is null, app crashes here.
}

// COMPLIANCE: Explicit Check
String getUserNameExplicitCheck(User? user) {
  if (user != null) {
    return user.name; // Dart promotes 'user' to non-nullable here.
  }
  return 'Guest'; // Safe fallback
}

// COMPLIANCE: Pattern Matching (Dart 3.0+)
String getUserNamePatternMatching(User? user) {
  return switch (user) {
    User(name: var n) => n,
    null => 'Guest',
  };
}
