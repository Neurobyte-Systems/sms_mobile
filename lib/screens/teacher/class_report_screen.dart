import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class ClassReportScreen extends StatefulWidget {
  final String selectedClass;
  final String selectedSubject;
  final String selectedTerm;
  final List<Map<String, dynamic>> studentsData;

  const ClassReportScreen({
    Key? key,
    required this.selectedClass,
    required this.selectedSubject,
    required this.selectedTerm,
    required this.studentsData,
  }) : super(key: key);

  @override
  State<ClassReportScreen> createState() => _ClassReportScreenState();
}

class _ClassReportScreenState extends State<ClassReportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

  double _calculateCumulativeGrade(Map<String, dynamic> student) {
    final assessments = student['assessments'] as Map<String, dynamic>;
    final weights = student['weights'] as Map<String, dynamic>;
    
    double totalScore = 0.0;
    
    assessments.forEach((key, value) {
      if (key == 'participation' || key == 'attendance') {
        totalScore += (value as num) * (weights[key] as num);
      } else if (value is List && value.isNotEmpty) {
        double average = value.cast<num>().reduce((a, b) => a + b) / value.length;
        totalScore += average * (weights[key] as num);
      }
    });
    
    return totalScore;
  }

  String _getLetterGrade(double score) {
    if (score >= 97) return 'A+';
    if (score >= 93) return 'A';
    if (score >= 90) return 'A-';
    if (score >= 87) return 'B+';
    if (score >= 83) return 'B';
    if (score >= 80) return 'B-';
    if (score >= 77) return 'C+';
    if (score >= 73) return 'C';
    if (score >= 70) return 'C-';
    if (score >= 67) return 'D+';
    if (score >= 65) return 'D';
    return 'F';
  }

  Color _getGradeColor(double score) {
    if (score >= 90) return AppTheme.successColor;
    if (score >= 80) return AppTheme.primaryColor;
    if (score >= 70) return AppTheme.warningColor;
    if (score >= 60) return Colors.orange;
    return AppTheme.errorColor;
  }

  Map<String, dynamic> _calculateClassStats() {
    final grades = widget.studentsData.map((student) => _calculateCumulativeGrade(student)).toList();
    final average = grades.isNotEmpty ? grades.reduce((a, b) => a + b) / grades.length : 0.0;
    final highest = grades.isNotEmpty ? grades.reduce((a, b) => a > b ? a : b) : 0.0;
    final lowest = grades.isNotEmpty ? grades.reduce((a, b) => a < b ? a : b) : 0.0;
    
    // Grade distribution
    final gradeDistribution = <String, int>{};
    for (final grade in grades) {
      final letter = _getLetterGrade(grade);
      gradeDistribution[letter] = (gradeDistribution[letter] ?? 0) + 1;
    }
    
    return {
      'average': average,
      'highest': highest,
      'lowest': lowest,
      'totalStudents': widget.studentsData.length,
      'gradeDistribution': gradeDistribution,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateClassStats();
    
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
                  // Class Header
                  SliverToBoxAdapter(child: _buildClassHeader(stats)),

                  // Action Buttons
                  SliverToBoxAdapter(child: _buildActionButtons()),

                  // Class Statistics
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Class Statistics'),
                        const SizedBox(height: 16),
                        _buildStatisticsCards(stats),
                      ],
                    ),
                  ),

                  // Grade Distribution
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Grade Distribution'),
                        const SizedBox(height: 16),
                        _buildGradeDistribution(stats['gradeDistribution']),
                      ],
                    ),
                  ),

                  // Student Rankings
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Student Rankings'),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Student List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final sortedStudents = List<Map<String, dynamic>>.from(widget.studentsData);
                        sortedStudents.sort((a, b) => _calculateCumulativeGrade(b).compareTo(_calculateCumulativeGrade(a)));
                        
                        return _buildStudentRankingCard(sortedStudents[index], index + 1);
                      },
                      childCount: widget.studentsData.length,
                    ),
                  ),

                  SliverToBoxAdapter(child: const SizedBox(height: 100)),
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
      title: Text(
        'Class Report - ${widget.selectedClass}',
        style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
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
          icon: const Icon(
            Icons.print_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _printClassReport,
        ),
        IconButton(
          icon: const Icon(
            Icons.download_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _exportClassReport,
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

  Widget _buildClassHeader(Map<String, dynamic> stats) {
    final averageGrade = stats['average'] as double;
    final gradeColor = _getGradeColor(averageGrade);
    final letterGrade = _getLetterGrade(averageGrade);
    
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradeColor.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.class_rounded,
                    size: 40,
                    color: gradeColor,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.selectedClass,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.selectedSubject} • ${widget.selectedTerm}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stats['totalStudents']} students',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      letterGrade,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: gradeColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${averageGrade.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: gradeColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Class Average',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
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
              onPressed: _printClassReport,
              icon: const Icon(Icons.print_rounded, size: 18),
              label: const Text('Print Report'),
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
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _exportClassReport,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Export Excel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _emailToParents,
              icon: const Icon(Icons.email_rounded, size: 18),
              label: const Text('Email All'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.successColor,
                side: BorderSide(color: AppTheme.successColor),
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

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(Map<String, dynamic> stats) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Highest Grade',
                  '${(stats['highest'] as double).toStringAsFixed(1)}%',
                  Icons.trending_up_rounded,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Lowest Grade',
                  '${(stats['lowest'] as double).toStringAsFixed(1)}%',
                  Icons.trending_down_rounded,
                  AppTheme.errorColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Class Average',
                  '${(stats['average'] as double).toStringAsFixed(1)}%',
                  Icons.analytics_rounded,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Students',
                  '${stats['totalStudents']}',
                  Icons.people_rounded,
                  AppTheme.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDistribution(Map<String, int> distribution) {
    final grades = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F'];
    final maxCount = distribution.values.isEmpty ? 1 : distribution.values.reduce((a, b) => a > b ? a : b);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
        children: [
          Container(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: grades.map((grade) {
                final count = distribution[grade] ?? 0;
                final height = maxCount > 0 ? (count / maxCount) * 120 : 0.0;
                final color = _getGradeColor(_getGradeScore(grade));
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (count > 0)
                          Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        SizedBox(height: count > 0 ? 2 : 0),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          grade,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  double _getGradeScore(String grade) {
    switch (grade) {
      case 'A+': return 98;
      case 'A': return 95;
      case 'A-': return 92;
      case 'B+': return 88;
      case 'B': return 85;
      case 'B-': return 82;
      case 'C+': return 78;
      case 'C': return 75;
      case 'C-': return 72;
      case 'D+': return 68;
      case 'D': return 66;
      case 'F': return 50;
      default: return 0;
    }
  }

  Widget _buildStudentRankingCard(Map<String, dynamic> student, int rank) {
    final grade = _calculateCumulativeGrade(student);
    final letterGrade = _getLetterGrade(grade);
    final gradeColor = _getGradeColor(grade);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(rank).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _getRankColor(rank),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                student['avatar'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                              Text(
                'Roll No: ${student['rollNumber']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  letterGrade,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: gradeColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${grade.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: gradeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return AppTheme.primaryColor;
  }

  // Action Methods
  void _printClassReport() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.print_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Print Class Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Print complete class assessment report for ${widget.selectedClass}?'),
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
                  Text('Class: ${widget.selectedClass}'),
                  Text('Subject: ${widget.selectedSubject}'),
                  Text('Term: ${widget.selectedTerm}'),
                  Text('Students: ${widget.studentsData.length}'),
                  Text('Average: ${_calculateClassStats()['average'].toStringAsFixed(1)}%'),
                ],
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
                  content: Text('Printing ${widget.selectedClass} report...'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text(
              'Print',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _exportClassReport() {
    HapticFeedback.lightImpact();
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
              'Export ${widget.selectedClass} Report',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              Icons.table_chart_rounded,
              'Export as Excel',
              'Complete class data with all student grades',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exporting ${widget.selectedClass} report as Excel...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.picture_as_pdf_rounded,
              'Export as PDF',
              'Formatted report with charts and statistics',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exporting ${widget.selectedClass} report as PDF...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.share_rounded,
              'Share Report',
              'Share via messaging or other apps',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sharing ${widget.selectedClass} report...'),
                    backgroundColor: AppTheme.successColor,
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

  void _emailToParents() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emailing ${widget.selectedClass} reports to all parents...'),
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
            _buildExportOption(
              Icons.analytics_rounded,
              'Detailed Analytics',
              'View comprehensive class performance analytics',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening detailed analytics...'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.compare_arrows_rounded,
              'Compare Terms',
              'Compare performance across different terms',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening term comparison...'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.settings_rounded,
              'Report Settings',
              'Customize report format and content',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening report settings...'),
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

  Widget _buildExportOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 