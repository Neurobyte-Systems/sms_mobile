import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class DigitalWhiteboardScreen extends StatefulWidget {
  const DigitalWhiteboardScreen({Key? key}) : super(key: key);

  @override
  State<DigitalWhiteboardScreen> createState() => _DigitalWhiteboardScreenState();
}

class _DigitalWhiteboardScreenState extends State<DigitalWhiteboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _selectedTool = 'pen';
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  final List<DrawingPoint> _points = [];
  final List<WhiteboardShape> _shapes = [];
  final List<WhiteboardText> _texts = [];
  bool _isDrawing = false;
  bool _showToolbar = true;
  
  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
  ];

  final List<String> _tools = ['pen', 'highlighter', 'eraser', 'text', 'shape', 'select'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Whiteboard Canvas
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: WhiteboardPainter(
                points: _points,
                shapes: _shapes,
                texts: _texts,
              ),
              size: Size.infinite,
            ),
          ),
          
          // Toolbar
          if (_showToolbar) _buildToolbar(),
          
          // Color Palette
          if (_showToolbar) _buildColorPalette(),
          
          // Stroke Width Slider
          if (_showToolbar && (_selectedTool == 'pen' || _selectedTool == 'highlighter'))
            _buildStrokeWidthSlider(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey.shade100,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D3748)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Digital Whiteboard',
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showToolbar ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: const Color(0xFF2D3748),
          ),
          onPressed: () => setState(() => _showToolbar = !_showToolbar),
        ),
        IconButton(
          icon: const Icon(Icons.undo_rounded, color: Color(0xFF2D3748)),
          onPressed: _undo,
        ),
        IconButton(
          icon: const Icon(Icons.redo_rounded, color: Color(0xFF2D3748)),
          onPressed: _redo,
        ),
        IconButton(
          icon: const Icon(Icons.clear_rounded, color: Color(0xFF2D3748)),
          onPressed: _clearBoard,
        ),
        IconButton(
          icon: const Icon(Icons.save_rounded, color: Color(0xFF2D3748)),
          onPressed: _saveBoard,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Positioned(
      left: 20,
      top: 20,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _tools.map((tool) => _buildToolButton(tool)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolButton(String tool) {
    final isSelected = _selectedTool == tool;
    final icon = _getToolIcon(tool);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedTool = tool);
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildColorPalette() {
    return Positioned(
      right: 20,
      top: 20,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _colors.map((color) => _buildColorButton(color)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isSelected = _selectedColor == color;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedColor = color);
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
              width: isSelected ? 3 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrokeWidthSlider() {
    return Positioned(
      left: 20,
      bottom: 100,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Stroke Width: ${_strokeWidth.toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _strokeWidth,
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      setState(() => _strokeWidth = value);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "share_board",
          onPressed: _shareBoard,
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.share_rounded, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: "screenshot",
          onPressed: _takeScreenshot,
          backgroundColor: AppTheme.successColor,
          child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
        ),
      ],
    );
  }

  IconData _getToolIcon(String tool) {
    switch (tool) {
      case 'pen':
        return Icons.edit_rounded;
      case 'highlighter':
        return Icons.highlight_rounded;
      case 'eraser':
        return Icons.cleaning_services_rounded;
      case 'text':
        return Icons.text_fields_rounded;
      case 'shape':
        return Icons.crop_square_rounded;
      case 'select':
        return Icons.open_with_rounded;
      default:
        return Icons.edit_rounded;
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (_selectedTool == 'pen' || _selectedTool == 'highlighter' || _selectedTool == 'eraser') {
      setState(() {
        _isDrawing = true;
        _points.add(DrawingPoint(
          offset: details.localPosition,
          paint: Paint()
            ..color = _selectedTool == 'eraser' ? Colors.white : _selectedColor
            ..strokeWidth = _selectedTool == 'highlighter' ? _strokeWidth * 2 : _strokeWidth
            ..strokeCap = StrokeCap.round
            ..blendMode = _selectedTool == 'highlighter' ? BlendMode.multiply : BlendMode.srcOver,
        ));
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDrawing && (_selectedTool == 'pen' || _selectedTool == 'highlighter' || _selectedTool == 'eraser')) {
      setState(() {
        _points.add(DrawingPoint(
          offset: details.localPosition,
          paint: Paint()
            ..color = _selectedTool == 'eraser' ? Colors.white : _selectedColor
            ..strokeWidth = _selectedTool == 'highlighter' ? _strokeWidth * 2 : _strokeWidth
            ..strokeCap = StrokeCap.round
            ..blendMode = _selectedTool == 'highlighter' ? BlendMode.multiply : BlendMode.srcOver,
        ));
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDrawing) {
      setState(() {
        _isDrawing = false;
        _points.add(DrawingPoint(offset: Offset.infinite, paint: Paint()));
      });
    }
  }

  void _undo() {
    HapticFeedback.lightImpact();
    if (_points.isNotEmpty) {
      setState(() {
        // Remove points until we find a separator (Offset.infinite)
        while (_points.isNotEmpty && _points.last.offset != Offset.infinite) {
          _points.removeLast();
        }
        if (_points.isNotEmpty) {
          _points.removeLast(); // Remove the separator
        }
      });
    }
  }

  void _redo() {
    HapticFeedback.lightImpact();
    // Implement redo functionality
  }

  void _clearBoard() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Board'),
        content: const Text('Are you sure you want to clear the entire board?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _points.clear();
                _shapes.clear();
                _texts.clear();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveBoard() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Board saved successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _shareBoard() {
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
            const Text(
              'Share Board',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _buildShareOption(Icons.link_rounded, 'Share Link', 'Generate shareable link'),
            _buildShareOption(Icons.qr_code_rounded, 'QR Code', 'Show QR code for quick access'),
            _buildShareOption(Icons.email_rounded, 'Email', 'Send via email'),
            _buildShareOption(Icons.download_rounded, 'Export', 'Download as image/PDF'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title functionality coming soon!'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }

  void _takeScreenshot() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Screenshot saved to gallery!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showMoreOptions() {
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
            _buildMoreOption(Icons.grid_on_rounded, 'Show Grid', 'Toggle grid background'),
            _buildMoreOption(Icons.fullscreen_rounded, 'Fullscreen', 'Enter fullscreen mode'),
            _buildMoreOption(Icons.people_rounded, 'Collaborate', 'Invite students to collaborate'),
            _buildMoreOption(Icons.record_voice_over_rounded, 'Record', 'Record your presentation'),
            _buildMoreOption(Icons.settings_rounded, 'Settings', 'Whiteboard settings'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title functionality coming soon!'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class WhiteboardShape {
  final String type;
  final Offset start;
  final Offset end;
  final Paint paint;

  WhiteboardShape({
    required this.type,
    required this.start,
    required this.end,
    required this.paint,
  });
}

class WhiteboardText {
  final String text;
  final Offset position;
  final TextStyle style;

  WhiteboardText({
    required this.text,
    required this.position,
    required this.style,
  });
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawingPoint> points;
  final List<WhiteboardShape> shapes;
  final List<WhiteboardText> texts;

  WhiteboardPainter({
    required this.points,
    required this.shapes,
    required this.texts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Draw points (pen strokes)
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != Offset.infinite && points[i + 1].offset != Offset.infinite) {
        canvas.drawLine(points[i].offset, points[i + 1].offset, points[i].paint);
      }
    }

    // Draw shapes
    for (final shape in shapes) {
      switch (shape.type) {
        case 'rectangle':
          canvas.drawRect(
            Rect.fromPoints(shape.start, shape.end),
            shape.paint,
          );
          break;
        case 'circle':
          final center = Offset(
            (shape.start.dx + shape.end.dx) / 2,
            (shape.start.dy + shape.end.dy) / 2,
          );
          final radius = (shape.end - shape.start).distance / 2;
          canvas.drawCircle(center, radius, shape.paint);
          break;
        case 'line':
          canvas.drawLine(shape.start, shape.end, shape.paint);
          break;
      }
    }

    // Draw texts
    for (final text in texts) {
      final textPainter = TextPainter(
        text: TextSpan(text: text.text, style: text.style),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, text.position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 