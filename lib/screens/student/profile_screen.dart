import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final Map<String, dynamic> _studentInfo = {
    'name': 'John Doe',
    'studentId': 'STU2024001',
    'email': 'john.doe@school.edu',
    'phone': '+1 (555) 123-4567',
    'grade': '12th Grade',
    'section': 'A',
    'rollNumber': '15',
    'dateOfBirth': '2006-03-15',
    'address': '123 Main St, Anytown, ST 12345',
    'parentName': 'Jane Doe',
    'parentPhone': '+1 (555) 987-6543',
    'emergencyContact': '+1 (555) 456-7890',
    'bloodGroup': 'O+',
    'profileImage': null,
  };

  final Map<String, dynamic> _academicInfo = {
    'currentGPA': 3.75,
    'overallGPA': 3.68,
    'totalCredits': 24,
    'completedCredits': 22,
    'currentSemester': 'Spring 2024',
    'expectedGraduation': 'May 2024',
    'rank': 12,
    'totalStudents': 150,
    'attendanceRate': 94.5,
    'disciplinaryRecord': 'Clean',
  };

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Honor Roll',
      'description': 'Maintained GPA above 3.5 for 3 consecutive semesters',
      'date': '2024-01-15',
      'icon': Icons.star_rounded,
      'color': AppTheme.warningColor,
    },
    {
      'title': 'Science Fair Winner',
      'description': 'First place in Regional Science Fair',
      'date': '2023-11-20',
      'icon': Icons.science_rounded,
      'color': AppTheme.successColor,
    },
    {
      'title': 'Perfect Attendance',
      'description': 'No absences for entire semester',
      'date': '2023-12-15',
      'icon': Icons.how_to_reg_rounded,
      'color': AppTheme.primaryColor,
    },
    {
      'title': 'Math Olympiad',
      'description': 'Qualified for State Math Olympiad',
      'date': '2023-10-10',
      'icon': Icons.calculate_rounded,
      'color': AppTheme.teacherColor,
    },
  ];

  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Mathematics',
      'grade': 'A-',
      'credits': 4,
      'color': AppTheme.primaryColor,
    },
    {
      'name': 'Physics',
      'grade': 'B+',
      'credits': 4,
      'color': AppTheme.successColor,
    },
    {
      'name': 'Chemistry',
      'grade': 'A',
      'credits': 3,
      'color': AppTheme.warningColor,
    },
    {
      'name': 'English',
      'grade': 'B',
      'credits': 3,
      'color': AppTheme.teacherColor,
    },
    {
      'name': 'History',
      'grade': 'A-',
      'credits': 3,
      'color': AppTheme.parentColor,
    },
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      'name': 'Chess Club',
      'role': 'President',
      'duration': '2022 - Present',
      'description': 'Leading the school chess team and organizing tournaments',
    },
    {
      'name': 'Debate Team',
      'role': 'Member',
      'duration': '2023 - Present',
      'description': 'Participating in inter-school debate competitions',
    },
    {
      'name': 'Science Club',
      'role': 'Vice President',
      'duration': '2022 - 2023',
      'description': 'Organized science exhibitions and workshops',
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

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
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildProfileHeader(),
                        const SizedBox(height: 16),
                        _buildAcademicStatsCard(),
                        const SizedBox(height: 16),
                        _buildPersonalInfoCard(),
                        const SizedBox(height: 16),
                        _buildSubjectsCard(),
                        const SizedBox(height: 16),
                        _buildAchievementsCard(),
                        const SizedBox(height: 16),
                        _buildActivitiesCard(),
                        const SizedBox(height: 16),
                        _buildQuickActionsCard(),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.studentColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.studentColor, AppTheme.studentColor.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: _editProfile,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.studentColor.withOpacity(0.1),
                child: _studentInfo['profileImage'] == null
                    ? Text(
                        _studentInfo['name'][0],
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.studentColor,
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          _studentInfo['profileImage'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.studentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _studentInfo['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_studentInfo['grade']} • Section ${_studentInfo['section']}',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.studentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Student ID: ${_studentInfo['studentId']}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProfileStat('GPA', _academicInfo['currentGPA'].toStringAsFixed(2)),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildProfileStat('Rank', '${_academicInfo['rank']}/${_academicInfo['totalStudents']}'),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildProfileStat('Attendance', '${_academicInfo['attendanceRate']}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.studentColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Academic Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Current GPA', _academicInfo['currentGPA'].toStringAsFixed(2), AppTheme.successColor),
              ),
              Expanded(
                child: _buildStatItem('Overall GPA', _academicInfo['overallGPA'].toStringAsFixed(2), AppTheme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Credits', '${_academicInfo['completedCredits']}/${_academicInfo['totalCredits']}', AppTheme.warningColor),
              ),
              Expanded(
                child: _buildStatItem('Semester', _academicInfo['currentSemester'], AppTheme.teacherColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _academicInfo['completedCredits'] / _academicInfo['totalCredits'],
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.studentColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Progress to Graduation: ${((_academicInfo['completedCredits'] / _academicInfo['totalCredits']) * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _editPersonalInfo,
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: AppTheme.studentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Email', _studentInfo['email'], Icons.email_rounded),
          _buildInfoRow('Phone', _studentInfo['phone'], Icons.phone_rounded),
          _buildInfoRow('Date of Birth', _studentInfo['dateOfBirth'], Icons.cake_rounded),
          _buildInfoRow('Address', _studentInfo['address'], Icons.location_on_rounded),
          _buildInfoRow('Blood Group', _studentInfo['bloodGroup'], Icons.bloodtype_rounded),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Emergency Contact',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Parent/Guardian', _studentInfo['parentName'], Icons.family_restroom_rounded),
          _buildInfoRow('Parent Phone', _studentInfo['parentPhone'], Icons.phone_rounded),
          _buildInfoRow('Emergency', _studentInfo['emergencyContact'], Icons.emergency_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.subject_rounded,
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Current Subjects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._subjects.map((subject) => _buildSubjectItem(subject)),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(Map<String, dynamic> subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: subject['color'],
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
                  subject['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${subject['credits']} Credits',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: subject['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subject['grade'],
              style: TextStyle(
                color: subject['color'],
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _showAllAchievements,
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.studentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._achievements.take(3).map((achievement) => _buildAchievementItem(achievement)),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              achievement['icon'],
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement['description'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            _formatDate(achievement['date']),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Extracurricular Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  activity['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.studentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activity['role'],
                  style: TextStyle(
                    color: AppTheme.studentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            activity['duration'],
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            activity['description'],
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    final actions = [
      {'title': 'Edit Profile', 'icon': Icons.edit_rounded, 'onTap': _editProfile},
      {'title': 'Change Password', 'icon': Icons.lock_rounded, 'onTap': _changePassword},
      {'title': 'Privacy Settings', 'icon': Icons.privacy_tip_rounded, 'onTap': _privacySettings},
      {'title': 'Download Transcript', 'icon': Icons.download_rounded, 'onTap': _downloadTranscript},
      {'title': 'Contact Support', 'icon': Icons.support_rounded, 'onTap': _contactSupport},
      {'title': 'Logout', 'icon': Icons.logout_rounded, 'onTap': _logout},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  (action['onTap'] as VoidCallback)();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        color: AppTheme.studentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child:                         Text(
                          action['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(studentInfo: _studentInfo),
      ),
    );
  }

  void _editPersonalInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Personal Information'),
        content: const Text('Personal information editing coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAllAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementsScreen(achievements: _achievements),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.print_rounded),
              title: const Text('Print Profile'),
              onTap: () {
                Navigator.pop(context);
                _printProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_rounded),
              title: const Text('QR Code'),
              onTap: () {
                Navigator.pop(context);
                _showQRCode();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _privacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _downloadTranscript() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transcript download coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support contact coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              // Implement logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile sharing coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _printProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print functionality coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _showQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code generation coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatelessWidget {
  final Map<String, dynamic> studentInfo;

  const EditProfileScreen({Key? key, required this.studentInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppTheme.studentColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Profile editing coming soon!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Achievements Screen
class AchievementsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementsScreen({Key? key, required this.achievements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Achievements'),
        backgroundColor: AppTheme.studentColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: achievement['color'],
                child: Icon(
                  achievement['icon'],
                  color: Colors.white,
                ),
              ),
              title: Text(achievement['title']),
              subtitle: Text(achievement['description']),
              trailing: Text(
                _formatDate(achievement['date']),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
} 