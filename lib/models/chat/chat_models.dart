import 'dart:convert';

enum ChatRole { user, assistant, system }

enum ChatSubjectType { movie, tvShow, actor }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.user(String content) => ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: ChatRole.user,
        content: content,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.assistant(String content) => ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: ChatRole.assistant,
        content: content,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.system(String content) => ChatMessage(
        id: 'system',
        role: ChatRole.system,
        content: content,
        timestamp: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        role: ChatRole.values.firstWhere((e) => e.name == json['role']),
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toApiMessage() => {
        'role': role.name,
        'content': content,
      };
}

class ChatSubject {
  final int id;
  final String title;
  final ChatSubjectType type;
  final String? posterPath;
  final String? overview;
  final double? rating;
  final String? extraContext;

  ChatSubject({
    required this.id,
    required this.title,
    required this.type,
    this.posterPath,
    this.overview,
    this.rating,
    this.extraContext,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'posterPath': posterPath,
        'overview': overview,
        'rating': rating,
        'extraContext': extraContext,
      };

  factory ChatSubject.fromJson(Map<String, dynamic> json) => ChatSubject(
        id: json['id'],
        title: json['title'],
        type: ChatSubjectType.values.firstWhere((e) => e.name == json['type']),
        posterPath: json['posterPath'],
        overview: json['overview'],
        rating: json['rating']?.toDouble(),
        extraContext: json['extraContext'],
      );

  String get systemPrompt {
    final buf = StringBuffer();
    buf.writeln('You are a knowledgeable and friendly movie/TV expert chatbot in the Cinemalist app.');
    buf.writeln('The user wants to discuss: "$title" (${type == ChatSubjectType.movie ? 'Movie' : type == ChatSubjectType.tvShow ? 'TV Show' : 'Actor'}).');
    if (overview != null && overview!.isNotEmpty) buf.writeln('Overview: $overview');
    if (rating != null) buf.writeln('Rating: $rating/10');
    if (extraContext != null && extraContext!.isNotEmpty) buf.writeln('Additional info: $extraContext');
    buf.writeln('Be concise, engaging, and spoiler-aware. If the user asks about spoilers, warn them first.');
    buf.writeln('After each response, suggest 2-3 short follow-up questions the user might want to ask, formatted as a JSON array on the last line prefixed with "SUGGESTIONS:" like: SUGGESTIONS:["Question 1","Question 2","Question 3"]');
    return buf.toString();
  }
}

class Conversation {
  final String id;
  final ChatSubject subject;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.subject,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.create(ChatSubject subject) {
    final now = DateTime.now();
    return Conversation(
      id: now.microsecondsSinceEpoch.toString(),
      subject: subject,
      messages: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  String? get lastMessagePreview {
    final userMessages = messages.where((m) => m.role != ChatRole.system);
    if (userMessages.isEmpty) return null;
    final last = userMessages.last;
    final text = last.content;
    return text.length > 80 ? '${text.substring(0, 80)}...' : text;
  }

  Conversation copyWith({List<ChatMessage>? messages, DateTime? updatedAt}) {
    return Conversation(
      id: id,
      subject: subject,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject.toJson(),
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'],
        subject: ChatSubject.fromJson(json['subject']),
        messages: (json['messages'] as List).map((m) => ChatMessage.fromJson(m)).toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
