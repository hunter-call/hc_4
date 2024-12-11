import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/main_view/add_new_opperation_page.dart';
import 'package:hc_4/styles/app_theme.dart';
import 'package:hc_4/timer_view/time_provider/time_provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Operation? _selectedOperation; // Выбранная операция (задача)

  void _selectTask() async {
    final operation = await showModalBottomSheet<Operation>(
      context: context,
      builder: (BuildContext context) {
        return _buildTaskSelectionSheet();
      },
    );

    if (operation != null) {
      setState(() {
        _selectedOperation = operation;
      });
    }
  }

  Widget _buildTaskSelectionSheet() {
    final operationBox = Hive.box<Operation>('operations');
    final operations = operationBox.values.toList();

    if (operations.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: AppTheme.background),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No tasks available',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddNewOperationPage()),
                );
              },
              child: const Text('Create a new task'),
            ),
          ],
        ),
      );
    }

    return Container(
      height: double.infinity / 2,
      decoration: const BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            'Tasks',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.onPrimary),
          )),
          ListView.builder(
            shrinkWrap: true,
            itemCount: operations.length,
            itemBuilder: (context, index) {
              final operation = operations[index];
              return ListTile(
                trailing: Icon(
                  Icons.add,
                  color: AppTheme.primary,
                ),
                title: Text(
                  operation.subject,
                  style: AppTheme.displayMedium.copyWith(
                      color: const Color.fromARGB(239, 223, 222, 228)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      operation.description,
                      style: AppTheme.bodyLarge.copyWith(
                          color: const Color.fromARGB(176, 223, 222, 228)),
                    ),
                    Divider(
                      color: AppTheme.surface,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, operation);
                },
              );
            },
          ),
          Expanded(child: SizedBox()),
          CupertinoButton(
            borderRadius: BorderRadius.circular(100),
            color: AppTheme.surface,
            child: Text(
              'Close',
              style: AppTheme.bodyLarge
                  .copyWith(color: const Color.fromARGB(255, 100, 99, 116)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _selectDuration() async {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    if (timerProvider.isRunning) {
      // Не позволяем менять продолжительность во время работы таймера
      return;
    }

    Duration? pickedDuration = await showModalBottomSheet<Duration>(
      context: context,
      builder: (BuildContext context) {
        Duration tempDuration = timerProvider.totalTime;

        return Container(
          height: 250,
          color: AppTheme.surface,
          child: Column(
            children: [
              SizedBox(
                height: 190,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: tempDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    tempDuration = newDuration;
                  },
                ),
              ),
              CupertinoButton(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(tempDuration);
                },
              )
            ],
          ),
        );
      },
    );

    if (pickedDuration != null) {
      timerProvider.setTotalTime(pickedDuration);
    }
  }

  void _startTimer() {
    if (_selectedOperation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a task')),
      );
      return;
    }

    // Запускаем таймер через провайдер
    Provider.of<TimerProvider>(context, listen: false).startTimer();
  }

  void _pauseTimer() {
    Provider.of<TimerProvider>(context, listen: false).pauseTimer();
  }

  void _resumeTimer() {
    Provider.of<TimerProvider>(context, listen: false).resumeTimer();
  }

  void _stopTimer() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Stop timer?'),
          content: const Text('Are you sure you want to stop the timer?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог без действий
              },
            ),
            CupertinoDialogAction(
              child: const Text('Stop'),
              onPressed: () {
                Provider.of<TimerProvider>(context, listen: false).stopTimer();
                Navigator.of(context).pop(); // Закрыть диалог
              },
              isDestructiveAction:
                  true, // Указывает на потенциально нежелательное действие
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String taskText = _selectedOperation != null
        ? _selectedOperation!.subject
        : 'Please select a task...';

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
            'assets/images/boliviainteligente-BqQikUnYbWE-unsplash 1.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.secondary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // Не останавливаем таймер при выходе
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Consumer<TimerProvider>(
          builder: (context, timerProvider, child) {
            String timeText;
            if (timerProvider.isRunning) {
              timeText =
                  '${timerProvider.remainingTime.inMinutes.toString().padLeft(2, '0')}:${(timerProvider.remainingTime.inSeconds % 60).toString().padLeft(2, '0')}';
            } else {
              timeText =
                  '${timerProvider.totalTime.inMinutes.toString().padLeft(2, '0')}:${(timerProvider.totalTime.inSeconds % 60).toString().padLeft(2, '0')}';
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _selectTask,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      taskText,
                      style: AppTheme.displayMedium.copyWith(
                          color: const Color.fromARGB(186, 223, 222, 228)),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: TimerPainter(
                        progress: timerProvider.progress,
                        backgroundColor: AppTheme.secondary.withOpacity(0.2),
                        progressColor: AppTheme.onPrimary,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap:
                              timerProvider.isRunning ? null : _selectDuration,
                          child: Text(
                            timeText,
                            style: AppTheme.displayLarge
                                .copyWith(color: AppTheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildControlButtons(timerProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButtons(TimerProvider timerProvider) {
    if (!timerProvider.isRunning) {
      return SizedBox(
        width: 300,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(100),
          child: const Text(
            'Start focusing',
            style: AppTheme.bodyLarge,
          ),
          onPressed: _startTimer,
          color: AppTheme.primary,
        ),
      );
    } else if (timerProvider.isRunning && !timerProvider.isPaused) {
      return Container(
        width: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red, // Цвет границы
            width: 1.0, // Толщина границы
          ),
          borderRadius:
              BorderRadius.circular(100), // Закругление углов, если нужно
        ),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Настройка отступов
          child: Text('Pause',
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.onPrimary)),
          onPressed: _pauseTimer,
        ),
      );
    } else if (timerProvider.isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            borderRadius: BorderRadius.circular(100),
            child: const Text(
              'Continue',
              style: AppTheme.bodyLarge,
            ),
            onPressed: _resumeTimer,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 16),
          Container(
            width: 170,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red, // Цвет границы
                width: 1.0, // Толщина границы
              ),
              borderRadius:
                  BorderRadius.circular(100), // Закругление углов, если нужно
            ),
            child: CupertinoButton(
              child: Text(
                'Stop',
                style: AppTheme.bodyLarge.copyWith(color: AppTheme.onPrimary),
              ),
              onPressed: _stopTimer,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  TimerPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 6.0;
    double radius = (size.width / 2) - (strokeWidth / 2);

    Offset center = Offset(size.width / 2, size.height / 2);

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Рисуем фоновую окружность
    canvas.drawCircle(center, radius, backgroundPaint);

    // Рисуем прогресс
    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, progressPaint);

    // Рисуем движущийся шарик
    double dotAngle = startAngle + sweepAngle;
    double dotX = center.dx + radius * cos(dotAngle);
    double dotY = center.dy + radius * sin(dotAngle);

    Paint dotPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), strokeWidth / 1, dotPaint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
