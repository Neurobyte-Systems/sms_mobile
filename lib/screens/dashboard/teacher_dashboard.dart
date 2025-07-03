import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../teacher/classes_screen.dart';
import '../teacher/attendance_screen.dart';
import '../teacher/grades_screen.dart';
import '../teacher/assignments_screen.dart';
import '../teacher/messages_screen.dart';
import '../teacher/profile_screen.dart';
import '../teacher/schedule_screen.dart';
import '../teacher/notes_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _animationController;
  late AnimationController _counterController;
  late AnimationController _fabController;
  late AnimationController _scheduleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _counterAnimation;
  late Animation<double> _scheduleAnimation;

  // Sample data with animations
  final List<Map<String, dynamic>> _statsData = [
    {
      'title': 'My Classes',
      'value': 8,
      'icon': Icons.class_rounded,
      'color': AppTheme.teacherColor,
      'change': '+1',
      'isPositive': true,
    },
    {
      'title': 'Total Students',
      'value': 240,
      'icon': Icons.people_rounded,
      'color': AppTheme.studentColor,
      'change': '+12',
      'isPositive': true,
    },
    {
      'title': 'Assignments',
      'value': 15,
      'icon': Icons.assignment_rounded,
      'color': AppTheme.primaryColor,
      'change': '+3',
      'isPositive': true,
    },
    {
      'title': 'Avg Attendance',
      'value': 95,
      'icon': Icons.how_to_reg_rounded,
      'color': AppTheme.successColor,
      'change': '+2.1%',
      'isPositive': true,
    },
  ];

  final List<Map<String, dynamic>> _todaySchedule = [
    {
      'time': '08:00 AM',
      'subject': 'Mathematics',
      'class': 'Class 10A',
      'room': 'Room 101',
      'duration': '1h 30m',
      'status': 'upcoming',
      'studentsCount': 28,
    },
    {
      'time': '10:00 AM',
      'subject': 'Physics',
      'class': 'Class 10B',
      'room': 'Lab 201',
      'duration': '1h 30m',
      'status': 'current',
      'studentsCount': 25,
    },
    {
      'time': '02:00 PM',
      'subject': 'Chemistry',
      'class': 'Class 11A',
      'room': 'Lab 301',
      'duration': '2h',
      'status': 'upcoming',
      'studentsCount': 30,
    },
    {
      'time': '04:00 PM',
      'subject': 'Study Hall',
      'class': 'Mixed Groups',
      'room': 'Library',
      'duration': '1h',
      'status': 'upcoming',
      'studentsCount': 15,
    },
  ];

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

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scheduleController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    _counterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOutCubic),
    );

    _scheduleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scheduleController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _counterController.forward();
    _scheduleController.forward();
  }

  void _onItemTapped(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });

    // Reset animations for new tab
    _animationController.reset();
    _animationController.forward();
  }

  void _onFabPressed() {
    HapticFeedback.mediumImpact();
    _fabController.forward().then((_) {
      _fabController.reverse();
    });

    _showQuickActionSheet();
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildQuickActionSheet(context),
    );
  }

  // Navigation methods
  void _navigateToTakeAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AttendanceScreen()),
    );
  }

  void _navigateToAddAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssignmentsScreen()),
    );
  }

  void _navigateToGradePapers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GradesScreen()),
    );
  }

  void _navigateToMessageParents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MessagesScreen()),
    );
  }

  void _navigateToClassNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotesScreen()),
    );
  }

  void _navigateToSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScheduleScreen()),
    );
  }

  void _openDrawer() {
    HapticFeedback.lightImpact();
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openNotifications() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => _buildNotificationsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _buildHomeTab(),
                    const ClassesScreen(),
                    const AttendanceScreen(),
                    const GradesScreen(),
                    const ProfileScreen(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.teacherColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.teacherColor,
                    AppTheme.teacherColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sarah Wilson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Mathematics Teacher',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            _buildDrawerItem(
              icon: Icons.class_rounded,
              title: 'My Classes',
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            _buildDrawerItem(
              icon: Icons.assignment_rounded,
              title: 'Assignments',
              onTap: () {
                Navigator.pop(context);
                _navigateToAddAssignment();
              },
            ),
            _buildDrawerItem(
              icon: Icons.schedule_rounded,
              title: 'Schedule',
              onTap: () {
                Navigator.pop(context);
                _navigateToSchedule();
              },
            ),
            _buildDrawerItem(
              icon: Icons.note_alt_rounded,
              title: 'Class Notes',
              onTap: () {
                Navigator.pop(context);
                _navigateToClassNotes();
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            _buildDrawerItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.teacherColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildHomeTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.teacherColor.withOpacity(0.05), Colors.white],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildTodayScheduleCard(),
                const SizedBox(height: 24),
                _buildStatsGrid(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildRecentActivities(),
                const SizedBox(height: 100), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
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
        icon: const Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: _openDrawer,
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_rounded, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          onPressed: _openNotifications,
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
              // Floating books icon
              Positioned(
                top: 60,
                left: 50,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 40,
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
                              Icons.school_rounded,
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
                                  'Teacher Dashboard',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Inspiring Young Minds',
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

  Widget _buildWelcomeCard() {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 4), // Navigate to profile
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade50]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, Teacher! 🌟',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have 4 classes scheduled for today',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildQuickMetric(
                        'Next Class',
                        '10:00 AM',
                        Icons.schedule_rounded,
                      ),
                      const SizedBox(width: 16),
                      _buildQuickMetric('Room', 'Lab 201', Icons.room_rounded),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.teacherColor.withOpacity(0.2),
                    AppTheme.teacherColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.school_rounded,
                color: AppTheme.teacherColor,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMetric(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.teacherColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.teacherColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.teacherColor),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.teacherColor,
                  fontSize: 12,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayScheduleCard() {
    return GestureDetector(
      onTap: _navigateToSchedule,
      child: Container(
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
                  Icons.today_rounded,
                  color: AppTheme.teacherColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_todaySchedule.length} Classes',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _scheduleController,
              builder: (context, child) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      _todaySchedule.length > 2 ? 2 : _todaySchedule.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(30 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: _buildScheduleItem(_todaySchedule[index]),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            if (_todaySchedule.length > 2) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: _navigateToSchedule,
                child: Text(
                  'View All Classes',
                  style: TextStyle(
                    color: AppTheme.teacherColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> schedule) {
    final bool isCurrent = schedule['status'] == 'current';
    final Color statusColor =
        isCurrent ? AppTheme.successColor : AppTheme.teacherColor;

    return GestureDetector(
      onTap: () {
        // Navigate to specific class details
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClassesScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isCurrent
                    ? [
                      AppTheme.successColor.withOpacity(0.1),
                      AppTheme.successColor.withOpacity(0.05),
                    ]
                    : [
                      AppTheme.teacherColor.withOpacity(0.05),
                      Colors.transparent,
                    ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.2),
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Time column
            Container(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule['time'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    schedule['duration'],
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Subject details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule['subject'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.class_rounded,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        schedule['class'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.room_rounded,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        schedule['room'],
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

            // Students count and action
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_rounded, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule['studentsCount']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: _statsData.length,
      itemBuilder: (context, index) {
        final stat = _statsData[index];
        return GestureDetector(
          onTap: () => _navigateToStatDetail(stat['title']),
          child: _buildAnimatedStatCard(stat, index),
        );
      },
    );
  }

  void _navigateToStatDetail(String statTitle) {
    switch (statTitle) {
      case 'My Classes':
        setState(() => _selectedIndex = 1);
        break;
      case 'Total Students':
        setState(() => _selectedIndex = 1);
        break;
      case 'Assignments':
        _navigateToAddAssignment();
        break;
      case 'Avg Attendance':
        setState(() => _selectedIndex = 2);
        break;
    }
  }

  Widget _buildAnimatedStatCard(Map<String, dynamic> stat, int index) {
    return AnimatedBuilder(
      animation: _counterController,
      builder: (context, child) {
        final animatedValue =
            stat['title'] == 'Avg Attendance'
                ? (stat['value'] * _counterAnimation.value).round()
                : (stat['value'] * _counterAnimation.value).round();

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
                    Row(
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
                                color: (stat['color'] as Color).withOpacity(
                                  0.3,
                                ),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (stat['isPositive'] as bool)
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                (stat['isPositive'] as bool)
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                size: 12,
                                color:
                                    (stat['isPositive'] as bool)
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                stat['change'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (stat['isPositive'] as bool)
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      stat['title'] == 'Avg Attendance'
                          ? '${animatedValue}%'
                          : animatedValue.toString(),
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

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Take Attendance',
        'icon': Icons.how_to_reg_rounded,
        'color': AppTheme.successColor,
        'onTap': _navigateToTakeAttendance,
      },
      {
        'title': 'Add Assignment',
        'icon': Icons.assignment_turned_in_rounded,
        'color': AppTheme.primaryColor,
        'onTap': _navigateToAddAssignment,
      },
      {
        'title': 'Grade Papers',
        'icon': Icons.grade_rounded,
        'color': AppTheme.warningColor,
        'onTap': _navigateToGradePapers,
      },
      {
        'title': 'Message Parents',
        'icon': Icons.message_rounded,
        'color': AppTheme.parentColor,
        'onTap': _navigateToMessageParents,
      },
      {
        'title': 'Class Notes',
        'icon': Icons.note_alt_rounded,
        'color': AppTheme.teacherColor,
        'onTap': _navigateToClassNotes,
      },
      {
        'title': 'Schedule',
        'icon': Icons.schedule_rounded,
        'color': Colors.indigo,
        'onTap': _navigateToSchedule,
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
                Icons.flash_on_rounded,
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
            onTap: () {
              HapticFeedback.lightImpact();
              action['onTap']();
            },
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

  Widget _buildRecentActivities() {
    final activities = [
      {
        'title': 'Assignment graded',
        'subtitle': 'Mathematics Quiz - Class 10A (28 papers)',
        'time': '1 hour ago',
        'icon': Icons.grade_rounded,
        'color': AppTheme.successColor,
      },
      {
        'title': 'Attendance marked',
        'subtitle': 'Physics Class - 25/25 students present',
        'time': '2 hours ago',
        'icon': Icons.how_to_reg_rounded,
        'color': AppTheme.primaryColor,
      },
      {
        'title': 'Parent message sent',
        'subtitle': 'Progress update to 5 parents',
        'time': '4 hours ago',
        'icon': Icons.message_rounded,
        'color': AppTheme.parentColor,
      },
      {
        'title': 'New assignment created',
        'subtitle': 'Chemistry Lab Report for Class 11A',
        'time': '1 day ago',
        'icon': Icons.assignment_turned_in_rounded,
        'color': AppTheme.teacherColor,
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
                Icons.history_rounded,
                color: AppTheme.teacherColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Show full activity log
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.teacherColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 400 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (activity['color'] as Color).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (activity['color'] as Color).withOpacity(
                              0.1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: activity['color'] as Color,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: (activity['color'] as Color)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                activity['icon'] as IconData,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    activity['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              activity['time'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.teacherColor,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_rounded),
            activeIcon: Icon(Icons.class_rounded),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg_rounded),
            activeIcon: Icon(Icons.how_to_reg_rounded),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade_rounded),
            activeIcon: Icon(Icons.grade_rounded),
            label: 'Grades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_fabController.value * 0.1),
          child: FloatingActionButton(
            heroTag: 'quick_actions_fab_teacher',
            onPressed: _onFabPressed,
            backgroundColor: AppTheme.teacherColor,
            elevation: 8,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
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
          Text(
            'Quick Add',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionItem(
                'Assignment',
                Icons.assignment_turned_in_rounded,
                AppTheme.primaryColor,
                _navigateToAddAssignment,
              ),
              _buildQuickActionItem(
                'Attendance',
                Icons.how_to_reg_rounded,
                AppTheme.successColor,
                _navigateToTakeAttendance,
              ),
              _buildQuickActionItem(
                'Grade',
                Icons.grade_rounded,
                AppTheme.warningColor,
                _navigateToGradePapers,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsDialog() {
    final notifications = [
      {
        'title': 'Assignment Submitted',
        'message': '3 new assignments submitted by Class 10A',
        'time': '5 min ago',
        'type': 'assignment',
      },
      {
        'title': 'Parent Message',
        'message': 'Message from John\'s parent about homework',
        'time': '1 hour ago',
        'type': 'message',
      },
      {
        'title': 'Class Reminder',
        'message': 'Physics class starts in 30 minutes',
        'time': '30 min ago',
        'type': 'reminder',
      },
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.notifications_rounded, color: AppTheme.teacherColor),
          const SizedBox(width: 8),
          const Text('Notifications'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.teacherColor.withOpacity(0.1),
                child: Icon(
                  _getNotificationIcon(notification['type'] as String),
                  color: AppTheme.teacherColor,
                ),
              ),
              title: Text(
                notification['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['message'] as String),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'] as String,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'assignment':
        return Icons.assignment_rounded;
      case 'message':
        return Icons.message_rounded;
      case 'reminder':
        return Icons.access_time_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate back to login/auth screen
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
    _counterController.dispose();
    _fabController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }
}
