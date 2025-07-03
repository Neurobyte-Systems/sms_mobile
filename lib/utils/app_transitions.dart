import 'package:flutter/material.dart';

class AppTransitions {
  static PageRouteBuilder slideTransition(
    Widget destination, {
    Offset beginOffset = const Offset(1.0, 0.0),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // For slide from left (back navigation)
  static PageRouteBuilder slideTransitionFromLeft(Widget destination) {
    return slideTransition(destination, beginOffset: const Offset(-1.0, 0.0));
  }

  // For slide from bottom
  static PageRouteBuilder slideTransitionFromBottom(Widget destination) {
    return slideTransition(destination, beginOffset: const Offset(0.0, 1.0));
  }

  // For slide from top
  static PageRouteBuilder slideTransitionFromTop(Widget destination) {
    return slideTransition(destination, beginOffset: const Offset(0.0, -1.0));
  }
}

// 8. USAGE EXAMPLE: Using the helper method
// void _navigateToScreen() {
//   Navigator.of(
//     context,
//   ).push(AppTransitions.slideTransition(const NextScreen()));
// }

// // For back navigation (slide from left)
// void _navigateBack() {
//   Navigator.of(
//     context,
//   ).push(AppTransitions.slideTransitionFromLeft(const PreviousScreen()));
// }

// 9. UPDATE: Remove animation controllers from screens if they're only used for page transitions
// In each screen's initState, remove or comment out transition-related animation controllers:

/*
// REMOVE OR COMMENT OUT THESE:
_animationController = AnimationController(
  duration: const Duration(milliseconds: 800),
  vsync: this,
);

_fadeAnimation = Tween<double>(
  begin: 0.0,
  end: 1.0,
).animate(CurvedAnimation(
  parent: _animationController,
  curve: Curves.easeIn,
));

_slideAnimation = Tween<Offset>(
  begin: const Offset(0, 0.5),
  end: Offset.zero,
).animate(CurvedAnimation(
  parent: _animationController,
  curve: Curves.easeOutCubic,
));

_scaleAnimation = Tween<double>(
  begin: 0.8,
  end: 1.0,
).animate(CurvedAnimation(
  parent: _animationController,
  curve: Curves.easeOutBack,
));
*/

// 10. UPDATE: Update PageView navigation in onboarding (if needed)
// void _nextPage() {
//   HapticFeedback.lightImpact();

//   if (_currentPage < _pages.length - 1) {
//     _pageController.nextPage(
//       duration: const Duration(milliseconds: 300), // Reduced duration
//       curve: Curves.easeInOut, // Simpler curve
//     );
//   } else {
//     _finishOnboarding();
//   }
// }

// void _previousPage() {
//   HapticFeedback.lightImpact();

//   if (_currentPage > 0) {
//     _pageController.previousPage(
//       duration: const Duration(milliseconds: 300), // Reduced duration
//       curve: Curves.easeInOut, // Simpler curve
//     );
//   }
// }
