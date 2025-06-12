import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
    ));

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _particleController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _navigateToLogin() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: AppConstants.mediumAnimation,
      ),
    );
  }

  void _navigateToSignup() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: AppConstants.mediumAnimation,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
              const Color(0xFFf5576c),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
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
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 60),
                              
                              // App Logo and Title
                              _buildHeader(),
                              
                              const SizedBox(height: 60),
                              
                              // Welcome Message
                              _buildWelcomeMessage(),
                              
                              const SizedBox(height: 50),
                              
                              // Authentication Options
                              _buildAuthOptions(),
                              
                              const SizedBox(height: 40),
                              
                              // Quick Access
                              _buildQuickAccess(),
                              
                              const SizedBox(height: 40),
                              
                              // Footer
                              _buildFooter(),
                              
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
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
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: [
            // Large floating circles
            Positioned(
              top: size.height * 0.1,
              right: -size.width * 0.3,
              child: Transform.rotate(
                angle: _particleAnimation.value * 2,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned(
              bottom: size.height * 0.15,
              left: -size.width * 0.4,
              child: Transform.rotate(
                angle: -_particleAnimation.value * 1.5,
                child: Container(
                  width: size.width * 0.9,
                  height: size.width * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Geometric shapes
            Positioned(
              top: size.height * 0.3,
              left: size.width * 0.1,
              child: Transform.rotate(
                angle: _particleAnimation.value * 3,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (index) {
            final offset = (_particleAnimation.value + index * 0.1) % 1.0;
            final xPos = (index * 0.12 + offset * 0.2) % 1.0;
            final yPos = offset;
            
            return Positioned(
              left: size.width * xPos,
              top: size.height * yPos - 50,
              child: Opacity(
                opacity: (1.0 - offset) * 0.6,
                child: Container(
                  width: 3 + (index % 4),
                  height: 3 + (index % 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Column(
          children: [
            // Logo with pulse effect
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFF667eea),
                        const Color(0xFF764ba2),
                      ],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name with gradient
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.9),
                ],
              ).createShader(bounds),
              child: Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                AppConstants.appDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeMessage() {
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
      child: Column(
        children: [
          Text(
            'Welcome to the Future of\nEducation Management 🚀',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF2D3748),
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Join thousands of schools already using MySchoolGH to streamline their operations and enhance learning experiences.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4A5568),
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthOptions() {
    return Column(
      children: [
        // Sign In Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667eea),
                const Color(0xFF764ba2),
              ],
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
            onPressed: _navigateToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Create Account Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: OutlinedButton(
            onPressed: _navigateToSignup,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      const Color(0xFF667eea),
                      const Color(0xFF764ba2),
                    ],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      const Color(0xFF667eea),
                      const Color(0xFF764ba2),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccess() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Quick Access',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAccessButton(
                icon: Icons.admin_panel_settings_rounded,
                label: 'Admin',
                color: AppTheme.adminColor,
              ),
              _buildQuickAccessButton(
                icon: Icons.school_rounded,
                label: 'Teacher',
                color: AppTheme.teacherColor,
              ),
              _buildQuickAccessButton(
                icon: Icons.person_rounded,
                label: 'Student',
                color: AppTheme.studentColor,
              ),
              _buildQuickAccessButton(
                icon: Icons.family_restroom_rounded,
                label: 'Parent',
                color: AppTheme.parentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label login coming soon!'),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
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
        ),
        
        const SizedBox(height: 20),
        
        Text(
          'Version ${AppConstants.appVersion}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 12),
        
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: Show help/support dialog
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              'Need Help? Contact Support',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}