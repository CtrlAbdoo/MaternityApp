// App-wide constants
class AppConstants {
  // API Related
  static const String kBaseUrl = 'https://api.example.com';
  
  // Firebase Collections
  static const String kUsersCollection = 'users';
  static const String kPregnancyCollection = 'pregnancy';
  static const String kVaccinationCollection = 'vaccination';
  static const String kMedicationCollection = 'medications';
  
  // SharedPreferences Keys
  static const String kPrefsUserIdKey = 'user_id';
  static const String kPrefsUserLoggedInKey = 'user_logged_in';
  static const String kPrefsUserNameKey = 'user_name';
  static const String kPrefsUserEmailKey = 'user_email';
  
  // Navigation Routes
  static const String kHomeRoute = '/home';
  static const String kLoginRoute = '/login';
  static const String kRegisterRoute = '/register';
  static const String kForgotPasswordRoute = '/forgot-password';
  
  // Validation
  static const int kMinPasswordLength = 8;
  static const int kMaxNameLength = 50;
  
  // Error Messages
  static const String kDefaultErrorMessage = 'Something went wrong. Please try again.';
  static const String kNetworkErrorMessage = 'Network error. Please check your connection.';
  static const String kInvalidCredentialsMessage = 'Invalid email or password.';
  
  // Success Messages
  static const String kRegistrationSuccessMessage = 'Registration successful!';
  static const String kPasswordResetSuccessMessage = 'Password reset email sent!';
  
  // App Info
  static const String kAppVersion = '1.0.0';
  static const String kAppName = 'Maternity App';
} 