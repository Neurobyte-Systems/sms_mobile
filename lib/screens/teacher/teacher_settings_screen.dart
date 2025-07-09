import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class TeacherSettingsScreen extends StatefulWidget {
  const TeacherSettingsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends State<TeacherSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // General Settings
  bool _darkMode = false;
  String _language = 'English';
  String _dateFormat = 'DD/MM/YYYY';
  String _timeFormat = '12 Hour';
  bool _autoSave = true;
  
  // Notification Settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _assignmentReminders = true;
  bool _gradeNotifications = true;
  bool _attendanceAlerts = true;
  bool _parentMessages = true;
  
  // Privacy Settings
  bool _shareProfile = false;
  bool _showOnlineStatus = true;
  bool _allowParentContact = true;
  bool _dataAnalytics = true;
  
  // Teaching Settings
  String _defaultGradingScale = 'Percentage';
  bool _autoBackup = true;
  String _backupFrequency = 'Daily';
  bool _offlineMode = false;
  String _defaultClassView = 'Grid';
  
  // App Settings
  bool _hapticFeedback = true;
  bool _soundEffects = false;
  String _appTheme = 'System';
  bool _betaFeatures = false;

  final List<String> _languages = ['English', 'French', 'Spanish', 'Twi', 'Ga'];
  final List<String> _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
  final List<String> _timeFormats = ['12 Hour', '24 Hour'];
  final List<String> _gradingScales = ['Percentage', 'Letter Grade', 'Points', 'GPA'];
  final List<String> _backupFrequencies = ['Daily', 'Weekly', 'Monthly'];
  final List<String> _classViews = ['Grid', 'List', 'Card'];
  final List<String> _appThemes = ['Light', 'Dark', 'System'];

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
                        _buildGeneralSettings(),
                        const SizedBox(height: 16),
                        _buildNotificationSettings(),
                        const SizedBox(height: 16),
                        _buildPrivacySettings(),
                        const SizedBox(height: 16),
                        _buildTeachingSettings(),
                        const SizedBox(height: 16),
                        _buildAppSettings(),
                        const SizedBox(height: 16),
                        _buildAccountSettings(),
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
        'Settings',
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
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2D3748)),
          onPressed: _resetToDefaults,
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
          colors: [AppTheme.teacherColor, AppTheme.teacherColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.teacherColor.withOpacity(0.3),
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
              Icons.settings_rounded,
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
                  'Teacher Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Customize your teaching experience',
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

  Widget _buildGeneralSettings() {
    return _buildSettingsSection(
      'General Settings',
      Icons.tune_rounded,
      [
        _buildSwitchSetting(
          'Dark Mode',
          'Use dark theme for the app',
          Icons.dark_mode_rounded,
          _darkMode,
          (value) => setState(() => _darkMode = value),
        ),
        _buildDropdownSetting(
          'Language',
          'App display language',
          Icons.language_rounded,
          _language,
          _languages,
          (value) => setState(() => _language = value!),
        ),
        _buildDropdownSetting(
          'Date Format',
          'How dates are displayed',
          Icons.date_range_rounded,
          _dateFormat,
          _dateFormats,
          (value) => setState(() => _dateFormat = value!),
        ),
        _buildDropdownSetting(
          'Time Format',
          'How time is displayed',
          Icons.access_time_rounded,
          _timeFormat,
          _timeFormats,
          (value) => setState(() => _timeFormat = value!),
        ),
        _buildSwitchSetting(
          'Auto Save',
          'Automatically save your work',
          Icons.save_rounded,
          _autoSave,
          (value) => setState(() => _autoSave = value),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      'Notification Settings',
      Icons.notifications_rounded,
      [
        _buildSwitchSetting(
          'Push Notifications',
          'Receive push notifications',
          Icons.mobile_friendly_rounded,
          _pushNotifications,
          (value) => setState(() => _pushNotifications = value),
        ),
        _buildSwitchSetting(
          'Email Notifications',
          'Receive email notifications',
          Icons.email_rounded,
          _emailNotifications,
          (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchSetting(
          'SMS Notifications',
          'Receive SMS notifications',
          Icons.sms_rounded,
          _smsNotifications,
          (value) => setState(() => _smsNotifications = value),
        ),
        _buildSwitchSetting(
          'Assignment Reminders',
          'Reminders for assignment due dates',
          Icons.assignment_rounded,
          _assignmentReminders,
          (value) => setState(() => _assignmentReminders = value),
        ),
        _buildSwitchSetting(
          'Grade Notifications',
          'Notifications when grades are posted',
          Icons.grade_rounded,
          _gradeNotifications,
          (value) => setState(() => _gradeNotifications = value),
        ),
        _buildSwitchSetting(
          'Attendance Alerts',
          'Alerts for attendance issues',
          Icons.how_to_reg_rounded,
          _attendanceAlerts,
          (value) => setState(() => _attendanceAlerts = value),
        ),
        _buildSwitchSetting(
          'Parent Messages',
          'Notifications for parent messages',
          Icons.message_rounded,
          _parentMessages,
          (value) => setState(() => _parentMessages = value),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingsSection(
      'Privacy & Security',
      Icons.privacy_tip_rounded,
      [
        _buildSwitchSetting(
          'Share Profile',
          'Allow other teachers to see your profile',
          Icons.person_rounded,
          _shareProfile,
          (value) => setState(() => _shareProfile = value),
        ),
        _buildSwitchSetting(
          'Show Online Status',
          'Show when you are online',
          Icons.circle_rounded,
          _showOnlineStatus,
          (value) => setState(() => _showOnlineStatus = value),
        ),
        _buildSwitchSetting(
          'Allow Parent Contact',
          'Parents can contact you directly',
          Icons.contact_phone_rounded,
          _allowParentContact,
          (value) => setState(() => _allowParentContact = value),
        ),
        _buildSwitchSetting(
          'Data Analytics',
          'Help improve the app with usage data',
          Icons.analytics_rounded,
          _dataAnalytics,
          (value) => setState(() => _dataAnalytics = value),
        ),
        _buildActionSetting(
          'Change Password',
          'Update your account password',
          Icons.lock_rounded,
          _showChangePasswordDialog,
        ),
        _buildActionSetting(
          'Two-Factor Authentication',
          'Add extra security to your account',
          Icons.security_rounded,
          _show2FADialog,
        ),
      ],
    );
  }

  Widget _buildTeachingSettings() {
    return _buildSettingsSection(
      'Teaching Settings',
      Icons.school_rounded,
      [
        _buildDropdownSetting(
          'Default Grading Scale',
          'Default scale for new assignments',
          Icons.grade_rounded,
          _defaultGradingScale,
          _gradingScales,
          (value) => setState(() => _defaultGradingScale = value!),
        ),
        _buildSwitchSetting(
          'Auto Backup',
          'Automatically backup your data',
          Icons.backup_rounded,
          _autoBackup,
          (value) => setState(() => _autoBackup = value),
        ),
        if (_autoBackup)
          _buildDropdownSetting(
            'Backup Frequency',
            'How often to backup data',
            Icons.schedule_rounded,
            _backupFrequency,
            _backupFrequencies,
            (value) => setState(() => _backupFrequency = value!),
          ),
        _buildSwitchSetting(
          'Offline Mode',
          'Work without internet connection',
          Icons.offline_bolt_rounded,
          _offlineMode,
          (value) => setState(() => _offlineMode = value),
        ),
        _buildDropdownSetting(
          'Default Class View',
          'How to display class lists',
          Icons.view_module_rounded,
          _defaultClassView,
          _classViews,
          (value) => setState(() => _defaultClassView = value!),
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return _buildSettingsSection(
      'App Settings',
      Icons.phone_android_rounded,
      [
        _buildSwitchSetting(
          'Haptic Feedback',
          'Vibration feedback for interactions',
          Icons.vibration_rounded,
          _hapticFeedback,
          (value) => setState(() => _hapticFeedback = value),
        ),
        _buildSwitchSetting(
          'Sound Effects',
          'Audio feedback for actions',
          Icons.volume_up_rounded,
          _soundEffects,
          (value) => setState(() => _soundEffects = value),
        ),
        _buildDropdownSetting(
          'App Theme',
          'Choose app appearance',
          Icons.palette_rounded,
          _appTheme,
          _appThemes,
          (value) => setState(() => _appTheme = value!),
        ),
        _buildSwitchSetting(
          'Beta Features',
          'Enable experimental features',
          Icons.science_rounded,
          _betaFeatures,
          (value) => setState(() => _betaFeatures = value),
        ),
        _buildActionSetting(
          'Clear Cache',
          'Free up storage space',
          Icons.clear_rounded,
          _clearCache,
        ),
        _buildActionSetting(
          'App Info',
          'Version and build information',
          Icons.info_rounded,
          _showAppInfo,
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return _buildSettingsSection(
      'Account',
      Icons.account_circle_rounded,
      [
        _buildActionSetting(
          'Export Data',
          'Download your teaching data',
          Icons.download_rounded,
          _exportData,
        ),
        _buildActionSetting(
          'Import Data',
          'Import data from another account',
          Icons.upload_rounded,
          _importData,
        ),
        _buildActionSetting(
          'Delete Account',
          'Permanently delete your account',
          Icons.delete_forever_rounded,
          _showDeleteAccountDialog,
        ),
        _buildActionSetting(
          'Contact Support',
          'Get help with your account',
          Icons.support_agent_rounded,
          _contactSupport,
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
              color: AppTheme.teacherColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.teacherColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.teacherColor,
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
            activeColor: AppTheme.teacherColor,
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

  // Action Methods
  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _darkMode = false;
                _language = 'English';
                _dateFormat = 'DD/MM/YYYY';
                _timeFormat = '12 Hour';
                _autoSave = true;
                _pushNotifications = true;
                _emailNotifications = true;
                _smsNotifications = false;
                _assignmentReminders = true;
                _gradeNotifications = true;
                _attendanceAlerts = true;
                _parentMessages = true;
                _shareProfile = false;
                _showOnlineStatus = true;
                _allowParentContact = true;
                _dataAnalytics = true;
                _defaultGradingScale = 'Percentage';
                _autoBackup = true;
                _backupFrequency = 'Daily';
                _offlineMode = false;
                _defaultClassView = 'Grid';
                _hapticFeedback = true;
                _soundEffects = false;
                _appTheme = 'System';
                _betaFeatures = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to defaults'),
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

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
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
                  content: const Text('Password changed successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Change', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _show2FADialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Two-Factor Authentication setup coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cache cleared successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('App Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MySchoolGH Teacher', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            Text('Build: 100'),
            Text('Release Date: January 2024'),
            SizedBox(height: 16),
            Text('Developed by MySchoolGH Team'),
            Text('© 2024 MySchoolGH. All rights reserved.'),
          ],
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

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting your data...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _importData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Import data functionality coming soon!'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorColor),
            const SizedBox(width: 8),
            const Text('Delete Account'),
          ],
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
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
                  content: const Text('Account deletion request submitted'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening support chat...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 