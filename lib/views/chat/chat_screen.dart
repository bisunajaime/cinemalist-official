import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/chat/chat_cubit.dart';
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/generic/shimmer_gradient_text.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/actor_info_page.dart';
import 'package:cinemalist/views/movie_page.dart';
import 'package:cinemalist/views/tvshow_page.dart';
import 'package:cinemalist/models/generic_actor_model.dart';

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
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _chatCubit = ActiveChatCubit(listCubit: context.read<ChatListCubit>());
    _chatCubit.loadConversation(widget.conversation);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    // Don't close _chatCubit — let streaming finish in background
    // It will save the conversation via ChatListCubit when done
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final content = text ?? _controller.text.trim();
    if (content.isEmpty) return;
    _controller.clear();
    _chatCubit.sendMessage(content);
    _scrollToBottom();
  }

  void _navigateToDetail(BuildContext context, ChatSubject subject) {
    switch (subject.type) {
      case ChatSubjectType.movie:
        Navigator.push(context, AppRoutes.slideUp(MoviePage(
          model: GenericMoviesModel(
            id: subject.id,
            title: subject.title,
            posterPath: subject.posterPath,
            overview: subject.overview,
            voteAverage: subject.rating,
            genreIds: [],
          ),
          tag: 'chat${subject.posterPath}',
        )));
        break;
      case ChatSubjectType.tvShow:
        Navigator.push(context, AppRoutes.slideUp(TvShowPage(
          model: TVShowModel(
            id: subject.id,
            name: subject.title,
            originalName: subject.title,
            posterPath: subject.posterPath,
            overview: subject.overview,
            voteAverage: subject.rating,
            firstAirDate: null,
            popularity: null,
            voteCount: null,
            genreIds: [],
          ),
        )));
        break;
      case ChatSubjectType.actor:
        Navigator.push(context, AppRoutes.slideUp(ActorInfoPage(
          id: subject.id,
          name: subject.title,
          model: GenericActorModel(subject.id, subject.title, subject.posterPath),
        )));
        break;
      case ChatSubjectType.general:
        break;
    }
  }

  bool _scrollPending = false;

  void _scrollToBottom() {
    if (_scrollPending) return;
    _scrollPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollPending = false;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.conversation.subject;
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: GestureDetector(
            onTap: subject.type != ChatSubjectType.general ? () => _navigateToDetail(context, subject) : null,
            child: Row(
            children: [
              if (subject.posterPath != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w200${subject.posterPath}',
                      width: 34, height: 34, fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (subject.posterPath != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mBold.copyWith(fontSize: 15),
                    ),
                    Text(
                      subject.type == ChatSubjectType.movie ? 'Movie' : subject.type == ChatSubjectType.tvShow ? 'TV Show' : subject.type == ChatSubjectType.actor ? 'Actor' : 'General Chat',
                      style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (subject.type != ChatSubjectType.general) ...[
                const SizedBox(width: 4),
                Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.textMuted),
              ],
            ],
          )),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ActiveChatCubit, ActiveChatState>(
                listener: (context, state) {
                  if (state.isStreaming) _scrollToBottom();
                  if (state.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error!, style: Styles.mReg.copyWith(fontSize: 13)),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    _chatCubit.clearError();
                  }
                },
                builder: (context, state) {
                  final messages = state.conversation?.messages
                      .where((m) => m.role != ChatRole.system)
                      .toList() ?? [];

                  if (messages.isEmpty && !state.isStreaming) {
                    return _WelcomeView(
                      subject: subject,
                      suggestions: state.suggestions,
                      isLoadingSuggestions: state.isLoadingSuggestions,
                      onSuggestionTap: _send,
                    );
                  }

                  final showSuggestions = state.suggestions.isNotEmpty && !state.isStreaming;
                  final itemCount = messages.length + (state.isStreaming ? 1 : 0) + (showSuggestions ? 1 : 0);

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
                    itemCount: itemCount,
                    itemBuilder: (context, i) {
                      if (i < messages.length) {
                        final msg = messages[i];
                        final showAvatar = msg.role == ChatRole.assistant &&
                            (i == 0 || messages[i - 1].role != ChatRole.assistant);
                        return _MessageBubble(message: msg, showAvatar: showAvatar, posterPath: subject.posterPath);
                      }
                      if (state.isStreaming && i == messages.length) {
                        return _StreamingBubble(content: state.streamingContent);
                      }
                      // Inline suggestions after last message
                      return _InlineSuggestions(
                        suggestions: state.suggestions,
                        onTap: _send,
                      );
                    },
                  );
                },
              ),
            ),
            // Input
            BlocBuilder<ActiveChatCubit, ActiveChatState>(
              builder: (context, state) => _ChatInput(
                controller: _controller,
                focusNode: _focusNode,
                onSend: () => _send(),
                isStreaming: state.isStreaming,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  final ChatSubject subject;
  final List<String> suggestions;
  final bool isLoadingSuggestions;
  final Function(String) onSuggestionTap;

  const _WelcomeView({required this.subject, required this.suggestions, this.isLoadingSuggestions = false, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            subject.posterPath != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFF3949AB).withValues(alpha: 0.3), blurRadius: 20)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w300${subject.posterPath}',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutCubic, duration: 600.ms)
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: const Color(0xFF3949AB).withValues(alpha: 0.3), blurRadius: 20)],
                    ),
                    child: ShimmerGradient(
                      colors: const [Colors.white, Color(0xFFCE93D8), Colors.white],
                      child: const Icon(Icons.auto_awesome_rounded, size: 36),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut, duration: 800.ms),
            const SizedBox(height: 20),
            Text(
              'Ask about ${subject.title}',
              textAlign: TextAlign.center,
              style: Styles.heading.copyWith(fontSize: 22, color: AppColors.primaryLight),
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 8),
            Text(
              'AI knows the details — ask anything!',
              textAlign: TextAlign.center,
              style: Styles.mReg.copyWith(fontSize: 13, color: AppColors.textMuted),
            ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            if (isLoadingSuggestions)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight)),
                  const SizedBox(width: 10),
                  Text('Generating questions...', style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textMuted)),
                ],
              ).animate().fadeIn(duration: 300.ms),
            if (suggestions.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: suggestions.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => onSuggestionTap(entry.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.primaryLight),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(entry.value, style: Styles.mMed.copyWith(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: (400 + 80 * entry.key).ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final String? posterPath;

  const _MessageBubble({required this.message, this.showAvatar = false, this.posterPath});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    return Padding(
      padding: EdgeInsets.only(bottom: 6, left: isUser ? 40 : 0, right: isUser ? 0 : 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser && showAvatar)
            Container(
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
              ),
              padding: const EdgeInsets.all(6),
              child: ShimmerGradient(
                colors: const [Colors.white, Color(0xFFCE93D8), Colors.white],
                child: const Icon(Icons.auto_awesome_rounded, size: 12),
              ),
            )
          else if (!isUser)
            const SizedBox(width: 32),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: _cleanContent(message.content)));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isUser ? AppColors.primary : Colors.black).withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isUser
                        ? SelectableText(
                            _cleanContent(message.content),
                            style: Styles.mReg.copyWith(
                              fontSize: 14,
                              height: 1.55,
                              color: Colors.white,
                            ),
                          )
                        : MarkdownBody(
                            data: _cleanContent(message.content),
                            selectable: true,
                            shrinkWrap: true,
                            styleSheet: _mdStyle(context),
                          ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: Styles.mReg.copyWith(
                        fontSize: 9,
                        color: isUser ? Colors.white54 : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cleanContent(String content) {
    final lines = content.split('\n');
    lines.removeWhere((l) => l.trim().startsWith('SUGGESTIONS:'));
    return lines.join('\n').trim();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _StreamingBubble extends StatelessWidget {
  final String content;
  const _StreamingBubble({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8, bottom: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
            ),
            padding: const EdgeInsets.all(6),
            child: ShimmerGradient(
              colors: const [Colors.white, Color(0xFFCE93D8), Colors.white],
              child: const Icon(Icons.auto_awesome_rounded, size: 12),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: content.isEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TypingIndicator(),
                        const SizedBox(width: 10),
                        Text('Thinking...', style: Styles.mReg.copyWith(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    )
                  : MarkdownBody(
                      data: _cleanContent(content),
                      shrinkWrap: true,
                      styleSheet: _mdStyle(context),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _cleanContent(String content) {
    final lines = content.split('\n');
    lines.removeWhere((l) => l.trim().startsWith('SUGGESTIONS:'));
    return lines.join('\n').trim();
  }
}

class _InlineSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onTap;

  const _InlineSuggestions({required this.suggestions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 4, bottom: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: suggestions.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => onTap(entry.value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.reply_rounded, size: 12, color: AppColors.primaryLight),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      entry.value,
                      style: Styles.mMed.copyWith(fontSize: 12, color: AppColors.primaryLight),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (80 * entry.key).ms).fadeIn(duration: 250.ms).slideY(begin: 0.1, end: 0);
        }).toList(),
      ),
    );
  }
}

MarkdownStyleSheet _mdStyle(BuildContext context) {
  final baseText = Styles.mReg.copyWith(fontSize: 14, height: 1.55, color: AppColors.textPrimary);
  return MarkdownStyleSheet(
    p: baseText,
    h1: Styles.mBold.copyWith(fontSize: 22, color: AppColors.primaryLight),
    h2: Styles.mBold.copyWith(fontSize: 18, color: AppColors.primaryLight),
    h3: Styles.mBold.copyWith(fontSize: 16, color: AppColors.primaryLight),
    strong: Styles.mBold.copyWith(fontSize: 14, color: AppColors.textPrimary),
    em: baseText.copyWith(fontStyle: FontStyle.italic),
    listBullet: baseText,
    code: Styles.mReg.copyWith(
      fontSize: 13,
      color: AppColors.primaryLight,
      backgroundColor: AppColors.cardLight,
    ),
    codeblockDecoration: BoxDecoration(
      color: AppColors.cardLight,
      borderRadius: BorderRadius.circular(8),
    ),
    codeblockPadding: const EdgeInsets.all(12),
    blockquoteDecoration: BoxDecoration(
      border: Border(left: BorderSide(color: AppColors.primaryLight, width: 3)),
    ),
    blockquotePadding: const EdgeInsets.only(left: 12),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.cardLight, width: 1)),
    ),
  );
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
        ).animate(
          onComplete: (c) => c.repeat(),
          delay: (i * 200).ms,
        ).fadeIn(duration: 400.ms).then().fadeOut(duration: 400.ms);
      }),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isStreaming;

  const _ChatInput({required this.controller, required this.focusNode, required this.onSend, required this.isStreaming});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, 10, 14, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: !isStreaming,
                onSubmitted: (_) => onSend(),
                textInputAction: TextInputAction.send,
                style: Styles.mReg.copyWith(fontSize: 15),
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: isStreaming ? 'AI is responding...' : 'Ask something...',
                  hintStyle: Styles.mReg.copyWith(color: AppColors.textMuted, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: isStreaming ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isStreaming
                    ? null
                    : const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
                color: isStreaming ? AppColors.cardLight : null,
                shape: BoxShape.circle,
                boxShadow: isStreaming ? [] : [
                  BoxShadow(color: const Color(0xFF3949AB).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3)),
                ],
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
