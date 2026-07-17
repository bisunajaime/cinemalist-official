import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/bloc/chat/chat_cubit.dart';
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/generic/shimmer_gradient_text.dart';
import 'package:cinemalist/views/chat/chat_screen.dart';

Future<void> startMovieChat(BuildContext context, GenericMoviesModel movie) async {
  final subject = ChatSubject(
    id: movie.id!,
    title: movie.title ?? '',
    type: ChatSubjectType.movie,
    posterPath: movie.posterPath,
    overview: movie.overview,
    rating: movie.voteAverage,
  );
  await _showChatPicker(context, subject);
}

Future<void> startTvShowChat(BuildContext context, TVShowModel show) async {
  final subject = ChatSubject(
    id: show.id!,
    title: show.name ?? '',
    type: ChatSubjectType.tvShow,
    posterPath: show.posterPath,
    overview: show.overview,
    rating: show.voteAverage,
  );
  await _showChatPicker(context, subject);
}

Future<void> startActorChat(BuildContext context, String name, int id, String? profilePath) async {
  final subject = ChatSubject(
    id: id,
    title: name,
    type: ChatSubjectType.actor,
    posterPath: profilePath,
  );
  await _showChatPicker(context, subject);
}

Future<void> _showChatPicker(BuildContext context, ChatSubject subject) async {
  final listCubit = context.read<ChatListCubit>();
  final existing = listCubit.state.conversations
      .where((c) => c.subject.id == subject.id && c.subject.type == subject.type)
      .toList();

  if (existing.isEmpty) {
    final convo = await listCubit.createConversation(subject);
    if (context.mounted) {
      Navigator.push(context, AppRoutes.slideUp(ChatScreen(conversation: convo)));
    }
    return;
  }

  if (!context.mounted) return;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _ChatPickerSheet(
      subject: subject,
      existing: existing,
      parentContext: context,
    ),
  );
}

class _ChatPickerSheet extends StatelessWidget {
  final ChatSubject subject;
  final List<Conversation> existing;
  final BuildContext parentContext;

  const _ChatPickerSheet({required this.subject, required this.existing, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ShimmerGradient(
                  child: const Icon(Icons.auto_awesome_rounded, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Chats about ${subject.title}',
                    style: Styles.mBold.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // New chat button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final listCubit = parentContext.read<ChatListCubit>();
                final convo = await listCubit.createConversation(subject);
                if (parentContext.mounted) {
                  Navigator.push(parentContext, AppRoutes.slideUp(ChatScreen(conversation: convo)));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text('Start new conversation', style: Styles.mBold.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Existing chats
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: existing.length,
              itemBuilder: (_, i) {
                final convo = existing[i];
                final msgCount = convo.messages.where((m) => m.role != ChatRole.system).length;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(parentContext, AppRoutes.slideUp(ChatScreen(conversation: convo)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.cardLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.primaryLight),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                convo.lastMessagePreview ?? 'New conversation',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.mMed.copyWith(fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$msgCount messages · ${_formatTime(convo.updatedAt)}',
                                style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.MMMd().format(dt);
  }
}

class AskAIChip extends StatelessWidget {
  final VoidCallback onTap;
  const AskAIChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3949AB).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ShimmerGradient(
          colors: const [Colors.white, Color(0xFFCE93D8), Colors.white],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 16),
              const SizedBox(width: 6),
              Text('Ask AI', style: Styles.mBold.copyWith(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
