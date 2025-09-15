// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:jin_ai_generator/bailian_ai_generator.dart';
import 'package:jin_ai_generator/big_model_ai_generator.dart';
import 'package:jin_ai_generator/i_ai_generator.dart';
import 'package:test/test.dart';

@Timeout(Duration(seconds: 60))
void main() {
  callAiGenerator(AiGenerator aiGenerator) async {
    final result = await aiGenerator.generate(
      "帮我分解一下任务：实现一个调用大模型的Flutter库",
      systemPrompt: "你是一个魔法师",
      maxTokens: 1024,
      withThinking: false,
    );
    print(result);
  }

  test('BigModel generate message', () async {
    await callAiGenerator(
      AiGenerator.createBigModelWith(
        apiKey: "b51bad368f1c47aabbb43d7476606fef.wt4vz5dKEOeSu7Bz",
        model: BigModelAIGenerator.MODEL_glm_z1_flash,
      ),
    );
  });

  /// 阿里的千问模型如果response_format为json_object，但是在提示词里没有 json，就会生成出错，有点不合理呀
  test('Bailian generate message', () async {
    await callAiGenerator(
      AiGenerator.createBailianWith(
        apiKey: "sk-754c8583280b443288d9ad5b3c96adb1",
        model: BailianAIGenerator.MODEL_qwen_plus,
      ),
    );
  });

  test('Qianfan generate message', () async {
    await callAiGenerator(
      AiGenerator.createQianfanWith(
        apiKey: "bce-v3/ALTAK-yVT4xO2VeXFa31XIyBmr7/1a7458111666e2700f7e79b4531789ab7b4ab003",
        model: 'ernie-3.5-8k',
      ),
    );
  });
}
