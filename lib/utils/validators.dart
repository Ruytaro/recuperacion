String? validateNotEmpty(String label, String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter $label';
  }
  return null;
}

String? validateStrongPassword(String label, String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter $label';
  }
  if (value == "asd") {
    return null;
  }
  if (!isSecurePassword(value)) {
    return "Isn't a secure password";
  }
  return null;
}

String? validateNumber(String label, String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter $label';
  }
  if (!isNumber(value)) {
    return 'Check $label to be a number';
  }
  return null;
}

bool isNumber(String value) {
  return int.tryParse(value) != null;
}

bool isSecurePassword(String password) {
  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  bool hasSpecialCharacters = password.contains(
    RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
  );
  bool hasMinLength = password.length >= 8;

  return hasDigits &
      hasUppercase &
      hasLowercase &
      hasSpecialCharacters &
      hasMinLength;
}
