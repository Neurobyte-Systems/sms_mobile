import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
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
                _buildStudentsTab(),
                _buildTeachersTab(),
                _buildAnalyticsTab(),
                _buildProfileTab(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.adminColor,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Teachers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
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
          backgroundColor: AppTheme.adminColor,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Admin Dashboard',
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
                    AppTheme.adminColor,
                    AppTheme.adminColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.admin_panel_settings,
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
              _buildStatsGrid(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildRecentActivity(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {'title': 'Total Students', 'value': '1,234', 'icon': Icons.people, 'color': AppTheme.studentColor},
      {'title': 'Total Teachers', 'value': '89', 'icon': Icons.school, 'color': AppTheme.teacherColor},
      {'title': 'Total Parents', 'value': '856', 'icon': Icons.family_restroom, 'color': AppTheme.parentColor},
      {'title': 'Revenue', 'value': '₵45,678', 'icon': Icons.monetization_on, 'color': AppTheme.successColor},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 24,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  stat['value'] as String,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stat['title'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionChip('Add Student', Icons.person_add, AppTheme.studentColor),
                _buildActionChip('Add Teacher', Icons.person_add, AppTheme.teacherColor),
                _buildActionChip('Send Notice', Icons.notifications, AppTheme.warningColor),
                _buildActionChip('View Reports', Icons.analytics, AppTheme.primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: color),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label functionality coming soon!')),
        );
      },
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.adminColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: AppTheme.adminColor,
                    ),
                  ),
                  title: Text('New student registered'),
                  subtitle: Text('John Doe joined Class 10A'),
                  trailing: Text(
                    '2h ago',
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

  Widget _buildStudentsTab() {
    return const Center(
      child: Text(
        'Students Management\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildTeachersTab() {
    return const Center(
      child: Text(
        'Teachers Management\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text(
        'Analytics Dashboard\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text(
        'Admin Profile\nComing Soon!',
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