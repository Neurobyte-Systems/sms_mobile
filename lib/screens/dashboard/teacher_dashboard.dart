import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(),
                _buildClassesTab(),
                _buildAttendanceTab(),
                _buildGradesTab(),
                _buildProfileTab(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.teacherColor,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Grades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: AppTheme.teacherColor,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Teacher Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.teacherColor,
                    AppTheme.teacherColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.school,
                  size: 80,
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildTodaySchedule(),
              const SizedBox(height: 20),
              _buildQuickStats(),
              const SizedBox(height: 20),
              _buildRecentActivities(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySchedule() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: AppTheme.teacherColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final classes = [
                  {'time': '8:00 AM', 'subject': 'Mathematics', 'class': 'Class 10A'},
                  {'time': '10:00 AM', 'subject': 'Physics', 'class': 'Class 10B'},
                  {'time': '2:00 PM', 'subject': 'Chemistry', 'class': 'Class 11A'},
                ];
                final classInfo = classes[index];
                
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.teacherColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: AppTheme.teacherColor,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classInfo['time']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.teacherColor,
                            ),
                          ),
                          Text(
                            classInfo['subject']!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            classInfo['class']!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_ios),
                        iconSize: 16,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('My Classes', '8', Icons.class_, AppTheme.teacherColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Students', '240', Icons.people, AppTheme.studentColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Attendance', '95%', Icons.how_to_reg, AppTheme.successColor),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final activities = [
                  {'title': 'Assignment graded', 'subtitle': 'Mathematics Quiz - Class 10A', 'time': '1h ago'},
                  {'title': 'Attendance marked', 'subtitle': 'Physics Class - Class 10B', 'time': '2h ago'},
                  {'title': 'New assignment created', 'subtitle': 'Chemistry Lab Report', 'time': '1d ago'},
                  {'title': 'Parent message', 'subtitle': 'Inquiry about student progress', 'time': '2d ago'},
                ];
                final activity = activities[index];
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.teacherColor.withOpacity(0.1),
                    child: Icon(
                      Icons.check_circle,
                      color: AppTheme.teacherColor,
                    ),
                  ),
                  title: Text(activity['title']!),
                  subtitle: Text(activity['subtitle']!),
                  trailing: Text(
                    activity['time']!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassesTab() {
    return const Center(
      child: Text(
        'Classes Management\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return const Center(
      child: Text(
        'Attendance Tracking\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildGradesTab() {
    return const Center(
      child: Text(
        'Grades Management\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text(
        'Teacher Profile\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}