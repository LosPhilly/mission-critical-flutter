/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * Audit Tool v2.1 (Deep Inspection)
 * * Usage: dart run tool/audit.dart
 */

/// ----------------------------------------------------------------------------
/// MCF AUDIT TOOL
/// ----------------------------------------------------------------------------
///
/// USAGE:
/// Run this command from the root of your project:
///   dart run tool/audit.dart
///
/// DESCRIPTION:
/// This tool automatically scans your codebase against the "Mission-Critical Flutter"
/// architectural standards (MCF Rules). It performs a deep inspection of:
///   1. Layer Isolation (Ensures Domain never imports Data/UI).
///   2. Strict Linting (Verifies analysis_options.yaml).
///   3. Safety Checks (Scans for forbidden '!' bang operators).
///   4. Branding (Verifies Copyright Headers).
///   5. Toolchain Health (Runs 'flutter analyze' and 'flutter test').
///
/// EXIT CODES:
///   0 = Success (System Secure - CI/CD Pipeline can proceed).
///   1 = Failure (Critical Violations Detected - Build should fail).
/// ----------------------------------------------------------------------------

import 'dart:io';

// ANSI Colors
const String _reset = '\x1B[0m';
const String _red = '\x1B[31m';
const String _green = '\x1B[32m';
const String _yellow = '\x1B[33m';
const String _cyan = '\x1B[36m';
const String _bold = '\x1B[1m';

void main() async {
  print('$_cyan$_bold[ MCF ARCHITECTURE AUDIT v2.1 ]$_reset');
  print('Initializing Mission-Critical Compliance Pipeline...\n');

  int violations = 0;
  final currentDir = Directory.current;

  // --- PHASE 1: STATIC CODE ANALYSIS (Custom Scanners) ---
  print('$_bold[PHASE 1] Static Pattern Analysis$_reset');

  // 1. CHECK: Analysis Options Config
  violations += await _verifyAnalysisOptions(currentDir);

  // 2. CHECK: Layer Isolation (Rule 2.2)
  violations += await _verifyLayerIsolation(currentDir);

  // 3. CHECK: The "Bang" Operator (Rule 3.4)
  violations += await _verifyNoBangOperator(currentDir);

  // 4. CHECK: Copyright Headers
  violations += await _verifyHeaders(currentDir);

  // --- PHASE 2: TOOLCHAIN VERIFICATION (Flutter Tools) ---
  print('\n$_bold[PHASE 2] Toolchain Verification$_reset');

  // 5. CHECK: Flutter Analyzer (Enforces Section 2 & 3)
  // This verifies Rules 3.3, 3.6, 3.11, 4.1, 4.7 via very_good_analysis
  if (!await _runFlutterCommand('analyze', 'Linter Compliance')) {
    violations++;
  }

  // 6. CHECK: Unit & Widget Tests (Enforces Section 6)
  // This verifies Rules 7.2, 7.3
  if (!await _runFlutterCommand('test', 'Test Suite Verification')) {
    violations++;
  }

  print('\n---------------------------------------------------');
  if (violations == 0) {
    print('$_green$_bold✓ AUDIT PASSED. SYSTEM SECURE.$_reset');
    exit(0);
  } else {
    print('$_red$_bold✖ AUDIT FAILED.$_reset');
    print('$_yellow$violations Critical Violation(s) Detected.$_reset');
    exit(1);
  }
}

/// Helper to run Flutter CLI commands
Future<bool> _runFlutterCommand(String command, String label) async {
  stdout.write('Running $label (flutter $command)... ');

  final result = await Process.run(
    'flutter',
    [command],
    runInShell: true, // Required for Windows compatibility
  );

  if (result.exitCode == 0) {
    print('$_green[PASS]$_reset');
    return true;
  } else {
    print('$_red[FAIL]$_reset');
    print(_yellow);
    // Print the first 5 lines of error output to avoid spamming
    final lines = result.stdout.toString().split('\n');
    for (var i = 0; i < (lines.length > 5 ? 5 : lines.length); i++) {
      if (lines[i].trim().isNotEmpty) {
        print('  > ${lines[i]}');
      }
    }
    // FIX: Tell the user exactly how to see the rest
    print('  ... (Run "flutter $command" to see the full log)$_reset');
    return false;
  }
}

/// Rule 3.1: strict-casts, strict-inference, strict-raw-types
Future<int> _verifyAnalysisOptions(Directory root) async {
  stdout.write('Checking analysis_options.yaml... ');
  final file = File('${root.path}/analysis_options.yaml');

  if (!await file.exists()) {
    print('$_red[MISSING]$_reset');
    return 1;
  }

  final content = await file.readAsString();
  int errors = 0;

  if (!content.contains('strict-casts: true')) errors++;
  if (!content.contains('avoid_dynamic_calls: error')) errors++;

  if (errors > 0) {
    print('$_red[FAILED]$_reset (Missing strict rules)');
    return 1;
  }

  print('$_green[PASS]$_reset');
  return 0;
}

/// Rule 2.2: Domain cannot import Data or Presentation
Future<int> _verifyLayerIsolation(Directory root) async {
  stdout.write('Verifying Domain Layer Isolation... ');
  final domainDir = Directory('${root.path}/lib/domain');

  if (!await domainDir.exists()) {
    print('$_yellow[SKIP]$_reset (No domain folder)');
    return 0;
  }

  int violations = 0;
  bool headerPrinted = false;

  await for (final entity in domainDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final lines = content.split('\n');

      for (var line in lines) {
        if (line.trim().startsWith('import')) {
          if (line.contains('/data/') ||
              line.contains('/presentation/') ||
              line.contains('package:flutter/')) {
            if (!line.contains('foundation.dart')) {
              if (!headerPrinted) {
                print(''); // New line to break the "Verifying..." line
                headerPrinted = true;
              }
              print(
                  '  $_red[VIOLATION] ${entity.uri.pathSegments.last}$_reset');
              print('  -> Forbidden import: "${line.trim()}"');
              violations++;
            }
          }
        }
      }
    }
  }

  if (violations == 0) {
    print('$_green[PASS]$_reset');
  } else {
    // If we printed errors, we don't need a summary "FAIL" on the same line
  }
  return violations;
}

/// Rule 3.4: The Force Unwrap (!) is prohibited
Future<int> _verifyNoBangOperator(Directory root) async {
  stdout.write('Scanning for Bang Operator (!)... ');
  final libDir = Directory('${root.path}/lib');
  int violations = 0;
  bool headerPrinted = false;

  if (!await libDir.exists()) return 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (entity.path.endsWith('.g.dart') ||
          entity.path.endsWith('.freezed.dart')) continue;

      final lines = await entity.readAsLines();
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        // Check for '!' but ignore '!=' and comments
        if (line.contains('!') &&
            !line.contains('!=') &&
            !line.trim().startsWith('//')) {
          // Ignore safe usages
          if (!line.contains('!mounted')) {
            if (!headerPrinted) {
              print(''); // New line
              headerPrinted = true;
            }
            // PRINT ACTIONABLE ERROR
            print(
                '  $_yellow[WARNING] ${entity.uri.pathSegments.last}:${i + 1}$_reset');
            print('  -> Potential Bang Operator usage: "${line.trim()}"');
            violations++;
          }
        }
      }
    }
  }

  if (violations == 0) {
    print('$_green[PASS]$_reset');
  }
  return violations;
}

/// Branding Check
Future<int> _verifyHeaders(Directory root) async {
  stdout.write('Verifying Copyright Headers... ');
  final libDir = Directory('${root.path}/lib');
  int violations = 0;

  if (!await libDir.exists()) return 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      if (!content.contains('Mission-Critical Flutter')) {
        violations++;
      }
    }
  }

  if (violations > 0) {
    print('$_yellow[WARN]$_reset');
    print('  -> $violations files missing MCF Copyright Header.');
    return 0; // Warning only, strictly speaking
  }

  print('$_green[PASS]$_reset');
  return 0;
}
