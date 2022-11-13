import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tts.dart';

class TextToSpeechView extends StatelessWidget {
  const TextToSpeechView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 35.0, 0, 0),
                child: Text('Instructions:'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: '''
                    \n1. Enter desired text to speech in text box below
                    \n2. Enter file name to download as, the date and time will be added to filename
                    \n3. To add any pauses for more natural sounding speach, use the black 'Add Pause' buttons
                    ''',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0))),
                    const TextSpan(
                      text: '''
                    \nPauses can be customized, just change the number inside the < > to desired length (200ms recommended)
                    \nClick 'Try Example' to insert an example snipet for a demonstration
                    \nFor more advance customization, use SSML encoding. For more information visit:
                    ''',
                      style: TextStyle(
                          fontFamily: 'roboto',
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    TextSpan(
                        text:
                            '\nhttps://cloud.google.com/text-to-speech/docs/ssml',
                        style: const TextStyle(
                            fontFamily: 'roboto',
                            decoration: TextDecoration.underline,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (() {
                            launch(
                                'https://cloud.google.com/text-to-speech/docs/ssml');
                          })),
                  ]),
                ),
              ),
              const TextToSpeech()
            ],
          ),
        ));
  }
}
