import 'package:flutter/material.dart';
import 'package:hc_4/styles/app_theme.dart';

class LearningObjectiveCard extends StatelessWidget {
  final int learningObjects;

  const LearningObjectiveCard({
    super.key,
    required this.learningObjects,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF301BA6), Color(0xff13094C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20), // Закругленные углы
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: 'You now have \n',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.secondary,
                    ),
                    children: [
                      TextSpan(
                        text: '$learningObjects ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const TextSpan(
                        text: 'learning objectives',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/Muslim graduation-rafiki 1.png', // Replace with your image asset
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
