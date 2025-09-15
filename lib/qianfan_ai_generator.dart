import 'dart:convert';

import 'i_ai_generator.dart';
import 'package:http/http.dart' as http;

class QianfanAIGenerator implements AiGenerator {

  static const String MODEL_ernie_3_5_8k = 'ernie-3.5-8k';

  final http.Client _httpClient = http.Client();

  QianfanAIGenerator({String apiKey = "", String model = ""})
    : _apiKey = apiKey,
      _model = model;

  @override
  String get apiKey => _apiKey;

  @override
  set apiKey(String value) {
    _apiKey = value;
  }

  @override
  String get model => _model;

  @override
  set model(String value) {
    _model = value;
  }

  String _apiKey;

  String _model;


  @override
  Future<String> generate(
      String prompt, {
        String systemPrompt = "",
        int maxTokens = 1024,
        bool withThinking = false,
        bool jsonResponse = false,
      }) async {
    try {
      final url = Uri.parse(
        'https://qianfan.baidubce.com/v2/chat/completions',
      );

      // 添加超时时间
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',

      };
      final body = {
        'model': _model,
        'max_tokens': maxTokens,
        'enable_thinking': false,
        'response_format': jsonResponse ? {'type': 'json_object'} : null,
        'messages': [
          {'role': 'user', 'content': prompt},
          {'role': 'system', 'content': systemPrompt},
        ],
      };

      final response = await _httpClient.post(
        url,
        headers: headers,

        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (AiGenerator.isDebug) {
          print(jsonResponse);
          print("choices length: ${jsonResponse['choices'].length}");
          print("text: ${jsonResponse['choices'][0]['message']['content']}");
          print(
            "reason: ${jsonResponse['choices'][0]['message']['reasoning_content']}",
          );
        }
        return jsonResponse['choices'][0]['message']['content'].trim();
      } else {
        throw Exception(
          'Failed to generate text: ${response.statusCode} -- ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void close() {
    _httpClient.close();
  }


}
