import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/repository/localstorage_repository/localstorage_repository.dart';

class ChatApiRepository {
  final http.Client _client;
  static const _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  ChatApiRepository({http.Client? client}) : _client = client ?? http.Client();

  Stream<String> streamCompletion({
    required String apiKey,
    required String model,
    required List<ChatMessage> messages,
  }) async* {
    final request = http.Request('POST', Uri.parse(_baseUrl));
    request.headers.addAll({
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://cinemalist.app',
      'X-Title': 'Cinemalist',
    });
    request.body = jsonEncode({
      'model': model,
      'messages': messages.map((m) => m.toApiMessage()).toList(),
      'stream': true,
    });

    final response = await _client.send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw Exception('OpenRouter API error ${response.statusCode}: $body');
    }

    await for (final chunk in response.stream.transform(utf8.decoder)) {
      final lines = chunk.split('\n').where((l) => l.startsWith('data: '));
      for (final line in lines) {
        final data = line.substring(6).trim();
        if (data == '[DONE]') return;
        try {
          final json = jsonDecode(data);
          final delta = json['choices']?[0]?['delta']?['content'];
          if (delta != null && delta is String) {
            yield delta;
          }
        } catch (_) {}
      }
    }
  }
}

class ChatStorageRepository {
  final LocalStorageRepository _storage;

  ChatStorageRepository()
      : _storage = FileLocalStorageRepository('chat_conversations.json');

  Future<List<Conversation>> loadAll() async {
    final data = await _storage.retrieve();
    if (data == null) return [];
    try {
      final list = jsonDecode(data) as List;
      return list.map((e) => Conversation.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAll(List<Conversation> conversations) async {
    final json = jsonEncode(conversations.map((c) => c.toJson()).toList());
    await _storage.save(json);
  }
}

class ChatSettingsRepository {
  final LocalStorageRepository _storage;

  ChatSettingsRepository()
      : _storage = FileLocalStorageRepository('chat_settings.json');

  Future<Map<String, String>> load() async {
    final data = await _storage.retrieve();
    if (data == null) return {};
    try {
      return Map<String, String>.from(jsonDecode(data));
    } catch (_) {
      return {};
    }
  }

  Future<void> save(Map<String, String> settings) async {
    await _storage.save(jsonEncode(settings));
  }

  Future<String?> getApiKey() async {
    final settings = await load();
    return settings['openrouter_api_key'];
  }

  Future<void> setApiKey(String key) async {
    final settings = await load();
    settings['openrouter_api_key'] = key;
    await save(settings);
  }

  Future<String> getModel() async {
    final settings = await load();
    return settings['model'] ?? 'deepseek/deepseek-chat';
  }

  Future<void> setModel(String model) async {
    final settings = await load();
    settings['model'] = model;
    await save(settings);
  }
}
