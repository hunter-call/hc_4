import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hc_4/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:hc_4/styles/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to',
      'title2': 'our app!',
      'subtitle': 'Study subjects and areas that interest you',
      'imagePath':
          'assets/images/college campus-rafiki 1.png', // Replace with your image
    },
    {
      'title': 'Focus on what\'s',
      'title2': 'important!',
      'subtitle': 'Choose the subjects that are a priority for you right now',
      'imagePath':
          'assets/images/Education-rafiki 1.png', // Replace with your image
    },
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomNavigationBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final page = _pages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset(
                  page['imagePath']!,
                  height: 250,
                ),
                SizedBox(height: 24),
                Text(
                  page['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  page['title2']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  page['subtitle']!,
                  textAlign: TextAlign.center,
                  style:
                      AppTheme.bodyMedium.copyWith(color: AppTheme.secondary),
                ),
                Spacer(),
                CupertinoButton(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(24),
                  onPressed: _nextPage,
                  child: Text(
                    'Continue',
                    style: AppTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
