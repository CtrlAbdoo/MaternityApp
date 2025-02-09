class InputValidator {
  // Validate email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null; // Valid email
  }

  // Validate password
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null; // Valid password
  }

  // Validate name
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    if (name.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    const namePattern = r'^[a-zA-Z\s]+$';
    final regex = RegExp(namePattern);
    if (!regex.hasMatch(name)) {
      return 'Name must contain only letters and spaces';
    }
    return null; // Valid name
  }

  // Validate phone number
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    }
    const phonePattern = r'^\+?[0-9]{10,15}$';
    final regex = RegExp(phonePattern);
    if (!regex.hasMatch(phoneNumber)) {
      return 'Enter a valid phone number';
    }
    return null; // Valid phone number
  }

  // Validate generic required fields
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null; // Field is valid
  }
}
