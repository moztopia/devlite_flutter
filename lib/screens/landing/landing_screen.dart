import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devlite_flutter/everything.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              LocalizationService().translate('debug.screens.landing.title'))),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocalizationService()
                    .translate('debug.screens.landing.content'),
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  context.read<AppStateMachine>().addEvent(AppEvent.goToHome);
                },
                child: Text(LocalizationService()
                    .translate('debug.screens.landing.goToHomeButton')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
