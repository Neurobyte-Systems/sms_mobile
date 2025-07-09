import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({Key? key}) : super(key: key);

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'Today';
  PageController _pageController = PageController();

  final List<String> _viewOptions = ['Today', 'Week', 'Month'];
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Sample schedule data
  final Map<String, List<Map<String, dynamic>>> _scheduleData = {
    'Monday': [
      {
        'subject': 'Mathematics',
        'teacher': 'Dr. Smith',
        'time': '08:00 - 09:30',
        'room': 'Room 101',
        'type': 'Lecture',
        'color': AppTheme.primaryColor,
        'hasAssignment': true,
        'notes': 'Calculus chapter 8',
      },
      {
        'subject': 'Physics',
        'teacher': 'Prof. Johnson',
        'time': '10:00 - 11:30',
        'room': 'Lab 202',
        'type': 'Lab',
        'color': AppTheme.successColor,
        'hasAssignment': false,
        'notes': 'Pendulum experiment',
      },
      {
        'subject': 'English',
        'teacher': 'Ms. Davis',
        'time': '13:00 - 14:30',
        'room': 'Room 305',
        'type': 'Seminar',
        'color': AppTheme.teacherColor,
        'hasAssignment': true,
        'notes': 'Shakespeare discussion',
      },
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Wilson',
        'time': '15:00 - 16:30',
        'room': 'Lab 103',
        'type': 'Lab',
        'color': AppTheme.warningColor,
        'hasAssignment': false,
        'notes': 'Organic reactions',
      },
    ],
    'Tuesday': [
      {
        'subject': 'History',
        'teacher': 'Prof. Brown',
        'time': '09:00 - 10:30',
        'room': 'Room 201',
        'type': 'Lecture',
        'color': AppTheme.parentColor,
        'hasAssignment': true,
        'notes': 'World War II',
      },
      {
        'subject': 'Mathematics',
        'teacher': 'Dr. Smith',
        'time': '11:00 - 12:30',
        'room': 'Room 101',
        'type': 'Tutorial',
        'color': AppTheme.primaryColor,
        'hasAssignment': false,
        'notes': 'Problem solving',
      },
      {
        'subject': 'Physics',
        'teacher': 'Prof. Johnson',
        'time': '14:00 - 15:30',
        'room': 'Room 202',
        'type': 'Lecture',
        'color': AppTheme.successColor,
        'hasAssignment': true,
        'notes': 'Quantum mechanics',
      },
    ],
    'Wednesday': [
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Wilson',
        'time': '08:30 - 10:00',
        'room': 'Room 103',
        'type': 'Lecture',
        'color': AppTheme.warningColor,
        'hasAssignment': false,
        'notes': 'Molecular structures',
      },
      {
        'subject': 'English',
        'teacher': 'Ms. Davis',
        'time': '10:30 - 12:00',
        'room': 'Room 305',
        'type': 'Workshop',
        'color': AppTheme.teacherColor,
        'hasAssignment': true,
        'notes': 'Essay writing',
      },
      {
        'subject': 'Mathematics',
        'teacher': 'Dr. Smith',
        'time': '13:30 - 15:00',
        'room': 'Room 101',
        'type': 'Lecture',
        'color': AppTheme.primaryColor,
        'hasAssignment': true,
        'notes': 'Integration techniques',
      },
    ],
    'Thursday': [
      {
        'subject': 'Physics',
        'teacher': 'Prof. Johnson',
        'time': '09:00 - 10:30',
        'room': 'Lab 202',
        'type': 'Lab',
        'color': AppTheme.successColor,
        'hasAssignment': false,
        'notes': 'Optics experiment',
      },
      {
        'subject': 'History',
        'teacher': 'Prof. Brown',
        'time': '11:00 - 12:30',
        'room': 'Room 201',
        'type': 'Seminar',
        'color': AppTheme.parentColor,
        'hasAssignment': true,
        'notes': 'Research presentation',
      },
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Wilson',
        'time': '14:00 - 15:30',
        'room': 'Lab 103',
        'type': 'Lab',
        'color': AppTheme.warningColor,
        'hasAssignment': false,
        'notes': 'Titration lab',
      },
    ],
    'Friday': [
      {
        'subject': 'English',
        'teacher': 'Ms. Davis',
        'time': '08:00 - 09:30',
        'room': 'Room 305',
        'type': 'Lecture',
        'color': AppTheme.teacherColor,
        'hasAssignment': true,
        'notes': 'Poetry analysis',
      },
      {
        'subject': 'Mathematics',
        'teacher': 'Dr. Smith',
        'time': '10:00 - 11:30',
        'room': 'Room 101',
        'type': 'Quiz',
        'color': AppTheme.primaryColor,
        'hasAssignment': false,
        'notes': 'Weekly assessment',
      },
      {
        'subject': 'Study Hall',
        'teacher': 'Self-directed',
        'time': '13:00 - 14:30',
        'room': 'Library',
        'type': 'Study',
        'color': Colors.grey,
        'hasAssignment': false,
        'notes': 'Independent study',
      },
    ],
  };

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Math Quiz',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '10:00 AM',
      'type': 'Assessment',
      'color': AppTheme.primaryColor,
      'reminder': true,
    },
    {
      'title': 'Physics Lab Report Due',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '11:59 PM',
      'type': 'Assignment',
      'color': AppTheme.successColor,
      'reminder': true,
    },
    {
      'title': 'History Presentation',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '2:00 PM',
      'type': 'Presentation',
      'color': AppTheme.parentColor,
      'reminder': false,
    },
    {
      'title': 'Chemistry Midterm',
      'date': DateTime.now().add(const Duration(days: 7)),
      'time': '9:00 AM',
      'type': 'Exam',
      'color': AppTheme.warningColor,
      'reminder': true,
    },
  ];

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
                  _buildViewToggle(),
                  _buildDateSelector(),
                  Expanded(
                    child: _selectedView == 'Today' 
                        ? _buildTodayView()
                        : _selectedView == 'Week' 
                            ? _buildWeekView()
                            : _buildMonthView(),
                  ),
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
      backgroundColor: Colors.white,
      foregroundColor: AppTheme.studentColor,
      title: const Text(
        'My Schedule',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: _showReminders,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
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
        children: _viewOptions.map((view) {
          final isSelected = _selectedView == view;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedView = view);
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.studentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  view,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: _previousDate,
          ),
          Expanded(
            child: Text(
              _formatSelectedDate(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: _nextDate,
          ),
        ],
      ),
    );
  }

  Widget _buildTodayView() {
    final today = _getDayName(_selectedDate);
    final todaySchedule = _scheduleData[today] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUpcomingEventsCard(),
          const SizedBox(height: 16),
          _buildTodayScheduleCard(todaySchedule),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsCard() {
    final upcomingEvents = _upcomingEvents.where((event) {
      final daysDiff = event['date'].difference(DateTime.now()).inDays;
      return daysDiff >= 0 && daysDiff <= 7;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.event_rounded,
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _showAllEvents,
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
          ...upcomingEvents.take(3).map((event) => _buildEventItem(event)),
        ],
      ),
    );
  }

  Widget _buildEventItem(Map<String, dynamic> event) {
    final daysDiff = event['date'].difference(DateTime.now()).inDays;
    String timeText = '';
    if (daysDiff == 0) timeText = 'Today';
    else if (daysDiff == 1) timeText = 'Tomorrow';
    else timeText = '$daysDiff days';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: event['color'],
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: event['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getEventIcon(event['type']),
              color: event['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$timeText at ${event['time']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (event['reminder'])
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: AppTheme.warningColor,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTodayScheduleCard(List<Map<String, dynamic>> schedule) {
    if (schedule.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
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
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.free_breakfast_rounded,
                size: 60,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No classes today!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enjoy your free time',
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
                color: AppTheme.studentColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Today\'s Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...schedule.map((classItem) => _buildClassItem(classItem)),
        ],
      ),
    );
  }

  Widget _buildClassItem(Map<String, dynamic> classItem) {
    final now = DateTime.now();
    final classTime = _parseTime(classItem['time']);
    final isCurrentClass = _isCurrentTime(classTime);
    final isUpcoming = _isUpcomingClass(classTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentClass 
            ? classItem['color'].withOpacity(0.1) 
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentClass 
            ? Border.all(color: classItem['color'], width: 2) 
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: classItem['color'],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        classItem['subject'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (isCurrentClass)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isUpcoming && !isCurrentClass)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  classItem['teacher'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      classItem['time'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      classItem['room'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (classItem['hasAssignment'])
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.assignment_rounded,
                          color: AppTheme.errorColor,
                          size: 16,
                        ),
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

  Widget _buildWeekView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWeekHeader(),
          const SizedBox(height: 16),
          _buildWeekSchedule(),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    final startOfWeek = _getStartOfWeek(_selectedDate);
    
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
      child: Row(
        children: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final isToday = _isSameDay(date, DateTime.now());
          final isSelected = _isSameDay(date, _selectedDate);
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedDate = date);
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.studentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _weekDays[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : (isToday ? AppTheme.studentColor : Colors.black),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeekSchedule() {
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
        children: _scheduleData.entries.map((entry) {
          final day = entry.key;
          final classes = entry.value;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ...classes.map((classItem) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: classItem['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: classItem['color'],
                      width: 3,
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
                            classItem['subject'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${classItem['time']} • ${classItem['room']}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (classItem['hasAssignment'])
                      Icon(
                        Icons.assignment_rounded,
                        color: AppTheme.errorColor,
                        size: 16,
                      ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthView() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: const Center(
        child: Text(
          'Monthly calendar view coming soon!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: 'schedule_fab',
      onPressed: _addEvent,
      backgroundColor: AppTheme.studentColor,
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }

  // Helper methods
  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  String _formatSelectedDate() {
    final now = DateTime.now();
    if (_isSameDay(_selectedDate, now)) {
      return 'Today, ${_formatDate(_selectedDate)}';
    } else if (_isSameDay(_selectedDate, now.add(const Duration(days: 1)))) {
      return 'Tomorrow, ${_formatDate(_selectedDate)}';
    } else if (_isSameDay(_selectedDate, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday, ${_formatDate(_selectedDate)}';
    } else {
      return _formatDate(_selectedDate);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysFromMonday));
  }

  Map<String, String> _parseTime(String timeRange) {
    final parts = timeRange.split(' - ');
    return {
      'start': parts[0],
      'end': parts[1],
    };
  }

  bool _isCurrentTime(Map<String, String> classTime) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    return currentTime.compareTo(classTime['start']!) >= 0 && 
           currentTime.compareTo(classTime['end']!) <= 0;
  }

  bool _isUpcomingClass(Map<String, String> classTime) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final timeDiff = _getTimeDifference(currentTime, classTime['start']!);
    
    return timeDiff > 0 && timeDiff <= 60; // Next class within 60 minutes
  }

  int _getTimeDifference(String time1, String time2) {
    final parts1 = time1.split(':');
    final parts2 = time2.split(':');
    
    final minutes1 = int.parse(parts1[0]) * 60 + int.parse(parts1[1]);
    final minutes2 = int.parse(parts2[0]) * 60 + int.parse(parts2[1]);
    
    return minutes2 - minutes1;
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Assessment':
        return Icons.quiz_rounded;
      case 'Assignment':
        return Icons.assignment_rounded;
      case 'Presentation':
        return Icons.present_to_all_rounded;
      case 'Exam':
        return Icons.school_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  void _previousDate() {
    setState(() {
      if (_selectedView == 'Today') {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      } else if (_selectedView == 'Week') {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
      }
    });
  }

  void _nextDate() {
    setState(() {
      if (_selectedView == 'Today') {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      } else if (_selectedView == 'Week') {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
      }
    });
  }

  void _showReminders() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _upcomingEvents.where((event) => event['reminder']).map((event) {
            return ListTile(
              leading: Icon(
                _getEventIcon(event['type']),
                color: event['color'],
              ),
              title: Text(event['title']),
              subtitle: Text(_formatDate(event['date'])),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
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
              leading: const Icon(Icons.sync_rounded),
              title: const Text('Sync Calendar'),
              onTap: () {
                Navigator.pop(context);
                _syncCalendar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: const Text('Export Schedule'),
              onTap: () {
                Navigator.pop(context);
                _exportSchedule();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Schedule Settings'),
              onTap: () {
                Navigator.pop(context);
                _showScheduleSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAllEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllEventsScreen(events: _upcomingEvents),
      ),
    );
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: const Text('Event creation coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _syncCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calendar sync coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _exportSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _showScheduleSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule settings coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

// All Events Screen
class AllEventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  const AllEventsScreen({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events'),
        backgroundColor: AppTheme.studentColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: event['color'],
                child: Icon(
                  _getEventIcon(event['type']),
                  color: Colors.white,
                ),
              ),
              title: Text(event['title']),
              subtitle: Text('${_formatDate(event['date'])} at ${event['time']}'),
              trailing: event['reminder'] 
                  ? const Icon(Icons.notifications_active_rounded)
                  : null,
            ),
          );
        },
      ),
    );
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Assessment':
        return Icons.quiz_rounded;
      case 'Assignment':
        return Icons.assignment_rounded;
      case 'Presentation':
        return Icons.present_to_all_rounded;
      case 'Exam':
        return Icons.school_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
} 