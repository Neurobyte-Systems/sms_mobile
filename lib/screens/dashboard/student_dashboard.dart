import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
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
                _buildAssignmentsTab(),
                _buildGradesTab(),
                _buildScheduleTab(),
                _buildProfileTab(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.studentColor,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Grades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
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
          backgroundColor: AppTheme.studentColor,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Student Dashboard',
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
                    AppTheme.studentColor,
                    AppTheme.studentColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
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
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildQuickStats(),
              const SizedBox(height: 20),
              _buildUpcomingAssignments(),
              const SizedBox(height: 20),
              _buildRecentGrades(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppTheme.studentColor.withOpacity(0.1),
              AppTheme.studentColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, John! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have 3 assignments due this week',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1; // Navigate to assignments
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.studentColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View Assignments'),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.studentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.school,
                color: AppTheme.studentColor,
                size: 40,
              ),
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
          child: _buildStatCard('GPA', '3.8', Icons.star, AppTheme.warningColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Attendance', '92%', Icons.how_to_reg, AppTheme.successColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Assignments', '15/18', Icons.assignment, AppTheme.studentColor),
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

  Widget _buildUpcomingAssignments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: AppTheme.studentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Assignments',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: const Text('View All'),
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
                final assignments = [
                  {
                    'title': 'Math Quiz',
                    'subject': 'Mathematics',
                    'due': 'Tomorrow',
                    'priority': 'high'
                  },
                  {
                    'title': 'History Essay',
                    'subject': 'History',
                    'due': '3 days',
                    'priority': 'medium'
                  },
                  {
                    'title': 'Science Lab Report',
                    'subject': 'Physics',
                    'due': '1 week',
                    'priority': 'low'
                  },
                ];
                final assignment = assignments[index];
                final priorityColor = assignment['priority'] == 'high' 
                    ? AppTheme.errorColor 
                    : assignment['priority'] == 'medium'
                        ? AppTheme.warningColor
                        : AppTheme.successColor;
                
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: priorityColor,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment['title']!,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              assignment['subject']!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Due in ${assignment['due']}',
                            style: TextStyle(
                              color: priorityColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: priorityColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              assignment['priority']!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildRecentGrades() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.grade,
                  color: AppTheme.studentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Grades',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final grades = [
                  {'subject': 'Mathematics', 'assignment': 'Algebra Test', 'grade': 'A-', 'score': '88%'},
                  {'subject': 'Physics', 'assignment': 'Lab Report', 'grade': 'B+', 'score': '85%'},
                  {'subject': 'History', 'assignment': 'Essay', 'grade': 'A', 'score': '92%'},
                  {'subject': 'Chemistry', 'assignment': 'Quiz', 'grade': 'B', 'score': '80%'},
                ];
                final grade = grades[index];
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getGradeColor(grade['grade']!).withOpacity(0.1),
                    child: Text(
                      grade['grade']!,
                      style: TextStyle(
                        color: _getGradeColor(grade['grade']!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(grade['assignment']!),
                  subtitle: Text(grade['subject']!),
                  trailing: Text(
                    grade['score']!,
                    style: TextStyle(
                      color: _getGradeColor(grade['grade']!),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A+':
        return AppTheme.successColor;
      case 'A-':
      case 'B+':
        return AppTheme.warningColor;
      case 'B':
      case 'B-':
        return AppTheme.primaryColor;
      default:
        return AppTheme.errorColor;
    }
  }

  Widget _buildAssignmentsTab() {
    return const Center(
      child: Text(
        'Assignments\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildGradesTab() {
    return const Center(
      child: Text(
        'Grades Overview\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return const Center(
      child: Text(
        'Class Schedule\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text(
        'Student Profile\nComing Soon!',
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