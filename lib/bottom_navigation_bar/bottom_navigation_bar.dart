import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hc_4/folder_view/folder_page.dart';
import 'package:hc_4/main_view/main_fill_page.dart';
import 'package:hc_4/settings_view/settings_page.dart';
import 'package:hc_4/styles/app_theme.dart';
import 'package:hc_4/timer_view/time_provider/time_provider.dart';
import 'package:hc_4/timer_view/timer_page.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;
  final GlobalKey _navBarKey = GlobalKey(); // Ключ для навигационной панели

  final List<Widget> _pages = [
    const MainFillPage(),
    const FolderPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            bottom: 50.0,
            left: 16.0,
            right: 100.0,
            child: Container(
              key: _navBarKey, // Установили ключ
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.home_outlined,
                      isActive: _currentIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    _NavBarItem(
                      icon: Icons.file_copy_outlined,
                      isActive: _currentIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    _NavBarItem(
                      icon: Icons.settings_outlined,
                      isActive: _currentIndex == 2,
                      onTap: () => _onItemTapped(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TimerPage()));
              },
              child: Consumer<TimerProvider>(
                builder: (context, timerProvider, child) {
                  return Container(
                    height: 66,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 8, 36, 97),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/boliviainteligente-BqQikUnYbWE-unsplash 1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        timerProvider.isRunning
                            ? '${timerProvider.remainingTime.inMinutes.toString().padLeft(2, '0')}:${(timerProvider.remainingTime.inSeconds % 60).toString().padLeft(2, '0')}'
                            : '25',
                        style: AppTheme.displayMedium
                            .copyWith(color: AppTheme.onPrimary),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;

  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              icon,
              color: isActive ? AppTheme.primary : Colors.grey,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
