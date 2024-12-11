import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  Duration _remainingTime = const Duration(minutes: 25);
  Duration _totalTime = const Duration(minutes: 25); // Убрали final
  bool _isRunning = false;
  bool _isPaused = false;
  double _progress = 0.0;

  Duration get remainingTime => _remainingTime;
  Duration get totalTime => _totalTime; // Добавили getter для totalTime
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  double get progress => _progress;

  void setTotalTime(Duration duration) {
    if (!_isRunning) {
      _totalTime = duration;
      _remainingTime = duration;
      _progress = 0.0; // Сбрасываем прогресс
      notifyListeners();
    }
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _isPaused = false;
    _progress = 0.0;
    _remainingTime = _totalTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (_remainingTime.inSeconds > 0) {
        _remainingTime = _remainingTime - const Duration(seconds: 1);
        _progress = (_totalTime.inSeconds - _remainingTime.inSeconds) /
            _totalTime.inSeconds;
        notifyListeners();
      } else {
        // Таймер завершен
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
        // Здесь можно добавить уведомление или алерт
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    notifyListeners();
  }

  void resumeTimer() {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    notifyListeners();
  }

  void stopTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _remainingTime = _totalTime;
    _progress = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
