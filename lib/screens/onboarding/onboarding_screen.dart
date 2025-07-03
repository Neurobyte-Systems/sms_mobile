import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation controllers
  late AnimationController _pageAnimationController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: '🏫 School Management\nMade Easy',
      description:
          'Transform your school into a modern digital ecosystem with powerful tools designed for the future of education.',
      icon: Icons.school_rounded,
      color: AppTheme.primaryColor,
      features: [
        'Complete student management system',
        'Advanced teacher collaboration tools',
        'Real-time analytics and insights',
        'Seamless parent communication hub',
      ],
      backgroundIcon: Icons.dashboard_rounded,
    ),
    OnboardingPage(
      title: '📊 Track Everything\nReal-time',
      description:
          'Get instant insights into attendance, grades, performance metrics, and school activities with beautiful visualizations.',
      icon: Icons.analytics_rounded,
      color: AppTheme.successColor,
      features: [
        'Live attendance tracking system',
        'Interactive grade analytics',
        'Performance insights dashboard',
        'Progress monitoring tools',
      ],
      backgroundIcon: Icons.trending_up_rounded,
    ),
    OnboardingPage(
      title: '💬 Connect &\nCommunicate',
      description:
          'Bridge the gap between teachers, students, parents, and administrators with seamless communication tools.',
      icon: Icons.forum_rounded,
      color: AppTheme.secondaryColor,
      features: [
        'Direct messaging platform',
        'Group discussion forums',
        'Automated parent notifications',
        'School-wide announcement system',
      ],
      backgroundIcon: Icons.connect_without_contact_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Page animation controller
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Start initial animations
    _pageAnimationController.forward();
    _backgroundController.forward();
    _particleController.repeat();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();

    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    HapticFeedback.lightImpact();

    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _finishOnboarding() {
    HapticFeedback.mediumImpact();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const AuthScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Simple slide transition only
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Slide from right
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(size),

            // Floating particles
            _buildFloatingParticles(size),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header with skip and progress
                  _buildHeader(),

                  // PageView content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                        _pageAnimationController.reset();
                        _pageAnimationController.forward();
                        _backgroundController.reset();
                        _backgroundController.forward();
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageAnimationController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: _buildOnboardingPage(_pages[index]),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Navigation buttons
                  _buildNavigationButtons(),
                ],
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
        final currentPage = _pages[_currentPage];

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.3, 0.7, 1.0],
              colors: [
                currentPage.color.withOpacity(0.1),
                currentPage.color.withOpacity(0.05),
                Colors.white.withOpacity(0.95),
                Colors.white,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Large background icon
              Positioned.fill(
                child: Opacity(
                  opacity: 0.03 * _backgroundAnimation.value,
                  child: Icon(
                    currentPage.backgroundIcon,
                    size: size.width * 2,
                    color: currentPage.color,
                  ),
                ),
              ),

              // Geometric shapes
              Positioned(
                top: size.height * 0.15,
                right: -size.width * 0.2,
                child: Transform.rotate(
                  angle: _backgroundAnimation.value * 0.5,
                  child: Container(
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage.color.withOpacity(0.05),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: size.height * 0.1,
                left: -size.width * 0.3,
                child: Transform.rotate(
                  angle: -_backgroundAnimation.value * 0.3,
                  child: Container(
                    width: size.width * 0.9,
                    height: size.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage.color.withOpacity(0.03),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles(Size size) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final currentColor = _pages[_currentPage].color;

        return Stack(
          children: List.generate(12, (index) {
            final offset = (_particleAnimation.value + index * 0.12) % 1.0;
            final xPos = (index * 0.18 + offset * 0.15) % 1.0;
            final yPos = 1.0 - offset;

            return Positioned(
              left: size.width * xPos,
              top: size.height * yPos + 50,
              child: Opacity(
                opacity: offset * 0.4,
                child: Container(
                  width: 6 + (index % 4) * 2,
                  height: 6 + (index % 4) * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        currentColor.withOpacity(0.6),
                        currentColor.withOpacity(0.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: currentColor.withOpacity(0.3),
                        blurRadius: 8,
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip button
              TextButton(
                onPressed: _finishOnboarding,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Page indicators
              Row(
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: _currentPage == index ? 32 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      gradient:
                          _currentPage == index
                              ? LinearGradient(
                                colors: [
                                  _pages[_currentPage].color,
                                  _pages[_currentPage].color.withOpacity(0.7),
                                ],
                              )
                              : null,
                      color:
                          _currentPage == index ? null : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow:
                          _currentPage == index
                              ? [
                                BoxShadow(
                                  color: _pages[_currentPage].color.withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress text
          Text(
            '${_currentPage + 1} of ${_pages.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Hero icon with animations (made smaller for better fit)
          _buildHeroIcon(page),

          const SizedBox(height: 32),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 32),

          // Features with staggered animation
          _buildFeaturesList(page),

          // Add bottom padding to ensure content doesn't get cut off
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildHeroIcon(OnboardingPage page) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            page.color.withOpacity(0.15),
            page.color.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [page.color, page.color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: page.color.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(page.icon, size: 50, color: Colors.white),
      ),
    );
  }

  Widget _buildFeaturesList(OnboardingPage page) {
    return Column(
      children:
          page.features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;

            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [page.color, page.color.withOpacity(0.8)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: page.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: _pages[_currentPage].color, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 16,
                      color: _pages[_currentPage].color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Previous',
                      style: TextStyle(
                        color: _pages[_currentPage].color,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_currentPage > 0) const SizedBox(width: 16),

          // Next/Get Started button
          Expanded(
            flex: _currentPage == 0 ? 1 : 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _pages[_currentPage].color,
                    _pages[_currentPage].color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _pages[_currentPage].color.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _currentPage == _pages.length - 1
                          ? Icons.rocket_launch_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageAnimationController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;
  final IconData backgroundIcon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
    required this.backgroundIcon,
  });
}
