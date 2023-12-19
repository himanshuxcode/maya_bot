import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/openai_service.dart';

class OpenAiServiceProvider extends ChangeNotifier {
  final OpenAiService _openAiService = OpenAiService();

  OpenAiService get openAiService => _openAiService;

  Future<String> isArtPromptApi(String prompt) async {
    try {
      final result = await _openAiService.isArtPromptApi(prompt);
      notifyListeners();
      return result;
    } catch (e) {
      print('Error in isArtPromptApi: $e');
      return 'An error occurred';
    }
  }

}
