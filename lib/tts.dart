import 'dart:developer';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:text_to_speech/api/tts_api.dart';
import 'package:intl/intl.dart';
import 'package:text_to_speech/globals.dart';
import 'package:text_to_speech/widgets/alert_dialog/alert_dialog.dart';

final now = DateTime.now();
const inputFormTextStyle = TextStyle(color: brandBlack, fontFamily: 'Roboto');
const exampleInput =
    "Here are <say-as interpret-as=\"characters\">SSML</say-as> samples.\nI can pause <break time=\"3s\"/>.\nI can play a sound\n<audio src=\"https://rpg.hamsterrepublic.com/wiki-images/d/db/Crush8-Bit.ogg\">didn't get your MP3 audio file</audio>.\nI can speak in cardinals. Your number is <say-as interpret-as=\"cardinal\">10</say-as>.\nOr I can speak in ordinals. You are <say-as interpret-as=\"ordinal\">10</say-as> in line.\nOr I can even speak in digits. The digits for ten are <say-as interpret-as=\"characters\">10</say-as>.\nI can also substitute phrases, like the <sub alias=\"World Wide Web Consortium\">W3C</sub>.\nFinally, I can speak a paragraph with two sentences.\n<p><s>This is sentence one.</s><s>This is sentence two.</s></p>";

api(text, voiceName, languageCode, fileName, context) {
  TextToSpeechService service = TextToSpeechService();

  Future mp3 = Future(() => service.textToSpeech(
      text: "<speak>" + text + "</speak>",
      voiceName: voiceName,
      audioEncoding: 'MP3',
      languageCode: languageCode));

  mp3.then((file) {
    final blob = html.Blob([file]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download =
          (fileName + DateFormat(' (yyyy-MM-dd-H:m:s)').format(now) + '.mp3');
    html.document.body!.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    showDialog(
        context: context,
        builder: (BuildContext cxt) {
          return const ShowValidAlert(
            validHeader: "Success",
            validBody: "Your mp3 file will download in a moment",
          );
        });

    return file;
  });
  mp3.catchError((error) => showDialog(
      context: context,
      builder: (BuildContext cxt) {
        return const ShowInvalidAlert(
          invalidHeader: "Error",
          invalidBody:
              "There was an error with your request\nplease try again later\nor email us at alex@alderautomations.com",
        );
      }));
}

appendText(String text, TextEditingController txt) {
  var cursorPos = txt.selection.base.offset;

  String suffix = txt.text.substring(cursorPos);
  String append = text;
  String prefix = txt.text.substring(0, cursorPos);

  txt.text = prefix + append + suffix;
}

class TextToSpeech extends StatelessWidget {
  const TextToSpeech({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Center(
        child: TextInput(),
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final _formKey = GlobalKey<FormState>();
  String text = '', _fileName = '';
  TextEditingController txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                minLines: 1,
                maxLines: 25,
                controller: txt,
                style: inputFormTextStyle,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return value;
                  }
                },
                onSaved: (value) {
                  text = value!;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 12),
                  focusColor: brandBlack,
                  counterStyle: TextStyle(
                    color: brandBlack,
                  ),
                  labelText: 'Enter Desired Text',
                  labelStyle:
                      TextStyle(color: brandBlack, fontFamily: 'Lovelo'),
                  fillColor: brandBlack,
                  hoverColor: brandBlack,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: brandBlack),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 5, 12),
                        child: ElevatedButton(
                          //submit button
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(brandBlack)),
                          onPressed: () {
                            appendText("<break time=\"200ms\"/>", txt);
                          },
                          child: const Text(
                            'Add 200 millisecond pause',
                            style: TextStyle(color: brandWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 5, 12),
                        child: ElevatedButton(
                          //submit button
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(brandBlack)),
                          onPressed: () {
                            appendText("<break time=\"1s\"/>", txt);
                          },
                          child: const Text(
                            'Add 1 second pause',
                            style: TextStyle(color: brandWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                style: inputFormTextStyle,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return value;
                  }
                },
                onSaved: (value) {
                  _fileName = value!;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 12),
                  focusColor: brandBlack,
                  counterStyle: TextStyle(
                    color: brandBlack,
                  ),
                  labelText: 'Enter File Name',
                  labelStyle:
                      TextStyle(color: brandBlack, fontFamily: 'Lovelo'),
                  fillColor: brandBlack,
                  hoverColor: brandBlack,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: brandBlack),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 750),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 5, 12),
                        child: ElevatedButton(
                          //submit button
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(brandBlue)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              log('valid inputs - saving and resetting state');
                              text = text.replaceAll('"', '\\"');
                              api(
                                  text,
                                  'en-US-Wavenet-D', //voice
                                  'en-US',
                                  _fileName,
                                  context //language
                                  );
                              _formKey.currentState!.reset();
                            }
                          },
                          child: const Text(
                            'Process',
                            style: TextStyle(color: brandWhite),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 5, 12),
                        child: ElevatedButton(
                          //submit button
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 122, 122, 122))),
                          onPressed: () {
                            txt.text = exampleInput;
                          },
                          child: const Text(
                            'Try Example',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 5, 12),
                        child: ElevatedButton(
                          //submit button
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 228, 57, 57))),
                          onPressed: () {
                            txt.text = '';
                          },
                          child: const Text(
                            'Clear Text',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}


/*
test input
\nHere are <say-as interpret-as=\"characters\">SSML</say-as> samples.\nI can pause <break time=\"3s\"/>.\nI can play a sound\n<audio src=\"https://rpg.hamsterrepublic.com/wiki-images/d/db/Crush8-Bit.ogg\">didn't get your MP3 audio file</audio>.\nI can speak in cardinals. Your number is <say-as interpret-as=\"cardinal\">10</say-as>.\nOr I can speak in ordinals. You are <say-as interpret-as=\"ordinal\">10</say-as> in line.\nOr I can even speak in digits. The digits for ten are <say-as interpret-as=\"characters\">10</say-as>.\nI can also substitute phrases, like the <sub alias="World Wide Web Consortium\">W3C</sub>.\nFinally, I can speak a paragraph with two sentences.\n<p><s>This is sentence one.</s><s>This is sentence two.</s></p>
*/