import 'package:flutter/material.dart';
import 'package:text_to_speech/globals.dart';
import 'package:text_to_speech/views/tts_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Alder Automations',
        theme: ThemeData(fontFamily: 'Lovelo', canvasColor: brandWhite),
        initialRoute: '/',
        routes: {
          '/': (context) => const TextToSpeechView(),
        });
  }
}
