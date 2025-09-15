import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jin_ai_generator/i_ai_generator.dart';

class BailianAIGenerator implements AiGenerator {
  static const String MODEL_qwen_plus = "qwen-plus";

  final http.Client _httpClient = http.Client();

  BailianAIGenerator({required String apiKey, String model = MODEL_qwen_plus})
      : _apiKey = apiKey,
        _model = model;

  String _apiKey;

  @override
  String get apiKey => _apiKey;

  @override
  set apiKey(String value) {
    _apiKey = value;
  }

  String _model;

  @override
  String get model => _model;

  @override
  set model(String value) {
    _model = value;
  }


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
        'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions',
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
