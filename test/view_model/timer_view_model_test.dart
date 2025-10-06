import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:stove_test_project/app/view_model/timer_view_model.dart';

void main() {
  group('TimerViewModel', () {
    test('deve iniciar o timer corretamente', () {
      final timerViewModel = TimerViewModel();

      timerViewModel.startTimer(const Duration(seconds: 5));

      expect(timerViewModel.isPlaying, isTrue);
      expect(timerViewModel.duration.inSeconds, 5);
    });

    test('deve decrementar o tempo após 1 segundo', () async {
      final timerViewModel = TimerViewModel();

      timerViewModel.startTimer(const Duration(seconds: 3));

      // Aguarda 1.5s para o timer rodar pelo menos 1 tick
      await Future.delayed(const Duration(milliseconds: 1500));

      expect(timerViewModel.duration.inSeconds, lessThan(3));
      expect(timerViewModel.isPlaying, isTrue);

      timerViewModel.stopTime();
    });

    test('deve parar quando chega a zero', () async {
      final timerViewModel = TimerViewModel();

      timerViewModel.startTimer(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 4));

      expect(timerViewModel.isPlaying, isFalse);
      expect(timerViewModel.duration, Duration.zero);
    });

    test('stopTime() deve cancelar o timer imediatamente', () async {
      final timerViewModel = TimerViewModel();

      timerViewModel.startTimer(const Duration(seconds: 10));
      timerViewModel.stopTime();

      expect(timerViewModel.isPlaying, isFalse);
      expect(timerViewModel.timer?.isActive, isFalse);
    });
  });
}
