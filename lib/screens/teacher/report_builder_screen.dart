import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class ReportBuilderScreen extends StatefulWidget {
  const ReportBuilderScreen({Key? key}) : super(key: key);

  @override
  State<ReportBuilderScreen> createState() => _ReportBuilderScreenState();
}

class _ReportBuilderScreenState extends State<ReportBuilderScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _reportNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedReportType = 'Student Progress';
  String _selectedClass = 'All Classes';
  String _selectedSubject = 'All Subjects';
  String _selectedPeriod = 'Current Term';
  String _selectedFormat = 'PDF';
  
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  // Data Selection
  final Set<String> _selectedDataTypes = {'Grades', 'Attendance'};
  final Set<String> _selectedStudents = <String>{};
  final Set<String> _selectedMetrics = {'Average Grade', 'Attendance Rate'};

  // Template Settings
  bool _includeCharts = true;
  bool _includeComments = true;
  bool _includeRecommendations = false;
  bool _includeSummary = true;
  String _chartType = 'Bar Chart';
  String _sortBy = 'Student Name';

  final List<String> _reportTypes = [
    'Student Progress',
    'Class Performance',
    'Attendance Report',
    'Grade Distribution',
    'Assignment Analysis',
    'Parent Communication',
    'Behavioral Report',
    'Custom Report',
  ];

  final List<String> _classes = [
    'All Classes',
    'Class 10A',
    'Class 10B',
    'Class 11A',
    'Class 11B',
    'Class 12A',
    'Class 12B',
  ];

  final List<String> _subjects = [
    'All Subjects',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
  ];

  final List<String> _periods = [
    'Current Term',
    'Previous Term',
    'Current Year',
    'Previous Year',
    'Custom Range',
  ];

  final List<String> _formats = ['PDF', 'Excel', 'Word', 'PowerPoint'];

  final List<String> _dataTypes = [
    'Grades',
    'Attendance',
    'Assignments',
    'Behavior',
    'Test Scores',
    'Participation',
    'Homework',
    'Projects',
  ];

  final List<String> _metrics = [
    'Average Grade',
    'Attendance Rate',
    'Assignment Completion',
    'Test Performance',
    'Participation Score',
    'Improvement Rate',
    'Class Ranking',
    'Grade Trend',
  ];

  final List<String> _chartTypes = [
    'Bar Chart',
    'Line Chart',
    'Pie Chart',
    'Area Chart',
    'Column Chart',
  ];

  final List<String> _sortOptions = [
    'Student Name',
    'Grade (High to Low)',
    'Grade (Low to High)',
    'Attendance Rate',
    'Last Name',
    'Student ID',
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
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverToBoxAdapter(child: _buildReportBasics()),
                    SliverToBoxAdapter(child: _buildDataSelection()),
                    SliverToBoxAdapter(child: _buildFilterOptions()),
                    SliverToBoxAdapter(child: _buildTemplateSettings()),
                    SliverToBoxAdapter(child: _buildPreviewSection()),
                    SliverToBoxAdapter(child: _buildActionButtons()),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
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
        'Report Builder',
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
          icon: const Icon(Icons.save_rounded, color: Color(0xFF2D3748)),
          onPressed: _saveTemplate,
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
              Icons.assessment_rounded,
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
                  'Custom Report Builder',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create detailed reports for your classes',
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

  Widget _buildReportBasics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Report Basics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _reportNameController,
            decoration: const InputDecoration(
              labelText: 'Report Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title_rounded),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a report name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description_rounded),
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Report Type',
            _selectedReportType,
            _reportTypes,
            (value) => setState(() => _selectedReportType = value!),
            Icons.report_rounded,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Export Format',
            _selectedFormat,
            _formats,
            (value) => setState(() => _selectedFormat = value!),
            Icons.file_download_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Data Selection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Data Types',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dataTypes.map((type) {
              final isSelected = _selectedDataTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDataTypes.add(type);
                    } else {
                      _selectedDataTypes.remove(type);
                    }
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Metrics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _metrics.map((metric) {
              final isSelected = _selectedMetrics.contains(metric);
              return FilterChip(
                label: Text(metric),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedMetrics.add(metric);
                    } else {
                      _selectedMetrics.remove(metric);
                    }
                  });
                },
                selectedColor: AppTheme.successColor.withOpacity(0.2),
                checkmarkColor: AppTheme.successColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Class',
                  _selectedClass,
                  _classes,
                  (value) => setState(() => _selectedClass = value!),
                  Icons.class_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Subject',
                  _selectedSubject,
                  _subjects,
                  (value) => setState(() => _selectedSubject = value!),
                  Icons.subject_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Time Period',
            _selectedPeriod,
            _periods,
            (value) => setState(() => _selectedPeriod = value!),
            Icons.date_range_rounded,
          ),
          if (_selectedPeriod == 'Custom Range') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    'Start Date',
                    _startDate,
                    (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    'End Date',
                    _endDate,
                    (date) => setState(() => _endDate = date),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTemplateSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Template Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          _buildSwitchTile(
            'Include Charts',
            'Add visual charts to the report',
            _includeCharts,
            (value) => setState(() => _includeCharts = value),
          ),
          if (_includeCharts)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: _buildDropdown(
                'Chart Type',
                _chartType,
                _chartTypes,
                (value) => setState(() => _chartType = value!),
                Icons.bar_chart_rounded,
              ),
            ),
          _buildSwitchTile(
            'Include Comments',
            'Add teacher comments and notes',
            _includeComments,
            (value) => setState(() => _includeComments = value),
          ),
          _buildSwitchTile(
            'Include Recommendations',
            'Add improvement recommendations',
            _includeRecommendations,
            (value) => setState(() => _includeRecommendations = value),
          ),
          _buildSwitchTile(
            'Include Summary',
            'Add executive summary section',
            _includeSummary,
            (value) => setState(() => _includeSummary = value),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Sort By',
            _sortBy,
            _sortOptions,
            (value) => setState(() => _sortBy = value!),
            Icons.sort_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Report Preview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.preview_rounded,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Report Preview',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Generate preview to see how your report will look',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generatePreview,
              icon: const Icon(Icons.visibility_rounded),
              label: const Text('Generate Preview'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveTemplate,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Template'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _generateReport,
              icon: const Icon(Icons.file_download_rounded),
              label: const Text('Generate Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    IconData icon,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          onChanged(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today_rounded),
        ),
        child: Text(
          '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _generatePreview() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Generating preview...'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    }
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Template saved successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _generateReport() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDataTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select at least one data type'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      if (_selectedMetrics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select at least one metric'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Generate Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Report: ${_reportNameController.text}'),
              Text('Type: $_selectedReportType'),
              Text('Class: $_selectedClass'),
              Text('Subject: $_selectedSubject'),
              Text('Format: $_selectedFormat'),
              const SizedBox(height: 16),
              const Text('This will generate and download your custom report.'),
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
                    content: const Text('Report generated successfully!'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
              child: const Text('Generate', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reportNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 