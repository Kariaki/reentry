class InputValidators {
  static String? passwordValidation(String? input) => (input?.length ?? 0) < 6
      ? 'Password must be at least 6 characters'
      : null;

  static String? stringValidation(String? input) =>
      (input?.isNotEmpty ?? false) ? null : 'Field is required';

  static String? emailValidation(String? input) =>
      _isValidEmail(input) ? null : 'Enter a valid email';

  static bool _isValidEmail(String? email) {
    if (email == null) return false;
    // Regular expression for validating an email
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    return emailRegex.hasMatch(email);
  }
}
