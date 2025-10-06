import 'dart:async';

import 'package:flutter/material.dart';

class TimerViewModel extends ChangeNotifier{
  bool isPlaying = false;
  Timer? timer;
  Duration duration = Duration.zero;

  startTimer(Duration timerInSeconds){
    isPlaying = true;
    duration = timerInSeconds;
    notifyListeners();
    
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration.inSeconds != 0) {
        duration -= Duration(seconds:1);
        notifyListeners();
      } else {
        stopTime();
      }
    },);

  }

  void stopTime() {
    isPlaying = false;
    notifyListeners();
    timer?.cancel();
  }
}