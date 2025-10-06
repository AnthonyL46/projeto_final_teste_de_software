import 'package:flutter/material.dart';
import 'package:stove_test_project/app/view_model/fogareu_view_model.dart';
import 'package:stove_test_project/ui/styles/colors.dart';
import 'dart:async';

class ManualScreem extends StatefulWidget {
  const ManualScreem({super.key});

  @override
  State<ManualScreem> createState() => _ManualScreemState();
}

class _ManualScreemState extends State<ManualScreem> {
  final FogareuViewModel _fogareuViewModel = FogareuViewModel();
  final ValueNotifier<double> temperatura = ValueNotifier<double>(50);
  final ValueNotifier<String> buttonText = ValueNotifier<String>("Ligar");
  bool isEnable = false;
  Timer? monitorTemperatura;

  @override
  void dispose() {
    super.dispose();
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
        title: Text("Modo Manual"),
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
                        if (isEnable) {
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
                if (isEnable) {
                  _fogareuViewModel.desligarFogareu();
                  monitorTemperatura?.cancel();
                  buttonText.value = "Ligar";
                } else {
                  buttonText.value = "Desligar";
                  _fogareuViewModel.ligarFogareu(temperatura.value.toInt());
                  monitorTemperatura = Timer.periodic(Duration(seconds: 7), (
                    timer,
                  ) {
                    _fogareuViewModel.alterarTemperatura(
                      temperatura.value.toInt(),
                    );
                  });
                }
                isEnable = !isEnable;
              },
              child: ValueListenableBuilder(
                valueListenable: buttonText,
                builder: (context, value, child) {
                  return Text(
                    buttonText.value,
                    style: TextStyle(color: Colors.white, fontSize: 24),
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
