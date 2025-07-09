import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class AssignmentSettingsScreen extends StatefulWidget {
  const AssignmentSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentSettingsScreen> createState() => _AssignmentSettingsScreenState();
}

class _AssignmentSettingsScreenState extends State<AssignmentSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Default Settings
  bool _allowLateSubmissions = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _showGradesToStudents = true;
  bool _autoGradeQuizzes = false;
  bool _requireConfirmation = true;
  
  // Grading Settings
  String _defaultGradingScale = 'Percentage';
  String _passingGrade = '60';
  bool _allowPartialCredit = true;
  bool _showFeedbackImmediately = false;
  
  // Submission Settings
  String _defaultSubmissionFormat = 'Text & Files';
  bool _allowMultipleAttempts = false;
  String _maxAttempts = '3';
  bool _showSubmissionHistory = true;
  
  // Notification Settings
  bool _reminderEmails = true;
  String _reminderTiming = '24 hours';
  bool _overdueNotifications = true;
  bool _gradeNotifications = true;

  final List<String> _gradingScales = ['Percentage', 'Letter Grade', 'Points', 'Pass/Fail'];
  final List<String> _submissionFormats = ['Text Only', 'Files Only', 'Text & Files'];
  final List<String> _reminderTimings = ['1 hour', '6 hours', '12 hours', '24 hours', '48 hours'];

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
                  // Header Section
                  SliverToBoxAdapter(child: _buildHeader()),

                  // Settings Sections
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildGeneralSettings(),
                        const SizedBox(height: 16),
                        _buildGradingSettings(),
                        const SizedBox(height: 16),
                        _buildSubmissionSettings(),
                        const SizedBox(height: 16),
                        _buildNotificationSettings(),
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
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Assignment Settings',
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
        TextButton(
          onPressed: _resetToDefaults,
          child: Text(
            'Reset',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
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
                  'Assignment Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure default assignment preferences',
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
              Icons.settings_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return _buildSettingsSection(
      'General Settings',
      Icons.settings_rounded,
      [
        _buildSwitchSetting(
          'Allow Late Submissions',
          'Students can submit assignments after due date',
          Icons.schedule_rounded,
          _allowLateSubmissions,
          (value) => setState(() => _allowLateSubmissions = value),
        ),
        _buildSwitchSetting(
          'Show Grades to Students',
          'Students can view their grades immediately',
          Icons.grade_rounded,
          _showGradesToStudents,
          (value) => setState(() => _showGradesToStudents = value),
        ),
        _buildSwitchSetting(
          'Require Confirmation',
          'Students must confirm before submitting',
          Icons.check_circle_rounded,
          _requireConfirmation,
          (value) => setState(() => _requireConfirmation = value),
        ),
      ],
    );
  }

  Widget _buildGradingSettings() {
    return _buildSettingsSection(
      'Grading Settings',
      Icons.grade_rounded,
      [
        _buildDropdownSetting(
          'Default Grading Scale',
          'How grades are displayed',
          Icons.scale_rounded,
          _defaultGradingScale,
          _gradingScales,
          (value) => setState(() => _defaultGradingScale = value!),
        ),
        _buildTextFieldSetting(
          'Passing Grade',
          'Minimum grade to pass',
          Icons.check_rounded,
          _passingGrade,
          (value) => setState(() => _passingGrade = value),
          keyboardType: TextInputType.number,
        ),
        _buildSwitchSetting(
          'Allow Partial Credit',
          'Enable partial scoring for questions',
          Icons.percent_rounded,
          _allowPartialCredit,
          (value) => setState(() => _allowPartialCredit = value),
        ),
        _buildSwitchSetting(
          'Auto-Grade Quizzes',
          'Automatically grade multiple choice questions',
          Icons.auto_awesome_rounded,
          _autoGradeQuizzes,
          (value) => setState(() => _autoGradeQuizzes = value),
        ),
        _buildSwitchSetting(
          'Show Feedback Immediately',
          'Display feedback right after submission',
          Icons.feedback_rounded,
          _showFeedbackImmediately,
          (value) => setState(() => _showFeedbackImmediately = value),
        ),
      ],
    );
  }

  Widget _buildSubmissionSettings() {
    return _buildSettingsSection(
      'Submission Settings',
      Icons.assignment_turned_in_rounded,
      [
        _buildDropdownSetting(
          'Default Submission Format',
          'What students can submit',
          Icons.upload_rounded,
          _defaultSubmissionFormat,
          _submissionFormats,
          (value) => setState(() => _defaultSubmissionFormat = value!),
        ),
        _buildSwitchSetting(
          'Allow Multiple Attempts',
          'Students can resubmit assignments',
          Icons.repeat_rounded,
          _allowMultipleAttempts,
          (value) => setState(() => _allowMultipleAttempts = value),
        ),
        if (_allowMultipleAttempts)
          _buildTextFieldSetting(
            'Maximum Attempts',
            'Number of allowed attempts',
            Icons.numbers_rounded,
            _maxAttempts,
            (value) => setState(() => _maxAttempts = value),
            keyboardType: TextInputType.number,
          ),
        _buildSwitchSetting(
          'Show Submission History',
          'Display previous submission attempts',
          Icons.history_rounded,
          _showSubmissionHistory,
          (value) => setState(() => _showSubmissionHistory = value),
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
          'Email Notifications',
          'Send notifications via email',
          Icons.email_rounded,
          _emailNotifications,
          (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchSetting(
          'Push Notifications',
          'Send mobile push notifications',
          Icons.mobile_friendly_rounded,
          _pushNotifications,
          (value) => setState(() => _pushNotifications = value),
        ),
        _buildSwitchSetting(
          'Reminder Emails',
          'Send reminder emails before due dates',
          Icons.alarm_rounded,
          _reminderEmails,
          (value) => setState(() => _reminderEmails = value),
        ),
        if (_reminderEmails)
          _buildDropdownSetting(
            'Reminder Timing',
            'When to send reminders',
            Icons.schedule_rounded,
            _reminderTiming,
            _reminderTimings,
            (value) => setState(() => _reminderTiming = value!),
          ),
        _buildSwitchSetting(
          'Overdue Notifications',
          'Notify when assignments are overdue',
          Icons.warning_rounded,
          _overdueNotifications,
          (value) => setState(() => _overdueNotifications = value),
        ),
        _buildSwitchSetting(
          'Grade Notifications',
          'Notify students when grades are posted',
          Icons.grade_rounded,
          _gradeNotifications,
          (value) => setState(() => _gradeNotifications = value),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return _buildSettingsSection(
      'Advanced Settings',
      Icons.tune_rounded,
      [
        _buildActionSetting(
          'Export Settings',
          'Save current settings to file',
          Icons.download_rounded,
          _exportSettings,
        ),
        _buildActionSetting(
          'Import Settings',
          'Load settings from file',
          Icons.upload_rounded,
          _importSettings,
        ),
        _buildActionSetting(
          'Reset to Defaults',
          'Restore all default settings',
          Icons.refresh_rounded,
          _resetToDefaults,
        ),
        _buildActionSetting(
          'Clear Cache',
          'Clear cached assignment data',
          Icons.clear_rounded,
          _clearCache,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey.shade600, size: 20),
          ),
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
                    fontSize: 12,
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.grey.shade600, size: 20),
              ),
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
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSetting(
    String title,
    String subtitle,
    IconData icon,
    String value,
    Function(String) onChanged, {
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.grey.shade600, size: 20),
              ),
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
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: value,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: onChanged,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
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
                        fontSize: 12,
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
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings exported successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _importSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Import Settings'),
        content: const Text('Select a settings file to import configuration.'),
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
                  content: const Text('Settings imported successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Import', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset to Defaults'),
        content: const Text('Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allowLateSubmissions = true;
                _emailNotifications = true;
                _pushNotifications = false;
                _showGradesToStudents = true;
                _autoGradeQuizzes = false;
                _requireConfirmation = true;
                _defaultGradingScale = 'Percentage';
                _passingGrade = '60';
                _allowPartialCredit = true;
                _showFeedbackImmediately = false;
                _defaultSubmissionFormat = 'Text & Files';
                _allowMultipleAttempts = false;
                _maxAttempts = '3';
                _showSubmissionHistory = true;
                _reminderEmails = true;
                _reminderTiming = '24 hours';
                _overdueNotifications = true;
                _gradeNotifications = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to defaults!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached assignment data. Continue?'),
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
                  content: const Text('Cache cleared successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings saved successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 