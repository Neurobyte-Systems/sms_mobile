import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms/screens/teacher/class_details_screen.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _calendarController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _calendarAnimation;

  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'Week';
  final List<String> _viewOptions = ['Day', 'Week', 'Month'];

  final Map<DateTime, List<Map<String, dynamic>>> _schedule = {
    DateTime(2024, 1, 15): [
      {
        'time': '08:00',
        'duration': 90,
        'subject': 'Mathematics',
        'class': 'Class 10A',
        'room': 'Room 101',
        'type': 'lecture',
        'students': 28,
        'color': AppTheme.primaryColor,
      },
      {
        'time': '10:00',
        'duration': 90,
        'subject': 'Physics',
        'class': 'Class 10B',
        'room': 'Lab 201',
        'type': 'lab',
        'students': 25,
        'color': AppTheme.teacherColor,
      },
      {
        'time': '14:00',
        'duration': 120,
        'subject': 'Chemistry',
        'class': 'Class 11A',
        'room': 'Lab 301',
        'type': 'lab',
        'students': 30,
        'color': AppTheme.successColor,
      },
    ],
    DateTime(2024, 1, 16): [
      {
        'time': '09:00',
        'duration': 90,
        'subject': 'Advanced Mathematics',
        'class': 'Class 12A',
        'room': 'Room 205',
        'type': 'lecture',
        'students': 20,
        'color': AppTheme.warningColor,
      },
      {
        'time': '11:00',
        'duration': 60,
        'subject': 'Faculty Meeting',
        'class': 'All Staff',
        'room': 'Conference Room',
        'type': 'meeting',
        'students': 0,
        'color': AppTheme.adminColor,
      },
      {
        'time': '15:00',
        'duration': 90,
        'subject': 'Study Hall',
        'class': 'Mixed Groups',
        'room': 'Library',
        'type': 'supervision',
        'students': 15,
        'color': AppTheme.parentColor,
      },
    ],
    DateTime(2024, 1, 17): [
      {
        'time': '08:00',
        'duration': 90,
        'subject': 'Mathematics',
        'class': 'Class 10A',
        'room': 'Room 101',
        'type': 'lecture',
        'students': 28,
        'color': AppTheme.primaryColor,
      },
      {
        'time': '13:00',
        'duration': 120,
        'subject': 'Chemistry',
        'class': 'Class 11A',
        'room': 'Lab 301',
        'type': 'lab',
        'students': 30,
        'color': AppTheme.successColor,
      },
    ],
  };

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

    _calendarController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _calendarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _calendarController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _calendarController.forward();
  }

  List<Map<String, dynamic>> get _todaySchedule {
    final today = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    return _schedule[today] ?? [];
  }

  int get _totalClassesToday => _todaySchedule.length;
  int get _totalStudentsToday =>
      _todaySchedule.fold(0, (sum, item) => sum + (item['students'] as int));

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

                  // Banner Section with Day/Week/Month Tabs
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildViewSelector(),
                        const SizedBox(height: 16),
                        _buildDateSelector(),
                        const SizedBox(height: 16),
                        _buildTodayStats(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Calendar Section
                  SliverToBoxAdapter(child: _buildCalendarSection()),

                  const SliverToBoxAdapter(child: SizedBox(height: 22)),
                  // Schedule Content Section
                  SliverToBoxAdapter(child: _buildScheduleContent()),

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
      title: const Text(
        'My Schedule',
        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
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
          icon: const Icon(Icons.today_rounded, color: Color(0xFF2D3748)),
          onPressed: _goToToday,
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
          colors: [AppTheme.primaryColor.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Class Schedule',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your teaching timetable',
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
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSelector() {
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
            _viewOptions.map((option) {
              final isSelected = _selectedView == option;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedView = option;
                    });
                  },
                  child: AnimatedContainer(
                    duration: AppConstants.shortAnimation,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option,
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

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
          IconButton(
            onPressed: _previousDate,
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppTheme.primaryColor,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _formatDateHeader(_selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateSubheader(_selectedDate),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _nextDate,
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
          _buildStatItem(
            Icons.class_rounded,
            _totalClassesToday.toString(),
            'Classes',
            AppTheme.primaryColor,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            Icons.people_rounded,
            _totalStudentsToday.toString(),
            'Students',
            AppTheme.successColor,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            Icons.access_time_rounded,
            _calculateFreeTime(),
            'Free Time',
            AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
              const Text(
                'Calendar Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _selectDate,
                child: Text(
                  'Select Date',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildWeekView(),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final date = DateTime.now().subtract(
              Duration(days: DateTime.now().weekday - 1 - index),
            );
            final daySchedule =
                _schedule[DateTime(date.year, date.month, date.day)] ?? [];
            final isToday = _isSameDay(date, DateTime.now());
            final isSelected = _isSameDay(date, _selectedDate);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : isToday
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _getDayName(date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? Colors.white
                                : isToday
                                ? AppTheme.primaryColor
                                : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.white
                                : isToday
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border:
                            daySchedule.isNotEmpty
                                ? Border.all(
                                  color:
                                      isSelected
                                          ? AppTheme.primaryColor
                                          : AppTheme.successColor,
                                  width: 2,
                                )
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected
                                    ? AppTheme.primaryColor
                                    : isToday
                                    ? Colors.white
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (daySchedule.isNotEmpty)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.white : AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildScheduleContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today\'s Schedule',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              if (_todaySchedule.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_todaySchedule.length} classes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_todaySchedule.isEmpty)
            _buildEmptyState()
          else
            Column(
              children:
                  _todaySchedule.map((scheduleItem) {
                    final isNow = _isClassNow(scheduleItem);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            isNow
                                ? Border.all(color: Colors.green, width: 2)
                                : null,
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
                                  color: (scheduleItem['color'] as Color)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getTypeIcon(scheduleItem['type']),
                                  color: scheduleItem['color'] as Color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      scheduleItem['subject'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      scheduleItem['class'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isNow)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'NOW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildScheduleInfo(
                                Icons.access_time_rounded,
                                '${scheduleItem['time']} (${scheduleItem['duration']}m)',
                              ),
                              const SizedBox(width: 16),
                              _buildScheduleInfo(
                                Icons.room_rounded,
                                scheduleItem['room'],
                              ),
                              const SizedBox(width: 16),
                              _buildScheduleInfo(
                                Icons.people_rounded,
                                '${scheduleItem['students']} students',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed:
                                      () => _takeAttendance(scheduleItem),
                                  icon: const Icon(
                                    Icons.how_to_reg_rounded,
                                    size: 16,
                                  ),
                                  label: const Text('Take Attendance'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.primaryColor,
                                    side: BorderSide(
                                      color: AppTheme.primaryColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      () => _openClassDetails(scheduleItem),
                                  icon: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                  ),
                                  label: const Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleInfo(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No classes scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your free day!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addNewClass,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Class'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      heroTag: "schedule_fab",
      onPressed: _addNewClass,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Add Class',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper Methods
  String _formatDateHeader(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String _formatDateSubheader(DateTime date) {
    if (_isSameDay(date, DateTime.now())) {
      return 'Today';
    } else if (_isSameDay(date, DateTime.now().add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (_isSameDay(
      date,
      DateTime.now().subtract(const Duration(days: 1)),
    )) {
      return 'Yesterday';
    }
    return '${date.year}';
  }

  String _getDayName(DateTime date) {
    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return weekdays[date.weekday - 1];
  }

  String _calculateFreeTime() {
    final totalMinutes = _todaySchedule.fold(
      0,
      (sum, item) => sum + (item['duration'] as int),
    );
    final freeMinutes = (8 * 60) - totalMinutes; // Assuming 8-hour workday
    return freeMinutes > 0 ? '${(freeMinutes / 60).toStringAsFixed(1)}h' : '0h';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isClassNow(Map<String, dynamic> scheduleItem) {
    final now = DateTime.now();
    final timeStr = scheduleItem['time'] as String;
    final timeParts = timeStr.split(':');
    final classTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    final duration = scheduleItem['duration'] as int;
    final endTime = classTime.add(Duration(minutes: duration));

    return now.isAfter(classTime) &&
        now.isBefore(endTime) &&
        _isSameDay(now, _selectedDate);
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'lecture':
        return Icons.school_rounded;
      case 'lab':
        return Icons.science_rounded;
      case 'meeting':
        return Icons.meeting_room_rounded;
      case 'supervision':
        return Icons.supervisor_account_rounded;
      default:
        return Icons.class_rounded;
    }
  }

  // Action Methods
  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _selectedView = 'Day';
    });
    HapticFeedback.lightImpact();
  }

  void _previousDate() {
    setState(() {
      if (_selectedView == 'Day') {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      } else if (_selectedView == 'Week') {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      } else {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month - 1,
          _selectedDate.day,
        );
      }
    });
    HapticFeedback.lightImpact();
  }

  void _nextDate() {
    setState(() {
      if (_selectedView == 'Day') {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      } else if (_selectedView == 'Week') {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
      } else {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month + 1,
          _selectedDate.day,
        );
      }
    });
    HapticFeedback.lightImpact();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addNewClass() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Class'),
            content: const Text('This feature will be implemented soon.'),
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
                      content: const Text('Class added successfully!'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _takeAttendance(Map<String, dynamic> scheduleItem) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Taking attendance for ${scheduleItem['subject']}'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openClassDetails(Map<String, dynamic> scheduleItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassDetailsScreen(classData: scheduleItem),
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
                _buildOptionItem(Icons.sync_rounded, 'Sync Calendar', () {}),
                _buildOptionItem(
                  Icons.download_rounded,
                  'Export Schedule',
                  () {},
                ),
                _buildOptionItem(
                  Icons.settings_rounded,
                  'Schedule Settings',
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
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }
}
