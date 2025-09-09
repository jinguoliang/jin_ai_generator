import 'aliyun_ai_generator.dart';
import 'big_model_ai_generator.dart';

abstract class AiGenerator {
  set model(String model);

  String get model;

  set apiKey(String apiKey);

  String get apiKey;

  Future<String> generate(
    String prompt, {
    String systemPrompt = "",
    int maxTokens = 1024,
    bool withThinking = true,
  });

  void close();

  factory AiGenerator.createBigModelWith_glm_4_5({required String apiKey}) =>
      BigModelAIGenerator(
        apiKey: apiKey,
        model: BigModelAIGenerator.MODEL_glm_4_5,
      );

  factory AiGenerator.createBigModelWith_glm_4_5_air({
    required String apiKey,
  }) => BigModelAIGenerator(
    apiKey: apiKey,
    model: BigModelAIGenerator.MODEL_glm_4_5_air,
  );

  factory AiGenerator.createBigModelWith_glm_4_5_flash({
    required String apiKey,
  }) => BigModelAIGenerator(
    apiKey: apiKey,
    model: BigModelAIGenerator.MODEL_glm_4_5_flash,
  );

  factory AiGenerator.createAliWith_qwen_plus({
    required String apiKey,
  }) => AliYunAIGenerator(
    apiKey: apiKey,
    model: AliYunAIGenerator.MODEL_qwen_plus,
  );
}
