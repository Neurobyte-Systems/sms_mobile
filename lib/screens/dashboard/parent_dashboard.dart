import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedChild = 'John Doe';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, dynamic>> _children = {
    'John Doe': {
      'class': 'Class 10A',
      'attendance': '95%',
      'gpa': '3.8',
      'assignments': '15/18',
      'avatar': 'assets/images/student1.jpg',
    },
    'Jane Doe': {
      'class': 'Class 8B',
      'attendance': '98%',
      'gpa': '4.0',
      'assignments': '12/12',
      'avatar': 'assets/images/student2.jpg',
    },
  };

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
                _buildAttendanceTab(),
                _buildGradesTab(),
                _buildMessagesTab(),
                _buildProfileTab(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.parentColor,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
            icon: Icon(Icons.message),
            label: 'Messages',
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
          backgroundColor: AppTheme.parentColor,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Parent Dashboard',
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
                    AppTheme.parentColor,
                    AppTheme.parentColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.family_restroom,
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
              _buildChildSelector(),
              const SizedBox(height: 20),
              _buildChildOverview(),
              const SizedBox(height: 20),
              _buildQuickStats(),
              const SizedBox(height: 20),
              _buildRecentUpdates(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildChildSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Child',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _children.keys.map((childName) {
                  final isSelected = _selectedChild == childName;
                  final childData = _children[childName]!;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedChild = childName;
                      });
                    },
                    child: AnimatedContainer(
                      duration: AppConstants.shortAnimation,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.parentColor.withOpacity(0.1)
                            : Colors.grey.shade50,
                        border: Border.all(
                          color: isSelected 
                              ? AppTheme.parentColor 
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppTheme.parentColor.withOpacity(0.1),
                            child: Text(
                              childName.split(' ').map((n) => n[0]).join(),
                              style: TextStyle(
                                color: AppTheme.parentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            childName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? AppTheme.parentColor 
                                  : Colors.black87,
                            ),
                          ),
                          Text(
                            childData['class'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildOverview() {
    final childData = _children[_selectedChild]!;
    
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppTheme.parentColor.withOpacity(0.1),
              AppTheme.parentColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.parentColor.withOpacity(0.1),
              child: Text(
                _selectedChild.split(' ').map((n) => n[0]).join(),
                style: TextStyle(
                  color: AppTheme.parentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedChild,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    childData['class'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMiniStat('GPA', childData['gpa'], AppTheme.warningColor),
                      const SizedBox(width: 16),
                      _buildMiniStat('Attendance', childData['attendance'], AppTheme.successColor),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3; // Navigate to messages
                    });
                  },
                  icon: const Icon(Icons.message),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.parentColor.withOpacity(0.1),
                    foregroundColor: AppTheme.parentColor,
                  ),
                ),
                const Text('Message\nTeacher', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final childData = _children[_selectedChild]!;
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Assignments', childData['assignments'], Icons.assignment, AppTheme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Attendance', childData['attendance'], Icons.how_to_reg, AppTheme.successColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('GPA', childData['gpa'], Icons.star, AppTheme.warningColor),
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

  Widget _buildRecentUpdates() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: AppTheme.parentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Updates',
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
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final updates = [
                  {
                    'title': 'New Grade Posted',
                    'subtitle': 'Mathematics Quiz - A- (88%)',
                    'time': '2h ago',
                    'icon': Icons.grade,
                    'color': AppTheme.successColor,
                  },
                  {
                    'title': 'Attendance Alert',
                    'subtitle': 'Marked present for today',
                    'time': '4h ago',
                    'icon': Icons.how_to_reg,
                    'color': AppTheme.primaryColor,
                  },
                  {
                    'title': 'Assignment Due',
                    'subtitle': 'History Essay due tomorrow',
                    'time': '1d ago',
                    'icon': Icons.assignment,
                    'color': AppTheme.warningColor,
                  },
                  {
                    'title': 'Teacher Message',
                    'subtitle': 'Progress update from Math teacher',
                    'time': '2d ago',
                    'icon': Icons.message,
                    'color': AppTheme.parentColor,
                  },
                ];
                final update = updates[index];
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (update['color'] as Color).withOpacity(0.1),
                    child: Icon(
                      update['icon'] as IconData,
                      color: update['color'] as Color,
                      size: 20,
                    ),
                  ),
                  title: Text(update['title'] as String),
                  subtitle: Text(update['subtitle'] as String),
                  trailing: Text(
                    update['time'] as String,
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
        'Grades Overview\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildMessagesTab() {
    return const Center(
      child: Text(
        'Messages & Communication\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text(
        'Parent Profile\nComing Soon!',
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