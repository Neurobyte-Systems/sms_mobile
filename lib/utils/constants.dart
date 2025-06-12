class AppConstants {
  // App Information
  static const String appName = 'MySchoolGH';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'School Management Made Easy';

  // API Configuration - Updated to match Next.js app
  static const String baseUrl = 'https://api.myschoolgh.com';
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);

  // API Endpoints - Matching Next.js app
  static const String analyticsEndpoint = '/analitics/generate';
  static const String assignmentsEndpoint = '/assignments/list';
  static const String timetableEndpoint = '/timetable/getlist';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_completed';
  static const String biometricKey = 'biometric_enabled';

  // User Roles
  static const String adminRole = 'admin';
  static const String teacherRole = 'teacher';
  static const String studentRole = 'student';
  static const String parentRole = 'parent';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;
  static const double avatarRadius = 20.0;

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10,15}$';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String invalidCredentials = 'Invalid email or password';
  static const String accountNotFound = 'Account not found';
  static const String accountExists = 'Account already exists';

  // Success Messages
  static const String loginSuccess = 'Welcome back!';
  static const String registrationSuccess = 'Account created successfully';
  static const String passwordResetSuccess = 'Password reset link sent';
  static const String profileUpdateSuccess = 'Profile updated successfully';

  // Features
  static const List<String> supportedLanguages = ['en', 'tw'];
  static const List<String> supportedThemes = ['light', 'dark', 'system'];

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> supportedDocTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheTimeout = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB
}