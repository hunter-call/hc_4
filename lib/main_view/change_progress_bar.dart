import 'package:flutter/material.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/styles/app_theme.dart';

class ChangeProgressPage extends StatefulWidget {
  final Operation operation;

  const ChangeProgressPage({super.key, required this.operation});

  @override
  _ChangeProgressPageState createState() => _ChangeProgressPageState();
}

class _ChangeProgressPageState extends State<ChangeProgressPage> {
  int _selectedLevel = 1;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.operation.level;
  }

  void _changeProgress(int level) async {
    widget.operation.level = level;
    await widget.operation.save();
    Navigator.pop(context, true); // Возвращаемся с результатом true
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('Change Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(5, (index) {
            int level = index + 1;
            return ListTile(
              title: Text(
                'Level $level',
                style: TextStyle(
                  color: _selectedLevel >= level
                      ? AppTheme.primary
                      : AppTheme.secondary,
                ),
              ),
              leading: Icon(
                Icons.check_circle,
                color: _selectedLevel >= level ? AppTheme.primary : Colors.grey,
              ),
              onTap: () {
                _changeProgress(level);
              },
            );
          }),
        ),
      ),
    );
  }
}
