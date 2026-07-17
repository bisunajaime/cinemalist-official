import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/repository/chat/chat_repository.dart';

class ChatState {
  final List<Conversation> conversations;
  final bool isLoading;

  const ChatState({this.conversations = const [], this.isLoading = false});

  ChatState copyWith({List<Conversation>? conversations, bool? isLoading}) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatListCubit extends Cubit<ChatState> {
  final ChatStorageRepository _storage;

  ChatListCubit() : _storage = ChatStorageRepository(), super(const ChatState()) {
    loadConversations();
  }

  Future<void> loadConversations() async {
    emit(state.copyWith(isLoading: true));
    final convos = await _storage.loadAll();
    convos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    emit(ChatState(conversations: convos));
  }

  Future<Conversation> createConversation(ChatSubject subject) async {
    final convo = Conversation.create(subject);
    final updated = [convo, ...state.conversations];
    emit(state.copyWith(conversations: updated));
    await _storage.saveAll(updated);
    return convo;
  }

  Future<void> updateConversation(Conversation convo) async {
    final updated = state.conversations.map((c) => c.id == convo.id ? convo : c).toList();
    updated.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    emit(state.copyWith(conversations: updated));
    await _storage.saveAll(updated);
  }

  Future<void> deleteConversation(String id) async {
    final updated = state.conversations.where((c) => c.id != id).toList();
    emit(state.copyWith(conversations: updated));
    await _storage.saveAll(updated);
  }
}

class ActiveChatState {
  final Conversation? conversation;
  final bool isStreaming;
  final String streamingContent;
  final List<String> suggestions;
  final String? error;

  const ActiveChatState({
    this.conversation,
    this.isStreaming = false,
    this.streamingContent = '',
    this.suggestions = const [],
    this.error,
  });

  ActiveChatState copyWith({
    Conversation? conversation,
    bool? isStreaming,
    String? streamingContent,
    List<String>? suggestions,
    String? error,
  }) {
    return ActiveChatState(
      conversation: conversation ?? this.conversation,
      isStreaming: isStreaming ?? this.isStreaming,
      streamingContent: streamingContent ?? this.streamingContent,
      suggestions: suggestions ?? this.suggestions,
      error: error,
    );
  }
}

class ActiveChatCubit extends Cubit<ActiveChatState> {
  final ChatApiRepository _api;
  final ChatListCubit _listCubit;
  final ChatSettingsRepository _settings;

  ActiveChatCubit({
    required ChatListCubit listCubit,
  })  : _api = ChatApiRepository(),
        _listCubit = listCubit,
        _settings = ChatSettingsRepository(),
        super(const ActiveChatState());

  void loadConversation(Conversation convo) {
    final suggestions = _extractSuggestions(convo);
    emit(ActiveChatState(conversation: convo, suggestions: suggestions));
  }

  Future<void> sendMessage(String content) async {
    if (state.conversation == null) return;

    final apiKey = await _settings.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      emit(state.copyWith(error: 'Please set your OpenRouter API key in Settings.'));
      return;
    }

    final model = await _settings.getModel();
    final convo = state.conversation!;

    final userMsg = ChatMessage.user(content);
    final updatedMessages = [...convo.messages, userMsg];
    final updatedConvo = convo.copyWith(messages: updatedMessages, updatedAt: DateTime.now());
    emit(state.copyWith(
      conversation: updatedConvo,
      isStreaming: true,
      streamingContent: '',
      suggestions: [],
      error: null,
    ));

    try {
      final apiMessages = <ChatMessage>[
        ChatMessage.system(convo.subject.systemPrompt),
        ...updatedMessages.where((m) => m.role != ChatRole.system),
      ];

      final buffer = StringBuffer();
      await for (final chunk in _api.streamCompletion(
        apiKey: apiKey,
        model: model,
        messages: apiMessages,
      )) {
        buffer.write(chunk);
        emit(state.copyWith(streamingContent: buffer.toString()));
      }

      final fullResponse = buffer.toString();
      final parsed = _parseResponse(fullResponse);

      final assistantMsg = ChatMessage.assistant(parsed.content);
      final finalMessages = [...updatedMessages, assistantMsg];
      final finalConvo = convo.copyWith(messages: finalMessages, updatedAt: DateTime.now());

      emit(state.copyWith(
        conversation: finalConvo,
        isStreaming: false,
        streamingContent: '',
        suggestions: parsed.suggestions,
      ));

      await _listCubit.updateConversation(finalConvo);
    } catch (e) {
      emit(state.copyWith(
        isStreaming: false,
        streamingContent: '',
        error: e.toString(),
      ));
    }
  }

  void clearError() => emit(state.copyWith(error: null));

  List<String> _extractSuggestions(Conversation convo) {
    if (convo.messages.isEmpty) return _defaultSuggestions(convo.subject);
    final lastAssistant = convo.messages.lastWhere(
      (m) => m.role == ChatRole.assistant,
      orElse: () => ChatMessage.assistant(''),
    );
    if (lastAssistant.content.isEmpty) return _defaultSuggestions(convo.subject);
    return _parseSuggestions(lastAssistant.content);
  }

  List<String> _defaultSuggestions(ChatSubject subject) {
    if (subject.type == ChatSubjectType.actor) {
      return ['What are their best movies?', 'Tell me about their career', 'Any upcoming projects?'];
    }
    return ['Should I watch this?', 'Explain the plot without spoilers', 'What makes it special?'];
  }

  _ParsedResponse _parseResponse(String raw) {
    final lines = raw.split('\n');
    final sugLine = lines.lastWhere(
      (l) => l.trim().startsWith('SUGGESTIONS:'),
      orElse: () => '',
    );

    List<String> suggestions = [];
    String content = raw;

    if (sugLine.isNotEmpty) {
      content = raw.replaceAll(sugLine, '').trim();
      try {
        final jsonStr = sugLine.replaceFirst('SUGGESTIONS:', '').trim();
        suggestions = (jsonDecode(jsonStr) as List).cast<String>();
      } catch (_) {}
    }

    if (suggestions.isEmpty) {
      suggestions = ['Tell me more', 'Any similar recommendations?', 'What else should I know?'];
    }

    return _ParsedResponse(content, suggestions);
  }

  List<String> _parseSuggestions(String content) {
    final lines = content.split('\n');
    final sugLine = lines.lastWhere(
      (l) => l.trim().startsWith('SUGGESTIONS:'),
      orElse: () => '',
    );
    if (sugLine.isEmpty) return [];
    try {
      final jsonStr = sugLine.replaceFirst('SUGGESTIONS:', '').trim();
      return (jsonDecode(jsonStr) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }
}

class _ParsedResponse {
  final String content;
  final List<String> suggestions;
  _ParsedResponse(this.content, this.suggestions);
}
