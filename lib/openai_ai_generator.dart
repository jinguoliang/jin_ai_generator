import 'package:jin_ai_generator/i_ai_generator.dart';
import 'package:openai_dart/openai_dart.dart';

class OpenAIAIGenerator implements AiGenerator {
  late OpenAIClient _openAiClient;
  String _model;
  String _apiKey;

  OpenAIAIGenerator({
    required String baseUrl,
    required String apiKey,
    required String model,
  }) : _model = model,
       _apiKey = apiKey,
       _openAiClient = OpenAIClient(baseUrl: baseUrl);

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

  @override
  Future<String> generate(
    String prompt, {
    String systemPrompt = '',
    int maxTokens = 1024,
    bool withThinking = true,
    bool jsonResponse = false,
  }) async {
    try {
      _openAiClient.apiKey = _apiKey;
      final res = await _openAiClient.createChatCompletion(
        request: CreateChatCompletionRequest(
          maxTokens: maxTokens,

          model: ChatCompletionModel.modelId(_model),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(prompt),
            ),
          ],
        ),
      );

      return res.choices.first.message.content ?? '';
    } catch (e) {
      throw Exception('OpenAI API error: $e');
    }
  }

  @override
  void close() {
    _openAiClient.endSession();
  }
}
