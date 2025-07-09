import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Push Notification Settings
  bool _pushNotifications = true;
  bool _assignmentNotifications = true;
  bool _gradeNotifications = true;
  bool _attendanceNotifications = true;
  bool _messageNotifications = true;
  bool _reminderNotifications = true;
  bool _systemNotifications = false;
  
  // Email Notification Settings
  bool _emailNotifications = true;
  bool _dailyDigest = true;
  bool _weeklyReport = false;
  bool _monthlyReport = true;
  bool _parentMessageEmails = true;
  bool _assignmentDeadlineEmails = true;
  bool _gradeSubmissionEmails = false;
  
  // SMS Notification Settings
  bool _smsNotifications = false;
  bool _urgentSMS = true;
  bool _attendanceAlertSMS = false;
  bool _emergencySMS = true;
  
  // Timing Settings
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '07:00';
  bool _weekendNotifications = false;
  String _reminderTiming = '24 hours';
  
  // Sound & Vibration Settings
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationSound = 'Default';
  String _messageSound = 'Chime';
  
  final List<String> _reminderTimings = ['1 hour', '6 hours', '12 hours', '24 hours', '48 hours'];
  final List<String> _notificationSounds = ['Default', 'Chime', 'Bell', 'Ping', 'None'];

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildPushNotificationSettings(),
                        const SizedBox(height: 16),
                        _buildEmailNotificationSettings(),
                        const SizedBox(height: 16),
                        _buildSMSNotificationSettings(),
                        const SizedBox(height: 16),
                        _buildTimingSettings(),
                        const SizedBox(height: 16),
                        _buildSoundVibrationSettings(),
                        const SizedBox(height: 16),
                        _buildAdvancedSettings(),
                        const SizedBox(height: 100),
                      ],
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Notification Settings',
        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFF2D3748),
        ),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.check_rounded, color: Color(0xFF2D3748)),
          onPressed: _saveSettings,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage how you receive notifications',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPushNotificationSettings() {
    return _buildSettingsSection(
      'Push Notifications',
      Icons.mobile_friendly_rounded,
      [
        _buildMasterSwitch(
          'Push Notifications',
          'Receive notifications on your device',
          _pushNotifications,
          (value) => setState(() => _pushNotifications = value),
        ),
        if (_pushNotifications) ...[
          _buildSwitchSetting(
            'Assignment Notifications',
            'New assignments and due dates',
            Icons.assignment_rounded,
            _assignmentNotifications,
            (value) => setState(() => _assignmentNotifications = value),
          ),
          _buildSwitchSetting(
            'Grade Notifications',
            'When grades are posted or updated',
            Icons.grade_rounded,
            _gradeNotifications,
            (value) => setState(() => _gradeNotifications = value),
          ),
          _buildSwitchSetting(
            'Attendance Notifications',
            'Attendance alerts and reminders',
            Icons.how_to_reg_rounded,
            _attendanceNotifications,
            (value) => setState(() => _attendanceNotifications = value),
          ),
          _buildSwitchSetting(
            'Message Notifications',
            'New messages from parents and students',
            Icons.message_rounded,
            _messageNotifications,
            (value) => setState(() => _messageNotifications = value),
          ),
          _buildSwitchSetting(
            'Reminder Notifications',
            'Reminders for upcoming events',
            Icons.alarm_rounded,
            _reminderNotifications,
            (value) => setState(() => _reminderNotifications = value),
          ),
          _buildSwitchSetting(
            'System Notifications',
            'App updates and system messages',
            Icons.system_update_rounded,
            _systemNotifications,
            (value) => setState(() => _systemNotifications = value),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailNotificationSettings() {
    return _buildSettingsSection(
      'Email Notifications',
      Icons.email_rounded,
      [
        _buildMasterSwitch(
          'Email Notifications',
          'Receive notifications via email',
          _emailNotifications,
          (value) => setState(() => _emailNotifications = value),
        ),
        if (_emailNotifications) ...[
          _buildSwitchSetting(
            'Daily Digest',
            'Daily summary of activities',
            Icons.today_rounded,
            _dailyDigest,
            (value) => setState(() => _dailyDigest = value),
          ),
          _buildSwitchSetting(
            'Weekly Report',
            'Weekly performance reports',
            Icons.date_range_rounded,
            _weeklyReport,
            (value) => setState(() => _weeklyReport = value),
          ),
          _buildSwitchSetting(
            'Monthly Report',
            'Monthly summary reports',
            Icons.calendar_month_rounded,
            _monthlyReport,
            (value) => setState(() => _monthlyReport = value),
          ),
          _buildSwitchSetting(
            'Parent Messages',
            'Email notifications for parent messages',
            Icons.family_restroom_rounded,
            _parentMessageEmails,
            (value) => setState(() => _parentMessageEmails = value),
          ),
          _buildSwitchSetting(
            'Assignment Deadlines',
            'Reminders for assignment due dates',
            Icons.schedule_rounded,
            _assignmentDeadlineEmails,
            (value) => setState(() => _assignmentDeadlineEmails = value),
          ),
          _buildSwitchSetting(
            'Grade Submissions',
            'When students submit grades',
            Icons.send_rounded,
            _gradeSubmissionEmails,
            (value) => setState(() => _gradeSubmissionEmails = value),
          ),
        ],
      ],
    );
  }

  Widget _buildSMSNotificationSettings() {
    return _buildSettingsSection(
      'SMS Notifications',
      Icons.sms_rounded,
      [
        _buildMasterSwitch(
          'SMS Notifications',
          'Receive notifications via SMS',
          _smsNotifications,
          (value) => setState(() => _smsNotifications = value),
        ),
        if (_smsNotifications) ...[
          _buildSwitchSetting(
            'Urgent Messages',
            'Important and urgent notifications',
            Icons.priority_high_rounded,
            _urgentSMS,
            (value) => setState(() => _urgentSMS = value),
          ),
          _buildSwitchSetting(
            'Attendance Alerts',
            'Critical attendance issues',
            Icons.warning_rounded,
            _attendanceAlertSMS,
            (value) => setState(() => _attendanceAlertSMS = value),
          ),
          _buildSwitchSetting(
            'Emergency Notifications',
            'School emergency alerts',
            Icons.emergency_rounded,
            _emergencySMS,
            (value) => setState(() => _emergencySMS = value),
          ),
        ],
      ],
    );
  }

  Widget _buildTimingSettings() {
    return _buildSettingsSection(
      'Timing Settings',
      Icons.access_time_rounded,
      [
        _buildTimeSetting(
          'Quiet Hours Start',
          'No notifications after this time',
          Icons.bedtime_rounded,
          _quietHoursStart,
          (value) => setState(() => _quietHoursStart = value),
        ),
        _buildTimeSetting(
          'Quiet Hours End',
          'Resume notifications after this time',
          Icons.wb_sunny_rounded,
          _quietHoursEnd,
          (value) => setState(() => _quietHoursEnd = value),
        ),
        _buildSwitchSetting(
          'Weekend Notifications',
          'Receive notifications on weekends',
          Icons.weekend_rounded,
          _weekendNotifications,
          (value) => setState(() => _weekendNotifications = value),
        ),
        _buildDropdownSetting(
          'Reminder Timing',
          'How early to send reminders',
          Icons.schedule_rounded,
          _reminderTiming,
          _reminderTimings,
          (value) => setState(() => _reminderTiming = value!),
        ),
      ],
    );
  }

  Widget _buildSoundVibrationSettings() {
    return _buildSettingsSection(
      'Sound & Vibration',
      Icons.volume_up_rounded,
      [
        _buildSwitchSetting(
          'Sound Enabled',
          'Play sounds for notifications',
          Icons.volume_up_rounded,
          _soundEnabled,
          (value) => setState(() => _soundEnabled = value),
        ),
        if (_soundEnabled) ...[
          _buildDropdownSetting(
            'Notification Sound',
            'Sound for general notifications',
            Icons.music_note_rounded,
            _notificationSound,
            _notificationSounds,
            (value) => setState(() => _notificationSound = value!),
          ),
          _buildDropdownSetting(
            'Message Sound',
            'Sound for message notifications',
            Icons.message_rounded,
            _messageSound,
            _notificationSounds,
            (value) => setState(() => _messageSound = value!),
          ),
        ],
        _buildSwitchSetting(
          'Vibration Enabled',
          'Vibrate for notifications',
          Icons.vibration_rounded,
          _vibrationEnabled,
          (value) => setState(() => _vibrationEnabled = value),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return _buildSettingsSection(
      'Advanced Settings',
      Icons.settings_rounded,
      [
        _buildActionSetting(
          'Test Notifications',
          'Send a test notification',
          Icons.notifications_active_rounded,
          _testNotifications,
        ),
        _buildActionSetting(
          'Notification History',
          'View past notifications',
          Icons.history_rounded,
          _viewNotificationHistory,
        ),
        _buildActionSetting(
          'Reset to Defaults',
          'Reset all notification settings',
          Icons.refresh_rounded,
          _resetToDefaults,
        ),
        _buildActionSetting(
          'Notification Permissions',
          'Manage system permissions',
          Icons.admin_panel_settings_rounded,
          _managePermissions,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMasterSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: value ? AppTheme.primaryColor.withOpacity(0.05) : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: value ? AppTheme.primaryColor : const Color(0xFF2D3748),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSetting(
    String title,
    String subtitle,
    IconData icon,
    String value,
    Function(String) onChanged,
  ) {
    return InkWell(
      onTap: () => _selectTime(context, value, onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, String currentTime, Function(String) onChanged) async {
    final time = TimeOfDay(
      hour: int.parse(currentTime.split(':')[0]),
      minute: int.parse(currentTime.split(':')[1]),
    );
    
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    
    if (pickedTime != null) {
      final formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      onChanged(formattedTime);
    }
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification settings saved!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _testNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Test notification sent!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _viewNotificationHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification history coming soon!'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all notification settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pushNotifications = true;
                _assignmentNotifications = true;
                _gradeNotifications = true;
                _attendanceNotifications = true;
                _messageNotifications = true;
                _reminderNotifications = true;
                _systemNotifications = false;
                _emailNotifications = true;
                _dailyDigest = true;
                _weeklyReport = false;
                _monthlyReport = true;
                _parentMessageEmails = true;
                _assignmentDeadlineEmails = true;
                _gradeSubmissionEmails = false;
                _smsNotifications = false;
                _urgentSMS = true;
                _attendanceAlertSMS = false;
                _emergencySMS = true;
                _quietHoursStart = '22:00';
                _quietHoursEnd = '07:00';
                _weekendNotifications = false;
                _reminderTiming = '24 hours';
                _soundEnabled = true;
                _vibrationEnabled = true;
                _notificationSound = 'Default';
                _messageSound = 'Chime';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to defaults!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _managePermissions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Notification Permissions'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To receive notifications, please ensure the following permissions are enabled:'),
            SizedBox(height: 16),
            Text('• Push Notifications'),
            Text('• Background App Refresh'),
            Text('• Sound & Vibration'),
            SizedBox(height: 16),
            Text('You can manage these in your device settings.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Opening device settings...'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 