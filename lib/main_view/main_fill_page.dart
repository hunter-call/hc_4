import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/main_view/add_new_opperation_page.dart';
import 'package:hc_4/styles/app_theme.dart';
import 'package:hc_4/widgets/learning_objective_card.dart';
import 'package:hc_4/widgets/operation_card.dart';

class MainFillPage extends StatefulWidget {
  const MainFillPage({super.key});

  @override
  State<MainFillPage> createState() => _MainFillPageState();
}

class _MainFillPageState extends State<MainFillPage> {
  final _controller = EasyInfiniteDateTimelineController();
  DateTime _selectedDate = DateTime.now();
  final DateTime _firstDate = DateTime(2020);
  final DateTime _lastDate = DateTime(2030, 12, 31);

  List<Operation> _operations = [];

  @override
  void initState() {
    super.initState();
    _loadOperations();
  }

  void _loadOperations() {
    final operationBox = Hive.box<Operation>('operations');
    setState(() {
      _operations = operationBox.values.toList();
    });
  }

  List<Operation> _getOperationsForSelectedDate() {
    return _operations.where((operation) {
      return operation.date.year == _selectedDate.year &&
          operation.date.month == _selectedDate.month &&
          operation.date.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Operation> operationsForSelectedDate = _getOperationsForSelectedDate();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Верхняя часть с заголовком и кнопкой добавления
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Learning',
                    style: AppTheme.displayMedium
                        .copyWith(color: AppTheme.secondary),
                  ),
                  ClipOval(
                    child: CupertinoButton(
                      padding:
                          EdgeInsets.zero, // Убирает отступы для точной формы
                      color: AppTheme.primary,
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddNewOperationPage(),
                          ),
                        );
                        if (result == true) {
                          _loadOperations();
                        }
                      },
                      child: const SizedBox(
                        width: 50, // Задайте ширину и высоту для круглой формы
                        height: 50,
                        child: Center(
                          child: Text('+'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Таймлайн с датами
              EasyInfiniteDateTimeLine(
                showTimelineHeader: false,
                controller: _controller,
                firstDate: _firstDate,
                focusDate: _selectedDate,
                lastDate: _lastDate,
                onDateChange: (selectedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                },
                dayProps: EasyDayProps(
                  borderColor: Colors.transparent,
                  width: 50,
                  height: 60,
                  dayStructure: DayStructure
                      .dayStrDayNum, // Дни недели сверху, числа снизу
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(20)),
                    borderRadius: 20,
                    dayNumStyle: const TextStyle(
                      color: AppTheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    dayStrStyle: const TextStyle(
                      color: AppTheme.onPrimary,
                      fontSize: 12,
                    ),
                  ),
                  inactiveDayStyle: const DayStyle(
                    borderRadius: 20,
                    dayNumStyle: TextStyle(
                      color: AppTheme.onPrimary,
                      fontSize: 16,
                    ),
                    dayStrStyle: TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 12,
                    ),
                  ),
                  disabledDayStyle: const DayStyle(
                    borderRadius: 20,
                    dayNumStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    dayStrStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  todayStyle: const DayStyle(
                    borderRadius: 20,
                    dayNumStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    dayStrStyle: TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LearningObjectiveCard(learningObjects: _operations.length),
              const SizedBox(height: 16),
              // Список операций
              Expanded(
                child: operationsForSelectedDate.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ''' There's no records here''',
                              style: AppTheme.displayMedium
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              ''' Press «+» to add a new learning ''',
                              style: AppTheme.bodyMedium
                                  .copyWith(color: AppTheme.secondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: operationsForSelectedDate.length,
                        itemBuilder: (context, index) {
                          return OperationCard(
                            operation: operationsForSelectedDate[index],
                            onUpdate:
                                _loadOperations, // Передаем колбэк обновления
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
