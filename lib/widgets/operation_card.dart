import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:hc_4/const/subjects.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/main_view/change_progress_bar.dart';
import 'package:hc_4/main_view/edit_operation_page.dart';
import 'package:hc_4/styles/app_theme.dart';

class OperationCard extends StatefulWidget {
  final Operation operation;
  final VoidCallback onUpdate; // Добавляем колбэк для обновления списка

  const OperationCard(
      {super.key, required this.operation, required this.onUpdate});

  @override
  _OperationCardState createState() => _OperationCardState();
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    // Рассчитываем прогресс
    double progress = widget.operation.level / 5;

    return Card(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Предмет изучения
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Иконка предмета
                Row(
                  children: [
                    SvgPicture.asset(
                      getSubjectIcon(widget.operation.subject),
                      color: AppTheme.primary,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.operation.subject,
                      style: AppTheme.displayMedium
                          .copyWith(color: AppTheme.onPrimary),
                    ),
                  ],
                ),
                PullDownButton(
                  itemBuilder: (context) => [
                    PullDownMenuItem(
                      title: 'Edit',
                      onTap: () async {
                        // Открываем страницу редактирования
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditOperationPage(
                              operation: widget.operation,
                            ),
                          ),
                        );
                        if (result == true) {
                          // Обновляем состояние после редактирования
                          setState(() {});
                          widget.onUpdate();
                        }
                      },
                    ),
                    PullDownMenuItem(
                      title: 'Change progress',
                      onTap: () async {
                        // Открываем страницу изменения прогресса
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeProgressPage(
                              operation: widget.operation,
                            ),
                          ),
                        );
                        if (result == true) {
                          // Обновляем состояние после изменения прогресса
                          setState(() {});
                          widget.onUpdate();
                        }
                      },
                    ),
                    PullDownMenuItem(
                      onTap: () {
                        // Удаляем операцию
                        _deleteOperation();
                      },
                      title: 'Delete',
                      isDestructive: true,
                    ),
                  ],
                  buttonBuilder: (context, showMenu) => CupertinoButton(
                    onPressed: showMenu,
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      Icons.more_vert,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Цель обучения
            Text(
              widget.operation.objective,
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.secondary),
            ),
            const SizedBox(height: 8),
            // Прогресс-бар
            LinearProgressIndicator(
              minHeight: 7,
              value: progress,
              backgroundColor: Colors.grey[300],
              color: AppTheme.primary,
            ),
            const SizedBox(height: 8),
            // Описание задачи
            Text(
              widget.operation.description,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondary),
            ),
            const SizedBox(height: 16),
            const Divider(
              height: 1,
              color: AppTheme.surface2,
            ),
            const SizedBox(height: 8),
            // Топик
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/Vector (6).svg',
                  height: 12,
                ),
                Text(
                  ' ${widget.operation.topic}',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.onPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteOperation() {
    // Удаляем операцию из Hive
    widget.operation.delete();
    // Обновляем список на главной странице
    widget.onUpdate();
  }
}
