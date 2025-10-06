import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stove_test_project/app/view_model/fogareu_view_model.dart';
import 'package:stove_test_project/app/view_model/timer_view_model.dart';
import 'package:stove_test_project/ui/styles/colors.dart';

class AutimaticScreem extends StatefulWidget {
  const AutimaticScreem({super.key});

  @override
  State<AutimaticScreem> createState() => _AutimaticScreemState();
}

class _AutimaticScreemState extends State<AutimaticScreem> {
  final FogareuViewModel _fogareuViewModel = FogareuViewModel();
  final ValueNotifier<double> temperatura = ValueNotifier<double>(50);
  final TimerViewModel _timerViewModel = TimerViewModel();
  Duration timerDuration = Duration.zero;
  Timer? monitorTemperatura;

  @override
  void dispose() {
    super.dispose();
    _timerViewModel.stopTime();
    _fogareuViewModel.desligarFogareu();
    monitorTemperatura?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text("Modo Automático"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentGeometry.xy(0, 0),
            children: [
              Image.asset('assets/images/boca_ativa.jpg'),
              Text(
                "Fogaréu",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ],
          ),
          SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: temperatura,
            builder: (context, value, child) {
              return Text(
                "Temperatura atual: ${temperatura.value.toInt()}°C",
                style: TextStyle(color: Colors.white, fontSize: 18),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("50°C", style: TextStyle(color: Colors.white)),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: temperatura,
                  builder: (context, value, child) {
                    return Slider(
                      min: 50,
                      max: 300,
                      value: temperatura.value,
                      onChanged: (double value) {
                        temperatura.value = value;
                        if (_timerViewModel.isPlaying) {
                          Timer(Duration(seconds: 1), () {
                            _fogareuViewModel.alterarTemperatura(
                              temperatura.value.toInt(),
                            );
                          });
                        }
                      },
                      activeColor: StoveAppColor.primaryColor,
                    );
                  },
                ),
              ),
              Text("300°C", style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  final formKey = GlobalKey<FormState>();
                  int tempoEmMinutos = 0;
                  int tempoEmSegundos = 0;

                  return AlertDialog(
                    title: const Text("Defina o tempo do timer"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: "0",
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Minutos",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Digite um valor";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Digite um número válido";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  tempoEmMinutos = int.parse(value!);
                                },
                              ),
                              TextFormField(
                                initialValue: "0",
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Segundos",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Digite um valor";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Digite um número válido";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  tempoEmSegundos = int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            setState(() {
                              timerDuration =
                                  Duration(minutes: tempoEmMinutos) +
                                  Duration(seconds: tempoEmSegundos);
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AnimatedBuilder(
                  animation: _timerViewModel,
                  builder: (context, child) {
                    return Text(
                      !_timerViewModel.isPlaying
                          ? "${timerDuration.inMinutes.toString().padLeft(2, '0')} : ${(timerDuration.inSeconds % 60).toString().padLeft(2, '0')}"
                          : "${_timerViewModel.duration.inMinutes.toString().padLeft(2, '0')} : ${(_timerViewModel.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: StoveAppColor.primaryColor,
                        fontSize: 48,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 48,
            width: 300,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  StoveAppColor.primaryColor,
                ),
              ),
              onPressed: () {
                if (_timerViewModel.isPlaying) {
                  _timerViewModel.stopTime();
                  _fogareuViewModel.desligarFogareu();
                  monitorTemperatura?.cancel();
                } else {
                  if (timerDuration != Duration.zero) {
                    _timerViewModel.startTimer(timerDuration);
                    timerDuration = Duration.zero;
                    _fogareuViewModel.ligarFogareu(temperatura.value.toInt());
                    monitorTemperatura = Timer.periodic(Duration(seconds: 7), (
                      timer,
                    ) {
                      _fogareuViewModel.alterarTemperatura(
                        temperatura.value.toInt(),
                      );
                    });
                  }
                }
              },
              child: ListenableBuilder(
                listenable: _timerViewModel,
                builder: (context, child) {
                  if (_timerViewModel.isPlaying == false) {
                    _fogareuViewModel.desligarFogareu();
                  }
                  return Text(
                    _timerViewModel.isPlaying ? "Desligar" : "Ligar",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
