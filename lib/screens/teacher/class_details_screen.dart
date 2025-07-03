import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class ClassDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> classData;

  const ClassDetailsScreen({super.key, required this.classData});

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _tabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int _selectedTabIndex = 0;
  final List<String> _tabs = [
    'Overview',
    'Students',
    'Assignments',
    'Attendance',
  ];

  // Sample data for demonstration
  final List<Map<String, dynamic>> _students = [
    {
      'id': '1',
      'name': 'Alice Johnson',
      'rollNumber': 'STU001',
      'avatar': null,
      'grade': 'A',
      'attendance': 95.2,
      'lastSeen': '2024-01-15',
      'status': 'active',
      'parentPhone': '+233 24 123 4567',
      'parentEmail': 'alice.parent@email.com',
    },
    {
      'id': '2',
      'name': 'Bob Smith',
      'rollNumber': 'STU002',
      'avatar': null,
      'grade': 'B+',
      'attendance': 88.7,
      'lastSeen': '2024-01-14',
      'status': 'active',
      'parentPhone': '+233 24 765 4321',
      'parentEmail': 'bob.parent@email.com',
    },
    {
      'id': '3',
      'name': 'Carol Davis',
      'rollNumber': 'STU003',
      'avatar': null,
      'grade': 'A-',
      'attendance': 92.1,
      'lastSeen': '2024-01-15',
      'status': 'active',
      'parentPhone': '+233 24 987 6543',
      'parentEmail': 'carol.parent@email.com',
    },
    {
      'id': '4',
      'name': 'David Wilson',
      'rollNumber': 'STU004',
      'avatar': null,
      'grade': 'B',
      'attendance': 85.5,
      'lastSeen': '2024-01-13',
      'status': 'warning',
      'parentPhone': '+233 24 456 7890',
      'parentEmail': 'david.parent@email.com',
    },
  ];

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': '1',
      'title': 'Chapter 5 Quiz',
      'type': 'Quiz',
      'dueDate': '2024-01-20',
      'status': 'active',
      'submissions': 18,
      'totalStudents': 28,
      'averageScore': 82.5,
      'maxScore': 100,
    },
    {
      'id': '2',
      'title': 'Homework - Problem Set 3',
      'type': 'Homework',
      'dueDate': '2024-01-18',
      'status': 'grading',
      'submissions': 25,
      'totalStudents': 28,
      'averageScore': 78.3,
      'maxScore': 50,
    },
    {
      'id': '3',
      'title': 'Mid-term Project',
      'type': 'Project',
      'dueDate': '2024-01-25',
      'status': 'upcoming',
      'submissions': 3,
      'totalStudents': 28,
      'averageScore': 0,
      'maxScore': 200,
    },
  ];

  final List<Map<String, dynamic>> _attendanceHistory = [
    {
      'date': '2024-01-15',
      'present': 26,
      'absent': 2,
      'late': 0,
      'percentage': 92.8,
    },
    {
      'date': '2024-01-12',
      'present': 25,
      'absent': 1,
      'late': 2,
      'percentage': 96.4,
    },
    {
      'date': '2024-01-10',
      'present': 27,
      'absent': 1,
      'late': 0,
      'percentage': 96.4,
    },
    {
      'date': '2024-01-08',
      'present': 24,
      'absent': 3,
      'late': 1,
      'percentage': 89.2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _tabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildClassHeader(),
                  _buildTabSelector(),
                  Expanded(child: _buildTabContent()),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.classData['subject'] ?? 'Class Details',
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3748),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFF2D3748),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, color: Color(0xFF2D3748)),
          onPressed: _shareClass,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildClassHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.classData['color'] as Color,
            (widget.classData['color'] as Color).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (widget.classData['color'] as Color).withOpacity(0.3),
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getSubjectIcon(widget.classData['subject']),
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.classData['subject'] ?? 'Subject',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.classData['class'] ?? 'Class',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.classData['isActive'] == true ? 'ACTIVE' : 'INACTIVE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildHeaderStat(
                Icons.people_rounded,
                '${widget.classData['students'] ?? 0}',
                'Students',
              ),
              _buildHeaderStat(
                Icons.room_rounded,
                widget.classData['room'] ?? 'N/A',
                'Room',
              ),
              _buildHeaderStat(
                Icons.access_time_rounded,
                widget.classData['time'] ?? 'N/A',
                'Time',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children:
            _tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = _selectedTabIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                    HapticFeedback.lightImpact();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _buildOverviewTab(),
          _buildStudentsTab(),
          _buildAssignmentsTab(),
          _buildAttendanceTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              _buildStatCard(
                'Average Grade',
                '${widget.classData['averageGrade'] ?? 0}%',
                Icons.grade_rounded,
                AppTheme.successColor,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Attendance',
                '${widget.classData['attendance'] ?? 0}%',
                Icons.how_to_reg_rounded,
                AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Assignments',
                '${widget.classData['assignments'] ?? 0}',
                Icons.assignment_rounded,
                AppTheme.warningColor,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Next Class',
                widget.classData['nextClass'] ?? 'N/A',
                Icons.schedule_rounded,
                AppTheme.teacherColor,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity
          _buildSectionHeader('Recent Activity'),
          const SizedBox(height: 16),
          _buildActivityList(),

          const SizedBox(height: 24),

          // Class Schedule
          _buildSectionHeader('Class Schedule'),
          const SizedBox(height: 16),
          _buildScheduleCard(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Icon(
                  Icons.trending_up_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {
        'title': 'Assignment submitted',
        'description': 'Alice Johnson submitted Chapter 5 Quiz',
        'time': '2 hours ago',
        'icon': Icons.assignment_turned_in_rounded,
        'color': AppTheme.successColor,
      },
      {
        'title': 'New assignment created',
        'description': 'Mid-term Project assigned to class',
        'time': '1 day ago',
        'icon': Icons.add_task_rounded,
        'color': AppTheme.primaryColor,
      },
      {
        'title': 'Attendance taken',
        'description': '26 out of 28 students present',
        'time': '2 days ago',
        'icon': Icons.how_to_reg_rounded,
        'color': AppTheme.warningColor,
      },
    ];

    return Column(
      children:
          activities.map((activity) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (activity['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: activity['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity['description'] as String,
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
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Weekly Schedule',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children:
                (widget.classData['days'] as List<String>? ?? []).map((day) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Time: ${widget.classData['time'] ?? 'N/A'}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.room_rounded, color: Colors.grey.shade600, size: 16),
              const SizedBox(width: 8),
              Text(
                'Room: ${widget.classData['room'] ?? 'N/A'}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search students...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              return _buildStudentCard(student);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final statusColor =
        student['status'] == 'active'
            ? AppTheme.successColor
            : student['status'] == 'warning'
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                student['avatar'] != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(student['avatar'], fit: BoxFit.cover),
                    )
                    : Center(
                      child: Text(
                        student['name'].split(' ').map((n) => n[0]).join(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Roll: ${student['rollNumber']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStudentStat('Grade', student['grade']),
                    const SizedBox(width: 16),
                    _buildStudentStat(
                      'Attendance',
                      '${student['attendance']}%',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _contactParent(student),
                icon: const Icon(Icons.phone_rounded),
                color: AppTheme.primaryColor,
              ),
              IconButton(
                onPressed: () => _viewStudentDetails(student),
                icon: const Icon(Icons.arrow_forward_rounded),
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              const Text(
                'Assignments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _createAssignment,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _assignments.length,
            itemBuilder: (context, index) {
              final assignment = _assignments[index];
              return _buildAssignmentCard(assignment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    final statusColor =
        assignment['status'] == 'active'
            ? AppTheme.successColor
            : assignment['status'] == 'grading'
            ? AppTheme.warningColor
            : AppTheme.primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getAssignmentIcon(assignment['type']),
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assignment['type'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  assignment['status'].toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAssignmentStat(
                'Due Date',
                assignment['dueDate'],
                Icons.calendar_today_rounded,
              ),
              _buildAssignmentStat(
                'Submissions',
                '${assignment['submissions']}/${assignment['totalStudents']}',
                Icons.assignment_turned_in_rounded,
              ),
              _buildAssignmentStat(
                'Average',
                '${assignment['averageScore']}%',
                Icons.grade_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewAssignmentDetails(assignment),
                  icon: const Icon(Icons.visibility_rounded, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _gradeAssignment(assignment),
                  icon: const Icon(Icons.grade_rounded, size: 16),
                  label: const Text('Grade'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentStat(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              const Text(
                'Attendance History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _takeAttendance,
                icon: const Icon(Icons.how_to_reg_rounded, size: 16),
                label: const Text('Take Attendance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _attendanceHistory.length,
            itemBuilder: (context, index) {
              final attendance = _attendanceHistory[index];
              return _buildAttendanceCard(attendance);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> attendance) {
    final percentage = attendance['percentage'] as double;
    final statusColor =
        percentage >= 90
            ? AppTheme.successColor
            : percentage >= 75
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.how_to_reg_rounded,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${attendance['date']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Attendance Rate: ${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAttendanceStat(
                'Present',
                '${attendance['present']}',
                AppTheme.successColor,
              ),
              _buildAttendanceStat(
                'Absent',
                '${attendance['absent']}',
                AppTheme.errorColor,
              ),
              _buildAttendanceStat(
                'Late',
                '${attendance['late']}',
                AppTheme.warningColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final actions = [
      {
        'icon': Icons.how_to_reg_rounded,
        'label': 'Take Attendance',
        'color': AppTheme.successColor,
        'onPressed': _takeAttendance,
      },
      {
        'icon': Icons.assignment_rounded,
        'label': 'Create Assignment',
        'color': AppTheme.primaryColor,
        'onPressed': _createAssignment,
      },
      {
        'icon': Icons.message_rounded,
        'label': 'Send Message',
        'color': AppTheme.parentColor,
        'onPressed': _sendMessage,
      },
    ];

    return FloatingActionButton.extended(
      onPressed: () => _showQuickActions(actions),
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Quick Actions',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper Methods
  IconData _getSubjectIcon(String? subject) {
    switch (subject?.toLowerCase()) {
      case 'mathematics':
      case 'math':
        return Icons.calculate_rounded;
      case 'physics':
        return Icons.science_rounded;
      case 'chemistry':
        return Icons.biotech_rounded;
      case 'biology':
        return Icons.eco_rounded;
      case 'english':
        return Icons.book_rounded;
      case 'history':
        return Icons.history_edu_rounded;
      case 'geography':
        return Icons.public_rounded;
      case 'computer science':
        return Icons.computer_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  IconData _getAssignmentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Icons.quiz_rounded;
      case 'homework':
        return Icons.home_work_rounded;
      case 'project':
        return Icons.engineering_rounded;
      case 'exam':
        return Icons.assignment_rounded;
      default:
        return Icons.task_rounded;
    }
  }

  // Action Methods
  void _shareClass() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing ${widget.classData['subject']} class details...',
        ),
        backgroundColor: AppTheme.successColor,
      ),
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
                _buildOptionItem(Icons.edit_rounded, 'Edit Class', () {}),
                _buildOptionItem(Icons.copy_rounded, 'Duplicate Class', () {}),
                _buildOptionItem(Icons.archive_rounded, 'Archive Class', () {}),
                _buildOptionItem(Icons.delete_rounded, 'Delete Class', () {}),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _contactParent(Map<String, dynamic> student) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${student['name']}\'s parent...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _viewStudentDetails(Map<String, dynamic> student) {
    HapticFeedback.lightImpact();
    // Navigate to student details screen
  }

  void _createAssignment() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening assignment creation...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _viewAssignmentDetails(Map<String, dynamic> assignment) {
    HapticFeedback.lightImpact();
    // Navigate to assignment details screen
  }

  void _gradeAssignment(Map<String, dynamic> assignment) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening grading for ${assignment['title']}...'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _takeAttendance() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening attendance screen...'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _sendMessage() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening message composer...'),
        backgroundColor: AppTheme.parentColor,
      ),
    );
  }

  void _showQuickActions(List<Map<String, dynamic>> actions) {
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
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 20),
                ...actions.map((action) {
                  return ListTile(
                    leading: Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                    ),
                    title: Text(action['label'] as String),
                    onTap: () {
                      Navigator.pop(context);
                      (action['onPressed'] as VoidCallback)();
                    },
                  );
                }).toList(),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
