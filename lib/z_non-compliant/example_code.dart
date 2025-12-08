// VIOLATION: Fire-and-Forget
void onButtonPress() {
  _submitData(); // If this throws, the app may crash or fail silently.
}

void _submitData() {}

// COMPLIANT: Explicit Handling
Future<void> onButtonPressCompliant() async {
  try {
    await _submitDataCompliant();
  } catch (e) {
    // Handle error
  }
}

Future<void> _submitDataCompliant() async {}
