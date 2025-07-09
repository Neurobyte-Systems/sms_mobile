import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Getting Started',
    'Grading',
    'Attendance',
    'Messages',
    'Assignments',
    'Reports',
    'Technical',
  ];

  final List<Map<String, dynamic>> _faqData = [
    {
      'category': 'Getting Started',
      'question': 'How do I set up my teacher profile?',
      'answer': 'Go to Profile > Edit Profile to update your information, subjects, and classes.',
    },
    {
      'category': 'Grading',
      'question': 'How do I grade assignments?',
      'answer': 'Navigate to Assignments > Select Assignment > View Submissions > Grade each student.',
    },
    {
      'category': 'Attendance',
      'question': 'How do I take attendance?',
      'answer': 'Go to Attendance tab, select your class and subject, then mark students as Present, Absent, or Late.',
    },
    {
      'category': 'Messages',
      'question': 'How do I message parents?',
      'answer': 'Go to Messages > Compose > Select recipients (parents) > Type your message and send.',
    },
    {
      'category': 'Assignments',
      'question': 'How do I create assignments?',
      'answer': 'Go to Assignments > + button > Fill in assignment details > Set due date > Save.',
    },
    {
      'category': 'Reports',
      'question': 'How do I generate class reports?',
      'answer': 'Go to Grades > Select class > More options > Export Class Report.',
    },
    {
      'category': 'Technical',
      'question': 'App is running slowly, what should I do?',
      'answer': 'Try clearing app cache in Settings > App Settings > Clear Cache.',
    },
    {
      'category': 'Technical',
      'question': 'How do I backup my data?',
      'answer': 'Go to Settings > Teaching Settings > Enable Auto Backup or manually export data.',
    },
  ];

  final List<Map<String, dynamic>> _supportOptions = [
    {
      'title': 'Live Chat',
      'subtitle': 'Chat with our support team',
      'icon': Icons.chat_rounded,
      'color': AppTheme.primaryColor,
      'available': true,
    },
    {
      'title': 'Email Support',
      'subtitle': 'Send us an email',
      'icon': Icons.email_rounded,
      'color': AppTheme.teacherColor,
      'available': true,
    },
    {
      'title': 'Phone Support',
      'subtitle': 'Call our support line',
      'icon': Icons.phone_rounded,
      'color': AppTheme.successColor,
      'available': false,
    },
    {
      'title': 'Video Call',
      'subtitle': 'Schedule a video call',
      'icon': Icons.video_call_rounded,
      'color': AppTheme.warningColor,
      'available': true,
    },
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(child: _buildSupportOptions()),
                  SliverToBoxAdapter(child: _buildCategoryFilter()),
                  SliverToBoxAdapter(child: _buildFAQSection()),
                  SliverToBoxAdapter(child: _buildFeedbackSection()),
                  SliverToBoxAdapter(child: _buildContactInfo()),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
        'Help & Support',
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
              Icons.help_outline_rounded,
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
                  'We\'re Here to Help',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Find answers or get in touch with us',
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

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for help topics...',
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSupportOptions() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _supportOptions.length,
            itemBuilder: (context, index) {
              final option = _supportOptions[index];
              return _buildSupportOptionCard(option);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOptionCard(Map<String, dynamic> option) {
    final isAvailable = option['available'] as bool;
    
    return GestureDetector(
      onTap: isAvailable ? () => _handleSupportOption(option['title']) : null,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isAvailable 
                    ? (option['color'] as Color).withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option['icon'] as IconData,
                color: isAvailable ? option['color'] as Color : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              option['title'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isAvailable ? const Color(0xFF2D3748) : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              option['subtitle'] as String,
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? Colors.grey.shade600 : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isAvailable) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQSection() {
    final filteredFAQs = _selectedCategory == 'All'
        ? _faqData
        : _faqData.where((faq) => faq['category'] == _selectedCategory).toList();

    final searchQuery = _searchController.text.toLowerCase();
    final searchedFAQs = searchQuery.isEmpty
        ? filteredFAQs
        : filteredFAQs.where((faq) =>
            faq['question'].toLowerCase().contains(searchQuery) ||
            faq['answer'].toLowerCase().contains(searchQuery)).toList();

    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Text(
                '${searchedFAQs.length} questions',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...searchedFAQs.map((faq) => _buildFAQItem(faq)).toList(),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      margin: const EdgeInsets.all(24),
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
            'Send Feedback',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us improve by sharing your thoughts and suggestions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tell us what you think...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sendFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Send Feedback',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: const EdgeInsets.all(24),
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
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.email_rounded,
            'Email',
            'support@myschoolgh.com',
            AppTheme.primaryColor,
          ),
          _buildContactItem(
            Icons.phone_rounded,
            'Phone',
            '+233 30 123 4567',
            AppTheme.successColor,
          ),
          _buildContactItem(
            Icons.language_rounded,
            'Website',
            'www.myschoolgh.com',
            AppTheme.teacherColor,
          ),
          _buildContactItem(
            Icons.access_time_rounded,
            'Support Hours',
            'Mon-Fri: 8:00 AM - 6:00 PM',
            AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
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
          const SizedBox(width: 16),
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
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
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

  void _handleSupportOption(String option) {
    switch (option) {
      case 'Live Chat':
        _startLiveChat();
        break;
      case 'Email Support':
        _sendEmail();
        break;
      case 'Video Call':
        _scheduleVideoCall();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$option functionality coming soon!'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
    }
  }

  void _startLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Live Chat'),
        content: const Text('Starting live chat with support team...'),
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
                  content: const Text('Live chat started!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Start Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening email client...'),
        backgroundColor: AppTheme.teacherColor,
      ),
    );
  }

  void _scheduleVideoCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Schedule Video Call'),
        content: const Text('Choose your preferred time for a video call with our support team.'),
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
                  content: const Text('Video call scheduled!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warningColor),
            child: const Text('Schedule', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your feedback'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Feedback sent successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    
    _feedbackController.clear();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
} 