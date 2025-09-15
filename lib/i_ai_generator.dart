import 'package:jin_ai_generator/qianfan_ai_generator.dart';
import 'package:jin_ai_generator/openai_ai_generator.dart';

import 'bailian_ai_generator.dart';
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
    bool jsonResponse = false,
  });

  void close();

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

  factory AiGenerator.createBigModelWith({
    required String apiKey,
    required String model,
  }) => BigModelAIGenerator(apiKey: apiKey, model: model);

  factory AiGenerator.createBailianWith_qwen_plus({required String apiKey}) =>
      AiGenerator.createBailianWith(
        apiKey: apiKey,
        model: BailianAIGenerator.MODEL_qwen_plus,
      );

  factory AiGenerator.createBailianWith({
    required String model,
    required String apiKey,
  }) => BailianAIGenerator(apiKey: apiKey, model: model);

  static var isDebug = false;

  factory AiGenerator.createQianfanWith({
    required String apiKey,
    required String model,
  }) => QianfanAIGenerator(apiKey: apiKey, model: model);

  factory AiGenerator.createQianfanWith_ernie_3_5_8k({
    required String apiKey,
  }) => QianfanAIGenerator(
    apiKey: apiKey,
    model: QianfanAIGenerator.MODEL_ernie_3_5_8k,
  );

  factory AiGenerator.createOpenAIWith({
    required String apiKey,
    required String model,
  }) => OpenAIAIGenerator(apiKey: apiKey, model: model);

  factory AiGenerator.createOpenAIWith_gpt_3_5_turbo({
    required String apiKey,
  }) => OpenAIAIGenerator(
    apiKey: apiKey,
    model: OpenAIAIGenerator.MODEL_gpt_3_5_turbo,
  );

  factory AiGenerator.createOpenAIWith_gpt_4({
    required String apiKey,
  }) => OpenAIAIGenerator(
    apiKey: apiKey,
    model: OpenAIAIGenerator.MODEL_gpt_4,
  );
}