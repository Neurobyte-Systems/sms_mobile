import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class NewAssessmentScreen extends StatefulWidget {
  final String? initialClass;
  final String? initialSubject;
  final String? initialTerm;

  const NewAssessmentScreen({
    Key? key,
    this.initialClass,
    this.initialSubject,
    this.initialTerm,
  }) : super(key: key);

  @override
  State<NewAssessmentScreen> createState() => _NewAssessmentScreenState();
}

class _NewAssessmentScreenState extends State<NewAssessmentScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxScoreController = TextEditingController();
  final _instructionsController = TextEditingController();

  // Form data
  String _selectedAssessmentType = 'Quiz';
  String _selectedClass = '10A';
  String _selectedSubject = 'Mathematics';
  String _selectedTerm = 'Term 1';
  String _selectedDifficulty = 'Medium';
  String _selectedGradingMethod = 'Points';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _dueTime = TimeOfDay.now();
  bool _allowLateSubmission = true;
  bool _showResultsImmediately = false;
  bool _randomizeQuestions = false;
  bool _requireSubmissionConfirmation = true;
  int _timeLimit = 60; // minutes
  bool _hasTimeLimit = false;

  // Options
  final List<String> _assessmentTypes = [
    'Quiz',
    'Assignment',
    'Test',
    'Project',
    'Presentation',
    'Lab Report',
    'Essay',
    'Exam'
  ];

  final List<String> _classes = ['10A', '10B', '11A', '11B', '12A', '12B'];
  final List<String> _subjects = [
    'Mathematics',
    'English',
    'Science',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology'
  ];
  final List<String> _terms = ['Term 1', 'Term 2', 'Term 3'];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> _gradingMethods = ['Points', 'Percentage', 'Letter Grade', 'Pass/Fail'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeDefaults();
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

  void _initializeDefaults() {
    if (widget.initialClass != null) {
      // Remove "Class " prefix if it exists
      String classValue = widget.initialClass!;
      if (classValue.startsWith('Class ')) {
        classValue = classValue.substring(6);
      }
      // Only set if the value exists in our dropdown options
      if (_classes.contains(classValue)) {
        _selectedClass = classValue;
      }
    }
    if (widget.initialSubject != null) _selectedSubject = widget.initialSubject!;
    if (widget.initialTerm != null) _selectedTerm = widget.initialTerm!;
    
    _maxScoreController.text = '100';
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
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(child: _buildHeader()),
                    
                    // Assessment Type Selection
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSectionTitle('Assessment Type'),
                          const SizedBox(height: 16),
                          _buildAssessmentTypeSelection(),
                        ],
                      ),
                    ),

                    // Basic Information
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSectionTitle('Basic Information'),
                          const SizedBox(height: 16),
                          _buildBasicInformation(),
                        ],
                      ),
                    ),

                    // Class & Subject Selection
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSectionTitle('Class & Subject'),
                          const SizedBox(height: 16),
                          _buildClassSubjectSelection(),
                        ],
                      ),
                    ),

                    // Assessment Details
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSectionTitle('Assessment Details'),
                          const SizedBox(height: 16),
                          _buildAssessmentDetails(),
                        ],
                      ),
                    ),

                    // Due Date & Time
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSectionTitle('Due Date & Time'),
                          const SizedBox(height: 16),
                          _buildDueDateTimeSelection(),
                        ],
                      ),
                    ),

                    // Settings
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSectionTitle('Settings'),
                          const SizedBox(height: 16),
                          _buildSettingsSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
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
        'New Assessment',
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
          icon: const Icon(
            Icons.save_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _saveDraft,
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _showMoreOptions,
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
          colors: [AppTheme.primaryColor.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.assignment_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Assessment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Design and configure your assessment',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
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
    );
  }

  Widget _buildAssessmentTypeSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _assessmentTypes.map((type) {
          final isSelected = _selectedAssessmentType == type;
          return GestureDetector(
            onTap: () => setState(() => _selectedAssessmentType = type),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildTextField(
            controller: _titleController,
            label: 'Assessment Title',
            hint: 'Enter assessment title',
            icon: Icons.title_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter assessment title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Enter assessment description',
            icon: Icons.description_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _instructionsController,
            label: 'Instructions',
            hint: 'Enter instructions for students',
            icon: Icons.info_outline_rounded,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildClassSubjectSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Class',
                  value: _selectedClass,
                  items: _classes,
                  onChanged: (value) => setState(() => _selectedClass = value!),
                  icon: Icons.class_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  label: 'Subject',
                  value: _selectedSubject,
                  items: _subjects,
                  onChanged: (value) => setState(() => _selectedSubject = value!),
                  icon: Icons.subject_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Term',
            value: _selectedTerm,
            items: _terms,
            onChanged: (value) => setState(() => _selectedTerm = value!),
            icon: Icons.calendar_today_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _maxScoreController,
                  label: 'Maximum Score',
                  hint: '100',
                  icon: Icons.grade_rounded,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter maximum score';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  label: 'Difficulty',
                  value: _selectedDifficulty,
                  items: _difficulties,
                  onChanged: (value) => setState(() => _selectedDifficulty = value!),
                  icon: Icons.trending_up_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Grading Method',
            value: _selectedGradingMethod,
            items: _gradingMethods,
            onChanged: (value) => setState(() => _selectedGradingMethod = value!),
            icon: Icons.assessment_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateTimeSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateSelector(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeSelector(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeLimitSection(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due Time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dueTime.format(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLimitSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.timer_rounded, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time Limit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      _hasTimeLimit ? '$_timeLimit minutes' : 'No time limit',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _hasTimeLimit,
                onChanged: (value) => setState(() => _hasTimeLimit = value),
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
          if (_hasTimeLimit) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _timeLimit.toDouble(),
                    min: 5,
                    max: 180,
                    divisions: 35,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) => setState(() => _timeLimit = value.toInt()),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '$_timeLimit min',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildSettingTile(
            'Allow Late Submission',
            'Students can submit after due date',
            Icons.schedule_rounded,
            _allowLateSubmission,
            (value) => setState(() => _allowLateSubmission = value),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            'Show Results Immediately',
            'Display results right after submission',
            Icons.visibility_rounded,
            _showResultsImmediately,
            (value) => setState(() => _showResultsImmediately = value),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            'Randomize Questions',
            'Show questions in random order',
            Icons.shuffle_rounded,
            _randomizeQuestions,
            (value) => setState(() => _randomizeQuestions = value),
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            'Require Submission Confirmation',
            'Ask for confirmation before submitting',
            Icons.check_circle_outline_rounded,
            _requireSubmissionConfirmation,
            (value) => setState(() => _requireSubmissionConfirmation = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryColor),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: AppTheme.primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      heroTag: "new_assessment_create_fab",
      onPressed: _createAssessment,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Create Assessment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Action Methods
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (picked != null && picked != _dueTime) {
      setState(() {
        _dueTime = picked;
      });
    }
  }

  void _saveDraft() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assessment saved as draft'),
        backgroundColor: AppTheme.successColor,
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
              'More Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildMoreOption(
              Icons.copy_rounded,
              'Duplicate Assessment',
              'Create a copy of this assessment',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assessment duplicated'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildMoreOption(
              Icons.bookmark_rounded,
              'Save as Template',
              'Save this configuration as a template',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Template saved'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildMoreOption(
              Icons.import_export_rounded,
              'Import Questions',
              'Import questions from file or bank',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening question bank...'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }

  void _createAssessment() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.successColor),
              const SizedBox(width: 8),
              const Text('Assessment Created'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your ${_selectedAssessmentType.toLowerCase()} "${_titleController.text}" has been created successfully.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: $_selectedAssessmentType'),
                    Text('Class: $_selectedClass'),
                    Text('Subject: $_selectedSubject'),
                    Text('Due: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year} at ${_dueTime.format(context)}'),
                    Text('Max Score: ${_maxScoreController.text}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(); // Go back to grades screen
                }
              },
              child: const Text('Done'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Reset form for new assessment
                _resetForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text(
                'Create Another',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _instructionsController.clear();
    _maxScoreController.text = '100';
    setState(() {
      _selectedAssessmentType = 'Quiz';
      _selectedDifficulty = 'Medium';
      _selectedGradingMethod = 'Points';
      _dueDate = DateTime.now().add(const Duration(days: 7));
      _dueTime = TimeOfDay.now();
      _allowLateSubmission = true;
      _showResultsImmediately = false;
      _randomizeQuestions = false;
      _requireSubmissionConfirmation = true;
      _timeLimit = 60;
      _hasTimeLimit = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _maxScoreController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
} 