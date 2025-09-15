import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jin_ai_generator/i_ai_generator.dart';

class BigModelAIGenerator implements AiGenerator {
  static const String MODEL_glm_4_5_air = "GLM-4.5-Air";
  static const String MODEL_glm_4_5_flash = "GLM-4.5-Flash";
  static const String MODEL_glm_z1_flash = "glm-z1-flash";

  final http.Client _httpClient = http.Client();

  BigModelAIGenerator({
    required String apiKey,
    String model = MODEL_glm_4_5_air,
  }) : _apiKey = apiKey,
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
    if (withThinking) {
      return _generateWithThinking(prompt, systemPrompt, maxTokens);
    }
    return _generateNoThinking(prompt, systemPrompt, maxTokens);
  }

  @override
  void close() {
    _httpClient.close();
  }

  Future<String> _generateNoThinking(
    String prompt,
    String systemPrompt,
    int maxTokens,
  ) async {
    try {
      final url = Uri.parse(
        'https://open.bigmodel.cn/api/anthropic/v1/messages',
      );
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };
      final body = {
        'model': _model,
        'max_tokens': maxTokens,
        'messages': [
          // {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
      };

      final response = await _httpClient.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['content'][0]['text'].trim();
      } else {
        throw Exception(
          'Failed to generate text: ${response.statusCode} -- ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> _generateWithThinking(
    String prompt,
    String systemPrompt,
    int maxTokens,
  ) async {
    try {
      final url = Uri.parse(
        'https://open.bigmodel.cn/api/paas/v4/chat/completions',
      );
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };
      final body = {
        'model': _model,
        'max_tokens': maxTokens,
        'thinking': 0,
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
}
