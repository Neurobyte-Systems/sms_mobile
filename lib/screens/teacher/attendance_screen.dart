import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class AttendanceScreen extends StatefulWidget {
  final String attendanceType; // 'daily' or 'subject'
  final String? subject; // Subject name for subject-based attendance
  final String? className; // Class name for subject-based attendance
  
  const AttendanceScreen({
    Key? key,
    this.attendanceType = 'daily',
    this.subject,
    this.className,
  }) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedAttendanceType = 'daily';
  String _selectedClass = 'Class 10A - Mathematics';
  String _selectedSubject = 'Mathematics';
  DateTime _selectedDate = DateTime.now();
  bool _isMarkingMode = false;

  final List<String> _attendanceTypes = ['daily', 'subject'];
  final List<String> _classes = [
    'Class 10A - Mathematics',
    'Class 10B - Physics',
    'Class 11A - Chemistry',
    'Class 12A - Advanced Math',
  ];

  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
  ];

  final List<Map<String, dynamic>> _students = [
    {
      'id': '1',
      'name': 'John Doe',
      'rollNumber': '001',
      'status': 'present',
      'image': null,
      'parentPhone': '+233 24 123 4567',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'rollNumber': '002',
      'status': 'present',
      'image': null,
      'parentPhone': '+233 24 234 5678',
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'rollNumber': '003',
      'status': 'absent',
      'image': null,
      'parentPhone': '+233 24 345 6789',
    },
    {
      'id': '4',
      'name': 'Sarah Wilson',
      'rollNumber': '004',
      'status': 'present',
      'image': null,
      'parentPhone': '+233 24 456 7890',
    },
    {
      'id': '5',
      'name': 'David Brown',
      'rollNumber': '005',
      'status': 'late',
      'image': null,
      'parentPhone': '+233 24 567 8901',
    },
    {
      'id': '6',
      'name': 'Emily Davis',
      'rollNumber': '006',
      'status': 'present',
      'image': null,
      'parentPhone': '+233 24 678 9012',
    },
    {
      'id': '7',
      'name': 'Alex Garcia',
      'rollNumber': '007',
      'status': 'absent',
      'image': null,
      'parentPhone': '+233 24 789 0123',
    },
    {
      'id': '8',
      'name': 'Lisa Martinez',
      'rollNumber': '008',
      'status': 'present',
      'image': null,
      'parentPhone': '+233 24 890 1234',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeFromParams();
    _initializeAnimations();
  }

  void _initializeFromParams() {
    _selectedAttendanceType = widget.attendanceType;
    if (widget.subject != null) {
      _selectedSubject = widget.subject!;
    }
    if (widget.className != null) {
      _selectedClass = widget.className!;
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  int get _presentCount => _students.where((s) => s['status'] == 'present').length;
  int get _absentCount => _students.where((s) => s['status'] == 'absent').length;
  int get _lateCount => _students.where((s) => s['status'] == 'late').length;
  double get _attendancePercentage => (_presentCount + _lateCount) / _students.length * 100;

  String get _screenTitle {
    return _selectedAttendanceType == 'daily' ? 'Daily Attendance' : 'Subject Attendance';
  }

  String get _screenSubtitle {
    return _selectedAttendanceType == 'daily' 
        ? 'Morning attendance for all subjects'
        : 'Attendance for $_selectedSubject';
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
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(child: _buildHeader()),

                  // Attendance Type Selector
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildAttendanceTypeSelector(),
                        const SizedBox(height: 16),
                        _buildClassAndSubjectSelector(),
                        const SizedBox(height: 16),
                        _buildDateSelector(),
                        const SizedBox(height: 16),
                        _buildStatsCards(),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Students List Header
                  SliverToBoxAdapter(child: _buildStudentsListHeader()),

                  // Students List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: _buildStudentCard(_students[index], index),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _students.length,
                    ),
                  ),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
        _screenTitle,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3748),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D3748)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isMarkingMode ? Icons.done_rounded : Icons.edit_rounded,
            color: AppTheme.successColor,
          ),
          onPressed: _toggleMarkingMode,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successColor.withOpacity(0.1),
            Colors.transparent,
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
                  _screenTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _screenSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.how_to_reg_rounded,
              color: AppTheme.successColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTypeSelector() {
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
        children: _attendanceTypes.map((type) {
          final isSelected = _selectedAttendanceType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedAttendanceType = type;
                });
              },
              child: AnimatedContainer(
                duration: AppConstants.shortAnimation,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type == 'daily' ? 'Daily' : 'Subject',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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

  Widget _buildClassAndSubjectSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Class Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Select Class',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.class_rounded),
              ),
              items: _classes.map((className) {
                return DropdownMenuItem(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClass = value!;
                });
              },
            ),
          ),
          
          // Subject Selector (only for subject-based attendance)
          if (_selectedAttendanceType == 'subject') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              child: DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Select Subject',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.subject_rounded),
                ),
                items: _subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value!;
                  });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
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
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _selectDate,
              icon: const Icon(
                Icons.edit_calendar_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Present',
              _presentCount.toString(),
              Icons.check_circle_rounded,
              AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Absent',
              _absentCount.toString(),
              Icons.cancel_rounded,
              AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Late',
              _lateCount.toString(),
              Icons.access_time_rounded,
              AppTheme.warningColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Rate',
              '${_attendancePercentage.toStringAsFixed(1)}%',
              Icons.trending_up_rounded,
              AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _markAllPresent,
              icon: const Icon(Icons.done_all_rounded, size: 16),
              label: const Text('Mark All Present'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _saveAttendance,
              icon: const Icon(Icons.save_rounded, size: 16),
              label: const Text('Save Attendance'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsListHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            'Students',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          Text(
            '${_students.length} total',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, int index) {
    final status = student['status'] as String;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'present':
        statusColor = AppTheme.successColor;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'absent':
        statusColor = AppTheme.errorColor;
        statusIcon = Icons.cancel_rounded;
        break;
      case 'late':
        statusColor = AppTheme.warningColor;
        statusIcon = Icons.access_time_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_rounded;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: statusColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Student Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: student['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          student['image'],
                          fit: BoxFit.cover,
                        ),
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

              // Student Info
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
                      'Roll No: ${student['rollNumber']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Buttons
              if (_isMarkingMode) ...[
                _buildStatusButton('P', 'present', statusColor, student),
                const SizedBox(width: 8),
                _buildStatusButton('A', 'absent', statusColor, student),
                const SizedBox(width: 8),
                _buildStatusButton('L', 'late', statusColor, student),
              ] else ...[
                // Status Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showStudentOptions(student),
                  icon: const Icon(Icons.more_vert_rounded),
                  color: Colors.grey.shade600,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, String status, Color currentColor, Map<String, dynamic> student) {
    final isSelected = student['status'] == status;
    Color buttonColor;

    switch (status) {
      case 'present':
        buttonColor = AppTheme.successColor;
        break;
      case 'absent':
        buttonColor = AppTheme.errorColor;
        break;
      case 'late':
        buttonColor = AppTheme.warningColor;
        break;
      default:
        buttonColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () => _updateStudentStatus(student, status),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? buttonColor : buttonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: buttonColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : buttonColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      heroTag: "attendance_fab",
      onPressed: _sendNotifications,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.notifications_rounded, color: Colors.white),
      label: const Text(
        'Notify Parents',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Action Methods
  void _toggleMarkingMode() {
    setState(() {
      _isMarkingMode = !_isMarkingMode;
    });
    HapticFeedback.lightImpact();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateStudentStatus(Map<String, dynamic> student, String newStatus) {
    setState(() {
      student['status'] = newStatus;
    });
    HapticFeedback.lightImpact();
  }

  void _markAllPresent() {
    setState(() {
      for (var student in _students) {
        student['status'] = 'present';
      }
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All students marked as present'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _saveAttendance() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.save_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Save Attendance'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${_selectedAttendanceType.toUpperCase()}'),
            Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            Text('Class: $_selectedClass'),
            if (_selectedAttendanceType == 'subject') Text('Subject: $_selectedSubject'),
            const SizedBox(height: 8),
            Text('Present: $_presentCount'),
            Text('Absent: $_absentCount'),
            Text('Late: $_lateCount'),
            const SizedBox(height: 8),
            Text('Attendance Rate: ${_attendancePercentage.toStringAsFixed(1)}%'),
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
                  content: Text('Attendance saved successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _sendNotifications() {
    final absentStudents = _students.where((s) => s['status'] == 'absent').toList();
    
    if (absentStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No absent students to notify'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.notifications_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Send Notifications'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send absence notifications to ${absentStudents.length} parents?'),
            const SizedBox(height: 16),
            ...absentStudents.map((student) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(child: Text(student['name'])),
                ],
              ),
            )).toList(),
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
                SnackBar(
                  content: Text('Notifications sent to ${absentStudents.length} parents'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Send', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStudentOptions(Map<String, dynamic> student) {
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
              student['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionItem(Icons.phone_rounded, 'Call Parent', () {
              Navigator.pop(context);
              // Implement call functionality
            }),
            _buildOptionItem(Icons.message_rounded, 'Send Message', () {
              Navigator.pop(context);
              // Implement message functionality
            }),
            _buildOptionItem(Icons.history_rounded, 'View History', () {
              Navigator.pop(context);
              // Implement history functionality
            }),
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
      onTap: onTap,
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionItem(Icons.download_rounded, 'Export Attendance', () {}),
            _buildOptionItem(Icons.analytics_rounded, 'View Analytics', () {}),
            _buildOptionItem(Icons.settings_rounded, 'Attendance Settings', () {}),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}