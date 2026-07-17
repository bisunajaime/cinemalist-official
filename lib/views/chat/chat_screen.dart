import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/chat/chat_cubit.dart';
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;
  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ActiveChatCubit _chatCubit;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatCubit = ActiveChatCubit(listCubit: context.read<ChatListCubit>());
    _chatCubit.loadConversation(widget.conversation);
  }

  @override
  void dispose() {
    _chatCubit.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final content = text ?? _controller.text.trim();
    if (content.isEmpty) return;
    _controller.clear();
    _chatCubit.sendMessage(content);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              if (widget.conversation.subject.posterPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w200${widget.conversation.subject.posterPath}',
                    width: 30, height: 30, fit: BoxFit.cover,
                  ),
                ),
              if (widget.conversation.subject.posterPath != null) const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.conversation.subject.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mBold.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ActiveChatCubit, ActiveChatState>(
                listener: (context, state) {
                  if (state.isStreaming) _scrollToBottom();
                  if (state.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!)),
                    );
                    _chatCubit.clearError();
                  }
                },
                builder: (context, state) {
                  final messages = state.conversation?.messages
                      .where((m) => m.role != ChatRole.system)
                      .toList() ?? [];

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    itemCount: messages.length + (state.isStreaming ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == messages.length && state.isStreaming) {
                        return _StreamingBubble(content: state.streamingContent);
                      }
                      return _MessageBubble(message: messages[i]);
                    },
                  );
                },
              ),
            ),
            BlocBuilder<ActiveChatCubit, ActiveChatState>(
              builder: (context, state) {
                if (state.suggestions.isNotEmpty && !state.isStreaming) {
                  return SizedBox(
                    height: 44,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: state.suggestions.length,
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () => _send(state.suggestions[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              state.suggestions[i],
                              style: Styles.mMed.copyWith(fontSize: 12, color: AppColors.primaryLight),
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
                }
                return const SizedBox.shrink();
              },
            ),
            _ChatInput(
              controller: _controller,
              onSend: () => _send(),
              isStreaming: _chatCubit.state.isStreaming,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          _cleanContent(message.content),
          style: Styles.mReg.copyWith(
            fontSize: 14,
            height: 1.5,
            color: isUser ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _cleanContent(String content) {
    final lines = content.split('\n');
    lines.removeWhere((l) => l.trim().startsWith('SUGGESTIONS:'));
    return lines.join('\n').trim();
  }
}

class _StreamingBubble extends StatelessWidget {
  final String content;
  const _StreamingBubble({required this.content});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: content.isEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight),
                  ),
                  const SizedBox(width: 8),
                  Text('Thinking...', style: Styles.mReg.copyWith(fontSize: 13, color: AppColors.textMuted)),
                ],
              )
            : Text(
                _cleanContent(content),
                style: Styles.mReg.copyWith(fontSize: 14, height: 1.5),
              ),
      ),
    );
  }

  String _cleanContent(String content) {
    final lines = content.split('\n');
    lines.removeWhere((l) => l.trim().startsWith('SUGGESTIONS:'));
    return lines.join('\n').trim();
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isStreaming;

  const _ChatInput({required this.controller, required this.onSend, required this.isStreaming});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isStreaming,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              style: Styles.mReg.copyWith(fontSize: 15),
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: isStreaming ? 'AI is responding...' : 'Ask about this...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isStreaming ? null : onSend,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isStreaming ? AppColors.cardLight : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: isStreaming ? AppColors.textMuted : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
