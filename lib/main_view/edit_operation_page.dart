import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/styles/app_theme.dart';
import 'package:hc_4/const/subjects.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EditOperationPage extends StatefulWidget {
  final Operation operation;

  const EditOperationPage({super.key, required this.operation});

  @override
  _EditOperationPageState createState() => _EditOperationPageState();
}

class _EditOperationPageState extends State<EditOperationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _objectiveController;
  late TextEditingController _subjectController;
  late TextEditingController _topicController;
  late TextEditingController _descriptionController;

  DateTime? _selectedDate;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    _objectiveController =
        TextEditingController(text: widget.operation.objective);
    _subjectController = TextEditingController(text: widget.operation.subject);
    _topicController = TextEditingController(text: widget.operation.topic);
    _descriptionController =
        TextEditingController(text: widget.operation.description);
    _selectedDate = widget.operation.date;
    _level = widget.operation.level;
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveOperation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      // Обновляем данные операции
      widget.operation.objective = _objectiveController.text;
      widget.operation.subject = _subjectController.text;
      widget.operation.topic = _topicController.text;
      widget.operation.date = _selectedDate!;
      widget.operation.level = _level;
      widget.operation.description = _descriptionController.text;

      await widget.operation.save();

      Navigator.pop(context, true); // Возвращаемся с результатом true
    }
  }

  Future<void> _pickDate() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: AppTheme.background,
          child: Column(
            children: [
              SizedBox(
                height: 190,
                child: CupertinoTheme(
                  data: CupertinoTheme.of(context).copyWith(
                    textTheme: const CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate ?? DateTime.now(),
                    minimumDate: DateTime(2020),
                    maximumDate: DateTime(2030),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                  ),
                ),
              ),
              CupertinoButton(
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubjectSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Отображение выбранного предмета
          Text(
            'Subject: ${_subjectController.text.isEmpty ? 'Select Subject' : _subjectController.text}',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.secondary),
          ),
          // PullDownButton для выбора предмета
          PullDownButton(
            itemBuilder: (context) => subjects.map((subject) {
              return PullDownMenuItem(
                itemTheme: const PullDownMenuItemTheme(),
                iconWidget: SvgPicture.asset(
                  getSubjectIcon(subject),
                  color: AppTheme.secondary,
                ),
                title: subject,
                onTap: () {
                  _updateSubject(subject);
                },
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: AppTheme.primary,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    List<int> levels = List<int>.generate(5, (index) => index + 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Отображение выбранного уровня
          Text(
            '$_level',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.secondary),
          ),
          // PullDownButton для выбора уровня
          PullDownButton(
            itemBuilder: (context) => levels.map((level) {
              return PullDownMenuItem(
                itemTheme: const PullDownMenuItemTheme(),
                iconWidget: const Icon(
                  Icons.star,
                  color: AppTheme.secondary,
                ),
                title: level.toString(),
                onTap: () {
                  _updateLevel(level);
                },
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: AppTheme.primary,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateSubject(String subject) {
    setState(() {
      _subjectController.text = subject;
    });
  }

  void _updateLevel(int level) {
    setState(() {
      _level = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppTheme.surface,
      hintStyle: const TextStyle(
          color: AppTheme.secondary, fontWeight: FontWeight.w400),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme.secondary),
        backgroundColor: AppTheme.background,
        title: Text(
          'Edit learning',
          style: AppTheme.displayMedium.copyWith(color: AppTheme.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Objective
              TextFormField(
                controller: _objectiveController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration:
                    inputDecoration.copyWith(hintText: 'Learning objective'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter objective';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Subject
              _buildSubjectSelector(),
              const SizedBox(height: 16),
              // Topic
              TextFormField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration:
                    inputDecoration.copyWith(hintText: 'Topic of interest'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date
              GestureDetector(
                onTap: _pickDate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(72, 80, 100, 0.08),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select a date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                            style: _selectedDate == null
                                ? const TextStyle(
                                    color: AppTheme.secondary, fontSize: 16)
                                : const TextStyle(
                                    color: Colors.white, fontSize: 16),
                          ),
                          const Icon(Icons.calendar_month,
                              color: AppTheme.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Level
              _buildLevelSelector(),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: inputDecoration.copyWith(hintText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Save Button
              ElevatedButton(
                onPressed: _saveOperation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
