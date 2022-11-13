import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:text_to_speech/api/key.dart';

//adapted from https://github.com/LucaDe/text_to_speech_api

const apiUrl = 'https://texttospeech.googleapis.com/v1/';

class AudioResponse {
  final String audioContent;
  AudioResponse(this.audioContent);

  AudioResponse.fromJson(Map<String, dynamic> json)
      : audioContent = json['audioContent'];
}

class TextToSpeechService {
  final String _apiKey;

  TextToSpeechService([this._apiKey = key]);

  _formatAudio(AudioResponse response) {
    return base64.decode(response.audioContent);
    //return FileService.createAndWriteFile('out.mp3', bytes);
  }

  _getApiUrl(String endpoint) {
    return Uri.parse('$apiUrl$endpoint?key=$_apiKey');
  }

  _getResponse(Future<http.Response> request) {
    return request.then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw (jsonDecode(response.body));
    });
  }

  Future availableVoices() async {
    const endpoint = 'voices';
    Future<http.Response> request = http.get(_getApiUrl(endpoint));
    try {
      await _getResponse(request);
    } catch (e) {
      throw 'no data';
    }
  }

  Future textToSpeech(
      {required String text,
      String voiceName = 'en-US-Wavenet-D',
      String audioEncoding = 'MP3',
      String languageCode = 'en-US'}) async {
    const endpoint = 'text:synthesize';
    String body =
        '{"input": {"ssml":"$text"},"voice": {"languageCode": "$languageCode", "name": "$voiceName"},"audioConfig": {"audioEncoding": "$audioEncoding"}}';
    Future<http.Response> request = http.post(_getApiUrl(endpoint), body: body);
    try {
      var response = await _getResponse(request);
      AudioResponse audioResponse = AudioResponse.fromJson(response);
      return _formatAudio(audioResponse);
    } catch (e) {
      rethrow;
    }
  }
}
