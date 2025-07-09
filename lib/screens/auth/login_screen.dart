import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../dashboard/admin_dashboard.dart';
import '../dashboard/teacher_dashboard.dart';
import '../dashboard/student_dashboard.dart';
import '../dashboard/parent_dashboard.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'teacher@gmail.com');
  final _passwordController = TextEditingController(text: '123456');

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isBiometricLoading = false;
  bool _rememberMe = false;
  String? _selectedRole;

  // Animation controllers for existing UI animations (keeping these for UI elements)
  late AnimationController _animationController;
  late AnimationController _particleController;
  late AnimationController _backgroundController;

  // Animations for UI elements
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Keep existing animations for UI elements (not for page transitions)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _animationController.forward();
    _particleController.repeat();
    _backgroundController.repeat();
  }

  // Validation methods
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(AppConstants.emailPattern).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Demo login - determine role based on email or use selected role
    String role =
        _selectedRole ?? _determineRoleFromEmail(_emailController.text);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      _navigateToDashboard(role);
    }
  }

  String _determineRoleFromEmail(String email) {
    if (email.contains('admin')) return AppConstants.adminRole;
    if (email.contains('teacher')) return AppConstants.teacherRole;
    if (email.contains('student')) return AppConstants.studentRole;
    if (email.contains('parent')) return AppConstants.parentRole;
    return AppConstants.studentRole; // Default
  }

  // UPDATED: Simple SlideTransition only for navigation
  void _navigateToDashboard(String role) {
    Widget dashboard;

    switch (role) {
      case AppConstants.adminRole:
        dashboard = const AdminDashboard();
        break;
      case AppConstants.teacherRole:
        dashboard = const TeacherDashboard();
        break;
      case AppConstants.studentRole:
        dashboard = const StudentDashboard();
        break;
      case AppConstants.parentRole:
        dashboard = const ParentDashboard();
        break;
      default:
        dashboard = const StudentDashboard();
    }

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => dashboard,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Simple slide transition only - from right to left
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 300,
        ), // Reduced duration
      ),
      (route) => false,
    );
  }

  void _loginWithBiometrics() async {
    HapticFeedback.lightImpact();

    try {
      // Show loading state
      setState(() {
        _isBiometricLoading = true;
      });

      // Check if biometric authentication is available
      final isAvailable = await _checkBiometricAvailability();

      if (!isAvailable) {
        _showBiometricUnavailableDialog();
        return;
      }

      // Attempt biometric authentication
      final isAuthenticated = await _authenticateWithBiometrics();

      if (isAuthenticated) {
        // Success - navigate to default dashboard or last used role
        HapticFeedback.mediumImpact();
        _navigateToDashboard(
          AppConstants.studentRole,
        ); // Default to student for demo

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Biometric login successful!'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        // Authentication failed
        HapticFeedback.heavyImpact();
        _showBiometricFailedDialog();
      }
    } catch (e) {
      // Handle errors
      HapticFeedback.heavyImpact();
      _showBiometricErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isBiometricLoading = false;
        });
      }
    }
  }

  Future<bool> _checkBiometricAvailability() async {
    // Simulate checking biometric availability
    await Future.delayed(const Duration(milliseconds: 500));

    // For demo purposes, we'll simulate that biometrics are available
    // In a real app, you would use local_auth plugin:
    // final LocalAuthentication localAuth = LocalAuthentication();
    // final bool isAvailable = await localAuth.canCheckBiometrics;
    // final List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();

    return true; // Simulate biometrics are available
  }

  Future<bool> _authenticateWithBiometrics() async {
    // Simulate biometric authentication process
    await Future.delayed(const Duration(milliseconds: 1500));

    // For demo purposes, we'll simulate successful authentication
    // In a real app, you would use:
    // final bool didAuthenticate = await localAuth.authenticate(
    //   localizedReason: 'Please authenticate to access MySchoolGH',
    //   options: const AuthenticationOptions(
    //     biometricOnly: true,
    //     stickyAuth: true,
    //   ),
    // );

    // Simulate 80% success rate for demo
    return DateTime.now().millisecondsSinceEpoch % 5 != 0;
  }

  void _showBiometricUnavailableDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppTheme.warningColor),
                const SizedBox(width: 8),
                const Text('Biometric Unavailable'),
              ],
            ),
            content: const Text(
              'Biometric authentication is not available on this device. Please ensure your device supports biometric authentication and it\'s properly set up.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
    );
  }

  void _showBiometricFailedDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: AppTheme.errorColor),
                const SizedBox(width: 8),
                const Text('Authentication Failed'),
              ],
            ),
            content: const Text(
              'Biometric authentication failed. Please try again or use your email and password to login.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Try Again',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Focus on email field for manual login
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Text(
                  'Use Password',
                  style: TextStyle(color: AppTheme.secondaryColor),
                ),
              ),
            ],
          ),
    );
  }

  void _showBiometricErrorDialog(String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.error, color: AppTheme.errorColor),
                const SizedBox(width: 8),
                const Text('Biometric Error'),
              ],
            ),
            content: Text(
              'An error occurred during biometric authentication: $error\n\nPlease try again or use your email and password.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Try Again',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Focus on email field for manual login
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Text(
                  'Use Password',
                  style: TextStyle(color: AppTheme.secondaryColor),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildAnimatedBackground(size),

            // Floating particles
            _buildFloatingParticles(size),

            // Main content
            SafeArea(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildLoginContent(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(Size size) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.3, -0.5),
              radius: 1.5,
              colors: [
                Colors.white.withOpacity(0.1 * _backgroundAnimation.value),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(10, (index) {
            final animationOffset =
                (_particleAnimation.value * 2 * 3.14159) + (index * 0.6);
            final x =
                size.width * 0.1 +
                (size.width * 0.8) *
                    ((animationOffset % (2 * 3.14159)) / (2 * 3.14159));
            final y =
                size.height * 0.1 +
                (size.height * 0.8) * ((animationOffset * 0.5) % 1.0);

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 4 + (index % 3) * 2,
                height: 4 + (index % 3) * 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildLoginContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Header
          _buildHeader(),

          const SizedBox(height: 40),

          // Login Form
          _buildLoginForm(),

          const SizedBox(height: 24),

          // Divider
          _buildDivider(),

          const SizedBox(height: 24),

          // Alternative logins
          _buildAlternativeLogins(),

          const SizedBox(height: 24),

          // Sign up link
          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Back button
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Logo and title
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.7),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 40,
            color: Color(0xFF667eea),
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Welcome Back!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Sign in to continue to MySchoolGH',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Remember me and forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    const Text('Remember me'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Login button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.login_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Sign In',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeLogins() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Biometric Login
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isBiometricLoading ? null : _loginWithBiometrics,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      _isBiometricLoading
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF4c6ef5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Authenticating...',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4c6ef5),
                                      Color(0xFF7c3aed),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.fingerprint,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Use Biometric Authentication',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();

            // UPDATED: Simple slide transition for navigation to signup
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const SignupScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  // Simple slide transition only
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                transitionDuration: const Duration(
                  milliseconds: 300,
                ), // Reduced duration
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _particleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }
}
