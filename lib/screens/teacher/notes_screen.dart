import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _searchAnimation;

  final TextEditingController _searchTextController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isSearching = false;
  String _selectedView = 'Grid';

  final List<String> _categories = [
    'All',
    'Lesson Plans',
    'Meeting Notes',
    'Ideas',
    'Resources',
    'Personal',
  ];
  final List<String> _viewOptions = ['Grid', 'List'];

  final List<Map<String, dynamic>> _notes = [
    {
      'id': '1',
      'title': 'Algebra Lesson Plan - Quadratic Equations',
      'content':
          'Introduction to quadratic equations with real-world examples. Cover factoring, completing the square, and quadratic formula.',
      'category': 'Lesson Plans',
      'subject': 'Mathematics',
      'class': 'Class 10A',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'updatedAt': DateTime.now().subtract(const Duration(hours: 1)),
      'tags': ['algebra', 'quadratic', 'math'],
      'color': AppTheme.primaryColor,
      'isPinned': true,
      'hasAttachments': true,
      'attachmentCount': 3,
    },
    {
      'id': '2',
      'title': 'Parent-Teacher Meeting Notes',
      'content':
          'Discussion points for upcoming parent meetings. Focus on student progress and areas for improvement.',
      'category': 'Meeting Notes',
      'subject': 'General',
      'class': 'All Classes',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'updatedAt': DateTime.now().subtract(const Duration(hours: 3)),
      'tags': ['meetings', 'parents', 'progress'],
      'color': AppTheme.parentColor,
      'isPinned': false,
      'hasAttachments': false,
      'attachmentCount': 0,
    },
    {
      'id': '3',
      'title': 'Physics Lab Ideas',
      'content':
          'Creative experiments for teaching Newton\'s laws. Include pendulum, friction, and momentum demonstrations.',
      'category': 'Ideas',
      'subject': 'Physics',
      'class': 'Class 10B',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
      'tags': ['physics', 'experiments', 'newton'],
      'color': AppTheme.teacherColor,
      'isPinned': true,
      'hasAttachments': true,
      'attachmentCount': 5,
    },
    {
      'id': '4',
      'title': 'Chemistry Safety Guidelines',
      'content':
          'Important safety protocols for lab work. Review with students before each lab session.',
      'category': 'Resources',
      'subject': 'Chemistry',
      'class': 'Class 11A',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 2)),
      'tags': ['chemistry', 'safety', 'lab'],
      'color': AppTheme.successColor,
      'isPinned': false,
      'hasAttachments': true,
      'attachmentCount': 2,
    },
    {
      'id': '5',
      'title': 'Teaching Methodology Research',
      'content':
          'Notes on active learning techniques and their effectiveness in STEM education.',
      'category': 'Personal',
      'subject': 'Professional Development',
      'class': 'N/A',
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 4)),
      'tags': ['teaching', 'research', 'methodology'],
      'color': AppTheme.warningColor,
      'isPinned': false,
      'hasAttachments': false,
      'attachmentCount': 0,
    },
    {
      'id': '6',
      'title': 'Student Assessment Rubric',
      'content':
          'Detailed rubric for project-based assessments. Include criteria for creativity, accuracy, and presentation.',
      'category': 'Resources',
      'subject': 'General',
      'class': 'All Classes',
      'createdAt': DateTime.now().subtract(const Duration(days: 7)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 6)),
      'tags': ['assessment', 'rubric', 'projects'],
      'color': AppTheme.studentColor,
      'isPinned': true,
      'hasAttachments': true,
      'attachmentCount': 1,
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

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  List<Map<String, dynamic>> get _filteredNotes {
    var filtered =
        _notes.where((note) {
          if (_selectedCategory != 'All' &&
              note['category'] != _selectedCategory) {
            return false;
          }
          if (_searchTextController.text.isNotEmpty) {
            final searchTerm = _searchTextController.text.toLowerCase();
            return note['title'].toLowerCase().contains(searchTerm) ||
                note['content'].toLowerCase().contains(searchTerm) ||
                note['tags'].any(
                  (tag) => tag.toLowerCase().contains(searchTerm),
                );
          }
          return true;
        }).toList();

    // Sort pinned notes first
    filtered.sort((a, b) {
      if (a['isPinned'] && !b['isPinned']) return -1;
      if (!a['isPinned'] && b['isPinned']) return 1;
      return b['updatedAt'].compareTo(a['updatedAt']);
    });

    return filtered;
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
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildCategoryTabs(),
                  _buildViewToggle(),
                  Expanded(child: _buildNotesContent()),
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
        'Class Notes',
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
          icon: Icon(
            _isSearching ? Icons.close_rounded : Icons.search_rounded,
            color: const Color(0xFF2D3748),
          ),
          onPressed: _toggleSearch,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.warningColor.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Notes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_filteredNotes.length} notes available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.note_alt_rounded,
              color: AppTheme.warningColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedBuilder(
      animation: _searchAnimationController,
      builder:
          (context, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: _isSearching ? 60 : 0,
            child:
                _isSearching
                    ? Container(
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
                      child: TextField(
                        controller: _searchTextController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search notes, tags, or content...',
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon:
                              _searchTextController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      _searchTextController.clear();
                                      setState(() {});
                                    },
                                  )
                                  : null,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(24, 16, 0, 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          final count =
              category == 'All'
                  ? _notes.length
                  : _notes.where((note) => note['category'] == category).length;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: AppConstants.shortAnimation,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.warningColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.warningColor : Colors.grey.shade300,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppTheme.warningColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.white.withOpacity(0.2)
                              : AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppTheme.warningColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
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

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Text(
            '${_filteredNotes.length} ${_filteredNotes.length == 1 ? 'note' : 'notes'}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children:
                  _viewOptions.map((option) {
                    final isSelected = _selectedView == option;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedView = option;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppTheme.warningColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          option == 'Grid'
                              ? Icons.grid_view_rounded
                              : Icons.list_rounded,
                          size: 18,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600,
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

  Widget _buildNotesContent() {
    if (_filteredNotes.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: _selectedView == 'Grid' ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: _buildNoteCard(_filteredNotes[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 200 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildNoteListItem(_filteredNotes[index], index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    final color = note['color'] as Color;
    final isPinned = note['isPinned'] as bool;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _openNote(note),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(note['category']),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  if (isPinned)
                    Icon(Icons.push_pin_rounded, color: color, size: 16),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _showNoteOptions(note),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                note['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Content Preview
              Text(
                note['content'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Tags
              if (note['tags'].isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children:
                      (note['tags'] as List<String>).take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],

              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note['updatedAt']),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                  const Spacer(),
                  if (note['hasAttachments'])
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file_rounded,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${note['attachmentCount']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteListItem(Map<String, dynamic> note, int index) {
    final color = note['color'] as Color;
    final isPinned = note['isPinned'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _openNote(note),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(note['category']),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              note['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPinned)
                            Icon(
                              Icons.push_pin_rounded,
                              color: color,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        note['content'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              note['category'],
                              style: TextStyle(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(note['updatedAt']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          if (note['hasAttachments'])
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_file_rounded,
                                  size: 14,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${note['attachmentCount']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showNoteOptions(note),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.note_add_rounded,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notes Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedCategory == 'All'
                ? 'Start creating your first note!'
                : 'No notes in this category',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createNewNote,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
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
      onPressed: _createNewNote,
      backgroundColor: AppTheme.warningColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'New Note',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper Methods
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Lesson Plans':
        return Icons.school_rounded;
      case 'Meeting Notes':
        return Icons.meeting_room_rounded;
      case 'Ideas':
        return Icons.lightbulb_rounded;
      case 'Resources':
        return Icons.folder_rounded;
      case 'Personal':
        return Icons.person_rounded;
      default:
        return Icons.note_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Action Methods
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });

    if (_isSearching) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
      _searchTextController.clear();
    }

    HapticFeedback.lightImpact();
  }

  void _createNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NoteEditorScreen(
              note: null,
              onSave: (noteData) {
                setState(() {
                  _notes.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'createdAt': DateTime.now(),
                    'updatedAt': DateTime.now(),
                    'isPinned': false,
                    'hasAttachments': false,
                    'attachmentCount': 0,
                    'tags': [],
                    ...noteData,
                  });
                });
              },
            ),
      ),
    );
  }

  void _openNote(Map<String, dynamic> note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NoteEditorScreen(
              note: note,
              onSave: (noteData) {
                setState(() {
                  final index = _notes.indexWhere((n) => n['id'] == note['id']);
                  if (index != -1) {
                    _notes[index] = {
                      ..._notes[index],
                      ...noteData,
                      'updatedAt': DateTime.now(),
                    };
                  }
                });
              },
            ),
      ),
    );
  }

  void _showNoteOptions(Map<String, dynamic> note) {
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
                Text(
                  note['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                _buildNoteOption(
                  note['isPinned']
                      ? Icons.push_pin_outlined
                      : Icons.push_pin_rounded,
                  note['isPinned'] ? 'Unpin Note' : 'Pin Note',
                  () => _togglePin(note),
                ),
                _buildNoteOption(
                  Icons.share_rounded,
                  'Share Note',
                  () => _shareNote(note),
                ),
                _buildNoteOption(
                  Icons.content_copy_rounded,
                  'Duplicate',
                  () => _duplicateNote(note),
                ),
                _buildNoteOption(
                  Icons.download_rounded,
                  'Export',
                  () => _exportNote(note),
                ),
                _buildNoteOption(
                  Icons.delete_rounded,
                  'Delete',
                  () => _deleteNote(note),
                  isDestructive: true,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildNoteOption(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.warningColor,
      ),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? AppTheme.errorColor : null),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _togglePin(Map<String, dynamic> note) {
    setState(() {
      note['isPinned'] = !note['isPinned'];
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(note['isPinned'] ? 'Note pinned' : 'Note unpinned'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _shareNote(Map<String, dynamic> note) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _duplicateNote(Map<String, dynamic> note) {
    setState(() {
      _notes.insert(0, {
        ...note,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': '${note['title']} (Copy)',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isPinned': false,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note duplicated successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _exportNote(Map<String, dynamic> note) {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _deleteNote(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.delete_rounded, color: AppTheme.errorColor),
                const SizedBox(width: 8),
                const Text('Delete Note'),
              ],
            ),
            content: Text(
              'Are you sure you want to delete "${note['title']}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _notes.removeWhere((n) => n['id'] == note['id']);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note deleted successfully'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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
                _buildOptionItem(Icons.sort_rounded, 'Sort Notes', () {}),
                _buildOptionItem(
                  Icons.filter_list_rounded,
                  'Filter Options',
                  () {},
                ),
                _buildOptionItem(Icons.backup_rounded, 'Backup Notes', () {}),
                _buildOptionItem(
                  Icons.settings_rounded,
                  'Notes Settings',
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
      leading: Icon(icon, color: AppTheme.warningColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _animationController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }
}

// Note Editor Screen
class NoteEditorScreen extends StatefulWidget {
  final Map<String, dynamic>? note;
  final Function(Map<String, dynamic>) onSave;

  const NoteEditorScreen({Key? key, this.note, required this.onSave})
    : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  String _selectedCategory = 'Lesson Plans';
  String _selectedSubject = 'Mathematics';
  String _selectedClass = 'Class 10A';
  Color _selectedColor = AppTheme.primaryColor;
  bool _isPinned = false;

  final List<String> _categories = [
    'Lesson Plans',
    'Meeting Notes',
    'Ideas',
    'Resources',
    'Personal',
  ];
  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'General',
    'Professional Development',
  ];
  final List<String> _classes = [
    'Class 10A',
    'Class 10B',
    'Class 11A',
    'Class 12A',
    'All Classes',
    'N/A',
  ];
  final List<Color> _colors = [
    AppTheme.primaryColor,
    AppTheme.teacherColor,
    AppTheme.studentColor,
    AppTheme.parentColor,
    AppTheme.successColor,
    AppTheme.warningColor,
    AppTheme.errorColor,
    AppTheme.adminColor,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _contentController.text = widget.note!['content'];
      _selectedCategory = widget.note!['category'];
      _selectedSubject = widget.note!['subject'];
      _selectedClass = widget.note!['class'];
      _selectedColor = widget.note!['color'];
      _isPinned = widget.note!['isPinned'];
      _tagsController.text = (widget.note!['tags'] as List<String>).join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3748),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Save',
              style: TextStyle(
                color: _selectedColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3748),
              ),
              decoration: const InputDecoration(
                hintText: 'Note title...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Options Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildOptionChip(
                    Icons.category_rounded,
                    _selectedCategory,
                    () => _showCategoryPicker(),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    Icons.book_rounded,
                    _selectedSubject,
                    () => _showSubjectPicker(),
                  ),
                  const SizedBox(width: 8),
                  _buildOptionChip(
                    Icons.class_rounded,
                    _selectedClass,
                    () => _showClassPicker(),
                  ),
                  const SizedBox(width: 8),
                  _buildColorChip(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Content Field
            Container(
              constraints: const BoxConstraints(minHeight: 200),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Color(0xFF2D3748),
                ),
                decoration: const InputDecoration(
                  hintText: 'Start writing your note...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tags Field
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Tags (comma separated)',
                hintText: 'algebra, quadratic, math',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.tag_rounded),
              ),
            ),

            const SizedBox(height: 24),

            // Pin Option
            SwitchListTile(
              title: const Text('Pin this note'),
              subtitle: const Text('Pinned notes appear at the top'),
              value: _isPinned,
              onChanged: (value) {
                setState(() {
                  _isPinned = value;
                });
              },
              activeColor: _selectedColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionChip(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _selectedColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _selectedColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: _selectedColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorChip() {
    return GestureDetector(
      onTap: _showColorPicker,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _selectedColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: _selectedColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.palette_rounded, color: Colors.white, size: 16),
      ),
    );
  }

  void _showCategoryPicker() {
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
                const Text(
                  'Select Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                ..._categories.map((category) {
                  return ListTile(
                    leading: Icon(
                      _getCategoryIcon(category),
                      color: _selectedColor,
                    ),
                    title: Text(category),
                    trailing:
                        _selectedCategory == category
                            ? Icon(Icons.check_rounded, color: _selectedColor)
                            : null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }

  void _showSubjectPicker() {
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
                const Text(
                  'Select Subject',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                ..._subjects.map((subject) {
                  return ListTile(
                    title: Text(subject),
                    trailing:
                        _selectedSubject == subject
                            ? Icon(Icons.check_rounded, color: _selectedColor)
                            : null,
                    onTap: () {
                      setState(() {
                        _selectedSubject = subject;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }

  void _showClassPicker() {
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
                const Text(
                  'Select Class',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                ..._classes.map((className) {
                  return ListTile(
                    title: Text(className),
                    trailing:
                        _selectedClass == className
                            ? Icon(Icons.check_rounded, color: _selectedColor)
                            : null,
                    onTap: () {
                      setState(() {
                        _selectedClass = className;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }

  void _showColorPicker() {
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
                const Text(
                  'Select Color',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children:
                      _colors.map((color) {
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child:
                                isSelected
                                    ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                    : null,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Lesson Plans':
        return Icons.school_rounded;
      case 'Meeting Notes':
        return Icons.meeting_room_rounded;
      case 'Ideas':
        return Icons.lightbulb_rounded;
      case 'Resources':
        return Icons.folder_rounded;
      case 'Personal':
        return Icons.person_rounded;
      default:
        return Icons.note_rounded;
    }
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for your note'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final tags =
        _tagsController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();

    final noteData = {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'category': _selectedCategory,
      'subject': _selectedSubject,
      'class': _selectedClass,
      'color': _selectedColor,
      'isPinned': _isPinned,
      'tags': tags,
    };

    widget.onSave(noteData);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.note == null ? 'Note created!' : 'Note updated!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
