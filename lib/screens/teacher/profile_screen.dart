import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'notification_settings_screen.dart';
import 'help_support_screen.dart';
import 'teacher_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isEditing = false;

  // Profile data
  final Map<String, dynamic> _profileData = {
    'name': 'Sarah Wilson',
    'title': 'Mathematics Teacher',
    'email': 'sarah.wilson@myschoolgh.com',
    'phone': '+233 24 123 4567',
    'employeeId': 'TCH001',
    'department': 'Mathematics',
    'subjects': ['Mathematics', 'Statistics', 'Algebra'],
    'experience': '8 years',
    'education': 'M.Sc. Mathematics, University of Ghana',
    'joinDate': '2016-09-01',
    'address': '123 Accra Street, East Legon, Accra',
    'emergencyContact': '+233 24 987 6543',
    'qualification': 'Bachelor of Education, Master of Science',
    'specialization': 'Advanced Mathematics & Statistics',
  };

  final Map<String, dynamic> _teachingStats = {
    'totalClasses': 8,
    'totalStudents': 240,
    'assignmentsGraded': 156,
    'averageClassSize': 30,
    'teachingLoad': '24 hours/week',
    'satisfactionRating': 4.8,
    'parentFeedbacks': 45,
    'achievements': [
      'Best Teacher Award 2023',
      'Excellence in Mathematics Teaching',
      'Student Choice Award 2022',
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildProfileCard(),
                          const SizedBox(height: 24),
                          _buildStatsGrid(),
                          const SizedBox(height: 24),
                          _buildPersonalInfo(),
                          const SizedBox(height: 24),
                          _buildProfessionalInfo(),
                          const SizedBox(height: 24),
                          _buildAchievements(),
                          const SizedBox(height: 24),
                          _buildQuickActions(),
                          const SizedBox(height: 100), // Space for FAB
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isEditing ? Icons.done_rounded : Icons.edit_rounded,
            color: Colors.white,
          ),
          onPressed: _toggleEditing,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          onPressed: _showMoreOptions,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.teacherColor,
                AppTheme.teacherColor.withOpacity(0.9),
                AppTheme.teacherColor.withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background patterns
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Profile icon
              Positioned(
                top: 70,
                right: 50,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Icon(
                    Icons.person_rounded,
                    size: 35,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Teacher Profile',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Manage your profile & settings',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppTheme.teacherColor.withOpacity(0.05)],
        ),
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
          // Profile Picture and Basic Info
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.teacherColor,
                      AppTheme.teacherColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.teacherColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      _profileData['name'].split(' ').map((n) => n[0]).join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 12,
                            color: AppTheme.teacherColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profileData['name'],
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profileData['title'],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.teacherColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.badge_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ID: ${_profileData['employeeId']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isEditing)
                IconButton(
                  onPressed: _editBasicInfo,
                  icon: const Icon(Icons.edit_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.teacherColor.withOpacity(0.1),
                    foregroundColor: AppTheme.teacherColor,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Contact Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.teacherColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.email_rounded,
                      color: AppTheme.teacherColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _profileData['email'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      color: AppTheme.teacherColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _profileData['phone'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'title': 'Classes',
        'value': '${_teachingStats['totalClasses']}',
        'icon': Icons.class_rounded,
        'color': AppTheme.teacherColor,
      },
      {
        'title': 'Students',
        'value': '${_teachingStats['totalStudents']}',
        'icon': Icons.people_rounded,
        'color': AppTheme.studentColor,
      },
      {
        'title': 'Assignments',
        'value': '${_teachingStats['assignmentsGraded']}',
        'icon': Icons.assignment_rounded,
        'color': AppTheme.primaryColor,
      },
      {
        'title': 'Rating',
        'value': '${_teachingStats['satisfactionRating']}★',
        'icon': Icons.star_rounded,
        'color': AppTheme.warningColor,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 800 + (index * 200)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      (stat['color'] as Color).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (stat['color'] as Color).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: (stat['color'] as Color).withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (stat['color'] as Color),
                            (stat['color'] as Color).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (stat['color'] as Color).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      stat['value'] as String,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: stat['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat['title'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                color: AppTheme.teacherColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              if (_isEditing)
                IconButton(
                  onPressed: _editPersonalInfo,
                  icon: const Icon(Icons.edit_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.teacherColor.withOpacity(0.1),
                    foregroundColor: AppTheme.teacherColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.home_rounded, 'Address', _profileData['address']),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.emergency_rounded,
            'Emergency Contact',
            _profileData['emergencyContact'],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.calendar_today_rounded,
            'Join Date',
            _formatDate(_profileData['joinDate']),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.work_history_rounded,
            'Experience',
            _profileData['experience'],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_rounded,
                color: AppTheme.teacherColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Professional Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              if (_isEditing)
                IconButton(
                  onPressed: _editProfessionalInfo,
                  icon: const Icon(Icons.edit_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.teacherColor.withOpacity(0.1),
                    foregroundColor: AppTheme.teacherColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.apartment_rounded,
            'Department',
            _profileData['department'],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.school_rounded,
            'Education',
            _profileData['education'],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.verified_rounded,
            'Qualification',
            _profileData['qualification'],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.star_rounded,
            'Specialization',
            _profileData['specialization'],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.schedule_rounded,
            'Teaching Load',
            _teachingStats['teachingLoad'],
          ),
          const SizedBox(height: 20),
          // Subjects
          const Text(
            'Subjects Teaching',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                (_profileData['subjects'] as List<String>).map((subject) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.teacherColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.teacherColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      subject,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.teacherColor,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: AppTheme.warningColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Achievements & Awards',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (_teachingStats['achievements'] as List<String>).length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final achievement =
                  (_teachingStats['achievements'] as List<String>)[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.warningColor.withOpacity(0.1),
                      AppTheme.warningColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.warningColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        achievement,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Change Password',
        'icon': Icons.lock_rounded,
        'color': AppTheme.primaryColor,
      },
      {
        'title': 'Notification Settings',
        'icon': Icons.notifications_rounded,
        'color': AppTheme.warningColor,
      },
      {
        'title': 'Privacy Settings',
        'icon': Icons.privacy_tip_rounded,
        'color': AppTheme.successColor,
      },
      {
        'title': 'Download Profile',
        'icon': Icons.download_rounded,
        'color': AppTheme.teacherColor,
      },
      {
        'title': 'Help & Support',
        'icon': Icons.help_outline_rounded,
        'color': AppTheme.parentColor,
      },
      {
        'title': 'Logout',
        'icon': Icons.logout_rounded,
        'color': AppTheme.errorColor,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_rounded,
                color: AppTheme.teacherColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionCard(action, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: GestureDetector(
            onTap: () => _handleQuickAction(action['title'] as String),
            child: Container(
              decoration: BoxDecoration(
                color: (action['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (action['color'] as Color).withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: action['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (action['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.teacherColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),
        if (_isEditing)
          Icon(Icons.edit_rounded, size: 16, color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_fabController.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: _onFabPressed,
            backgroundColor: AppTheme.teacherColor,
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            label: const Text(
              'Share Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper Methods
  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Action Methods
  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Edit mode enabled' : 'Edit mode disabled'),
        backgroundColor: AppTheme.teacherColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onFabPressed() {
    HapticFeedback.mediumImpact();
    _fabController.forward().then((_) {
      _fabController.reverse();
    });

    _shareProfile();
  }

  void _shareProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Share Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                _buildShareOption(
                  Icons.link_rounded,
                  'Copy Profile Link',
                  () {},
                ),
                _buildShareOption(
                  Icons.qr_code_rounded,
                  'Generate QR Code',
                  () {},
                ),
                _buildShareOption(
                  Icons.file_download_rounded,
                  'Download PDF',
                  () {},
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildShareOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.teacherColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionItem(Icons.backup_rounded, 'Backup Profile', () {}),
                _buildOptionItem(Icons.print_rounded, 'Print Profile', () {}),
                _buildOptionItem(
                  Icons.security_rounded,
                  'Security Settings',
                  () {},
                ),
                _buildOptionItem(
                  Icons.feedback_rounded,
                  'Send Feedback',
                  () {},
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.teacherColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _editBasicInfo() {
    showDialog(
      context: context,
      builder:
          (context) => _buildEditDialog('Edit Basic Information', [
            {'label': 'Name', 'key': 'name', 'icon': Icons.person_rounded},
            {'label': 'Title', 'key': 'title', 'icon': Icons.work_rounded},
            {'label': 'Email', 'key': 'email', 'icon': Icons.email_rounded},
            {'label': 'Phone', 'key': 'phone', 'icon': Icons.phone_rounded},
          ]),
    );
  }

  void _editPersonalInfo() {
    showDialog(
      context: context,
      builder:
          (context) => _buildEditDialog('Edit Personal Information', [
            {'label': 'Address', 'key': 'address', 'icon': Icons.home_rounded},
            {
              'label': 'Emergency Contact',
              'key': 'emergencyContact',
              'icon': Icons.emergency_rounded,
            },
          ]),
    );
  }

  void _editProfessionalInfo() {
    showDialog(
      context: context,
      builder:
          (context) => _buildEditDialog('Edit Professional Information', [
            {
              'label': 'Department',
              'key': 'department',
              'icon': Icons.apartment_rounded,
            },
            {
              'label': 'Education',
              'key': 'education',
              'icon': Icons.school_rounded,
            },
            {
              'label': 'Qualification',
              'key': 'qualification',
              'icon': Icons.verified_rounded,
            },
            {
              'label': 'Specialization',
              'key': 'specialization',
              'icon': Icons.star_rounded,
            },
          ]),
    );
  }

  Widget _buildEditDialog(String title, List<Map<String, dynamic>> fields) {
    final controllers = <String, TextEditingController>{};

    for (final field in fields) {
      controllers[field['key']] = TextEditingController(
        text: _profileData[field['key']].toString(),
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.edit_rounded, color: AppTheme.teacherColor),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              fields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: controllers[field['key']],
                    decoration: InputDecoration(
                      labelText: field['label'],
                      prefixIcon: Icon(field['icon']),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Update profile data
            for (final field in fields) {
              _profileData[field['key']] = controllers[field['key']]!.text;
            }
            setState(() {});
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.teacherColor,
          ),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _handleQuickAction(String action) {
    HapticFeedback.lightImpact();

    switch (action) {
      case 'Change Password':
        _showChangePasswordDialog();
        break;
      case 'Notification Settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
        );
        break;
      case 'Privacy Settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeacherSettingsScreen()),
        );
        break;
      case 'Download Profile':
        _downloadProfile();
        break;
      case 'Help & Support':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
        );
        break;
      case 'Logout':
        _showLogoutDialog();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$action functionality coming soon!'),
            backgroundColor: AppTheme.teacherColor,
          ),
        );
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.lock_rounded, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text('Change Password'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully!'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification Settings coming soon!'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy Settings coming soon!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _downloadProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading profile...'),
        backgroundColor: AppTheme.teacherColor,
      ),
    );
  }

  void _showHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support coming soon!'),
        backgroundColor: AppTheme.parentColor,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.logout_rounded, color: AppTheme.errorColor),
                const SizedBox(width: 8),
                const Text('Logout'),
              ],
            ),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate back to login screen
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/splash', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabController.dispose();
    super.dispose();
  }
}
