import 'package:flutter/material.dart';
import 'package:stove_test_project/ui/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentGeometry.xy(0, 0),
              children: [
                Image.asset('assets/images/boca_ativa.jpg'),
                Text("Fogaréu", style: TextStyle(color: Colors.white, fontSize: 40),),
              ],
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    StoveAppColor.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/autimatic_screem');
                },
                child: Text(
                  "Modo Automático",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    StoveAppColor.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/manual_screem');
                },
                child: Text(
                  "Modo Manual",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
