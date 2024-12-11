import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hc_4/styles/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/Vector (7).svg',
                color: Colors.white,
              ),
              title: Text(
                'Rate app ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.redAccent,
              ),
            ),
            Divider(
              color: AppTheme.surface,
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/Vector (8).svg',
                color: Colors.white,
              ),
              title: Text(
                'Term of use ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.redAccent,
              ),
            ),
            Divider(
              color: AppTheme.surface,
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/Vector (9).svg',
                color: Colors.white,
              ),
              title: Text(
                'Privacy Policy ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.redAccent,
              ),
            ),
            Divider(
              color: AppTheme.surface,
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/Vector (10).svg',
                color: Colors.white,
              ),
              title: Text(
                'Support page ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.redAccent,
              ),
            ),
            Divider(
              color: AppTheme.surface,
            ),
          ],
        ),
      )),
    );
  }
}
