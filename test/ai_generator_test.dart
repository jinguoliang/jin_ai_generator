// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
@Timeout(Duration(seconds: 160))
import 'package:jin_ai_generator/bailian_ai_generator.dart';
import 'package:jin_ai_generator/big_model_ai_generator.dart';
import 'package:jin_ai_generator/i_ai_generator.dart';
import 'package:test/test.dart';

void main() {
  callAiGenerator(AiGenerator aiGenerator) async {
    final result = await aiGenerator.generate(
      "说出一些显化语句，每个语句都要包含主谓宾",
      systemPrompt: "你是一个魔法师",
      maxTokens: 1024,
      withThinking: false,
      jsonResponse: false,
    );
    print(result);
  }

  test('BigModel generate message', () async {
    await callAiGenerator(
      AiGenerator.createBigModelWith(
        apiKey: "your_api_key",
        model: BigModelAIGenerator.MODEL_glm_z1_flash,
      ),
    );
  });

  /// 阿里的千问模型如果response_format为json_object，但是在提示词里没有 json，就会生成出错，有点不合理呀
  test('Bailian generate message', () async {
    await callAiGenerator(
      AiGenerator.createBailianWith(
        apiKey: "your_api_key",
        model: BailianAIGenerator.MODEL_qwen_plus,
      ),
    );
  });

  test('Qianfan generate message', () async {
    await callAiGenerator(
      AiGenerator.createQianfanWith(apiKey: "your_api_key", model: 'qwen3-32b'),
    );
  });

  test('OpenAI implement Generator And generate message', () async {
    await callAiGenerator(
      AiGenerator.createOpenAIWith(
        apiKey: "your_api_key",
        model: BailianAIGenerator.MODEL_qwen_plus,
        baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
      ),
    );
  });
}
