import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:hive/hive.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/styles/app_theme.dart';
import 'package:hc_4/widgets/operation_card.dart';

class SubjectOperationsPage extends StatefulWidget {
  final String subject;

  const SubjectOperationsPage({Key? key, required this.subject})
      : super(key: key);

  @override
  _SubjectOperationsPageState createState() => _SubjectOperationsPageState();
}

class _SubjectOperationsPageState extends State<SubjectOperationsPage> {
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
      // Фильтруем операции по предмету
      _operations = operationBox.values
          .where((operation) => operation.subject == widget.subject)
          .toList();
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme.secondary),
        backgroundColor: AppTheme.background,
        title: Text(
          widget.subject,
          style: AppTheme.displayMedium.copyWith(color: AppTheme.secondary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
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
                  dayStructure: DayStructure.dayStrDayNum,
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
              // Список операций
              Expanded(
                child: operationsForSelectedDate.isEmpty
                    ? Center(
                        child: Text(
                          'No operations for selected date',
                          style:
                              AppTheme.bodyLarge.copyWith(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: operationsForSelectedDate.length,
                        itemBuilder: (context, index) {
                          return OperationCard(
                            operation: operationsForSelectedDate[index],
                            onUpdate: _loadOperations,
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
