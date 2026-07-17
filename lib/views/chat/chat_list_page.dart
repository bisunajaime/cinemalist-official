import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/bloc/chat/chat_cubit.dart';
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/generic/shimmer_gradient_text.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/chat/chat_screen.dart';
import 'package:cinemalist/views/chat/chat_settings_page.dart';
import 'package:cinemalist/widgets/chat/start_chat_button.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage();
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.18,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded, size: 22),
                color: AppColors.textMuted,
                onPressed: () => Navigator.push(context, AppRoutes.slideUp(const ChatSettingsPage())),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              collapseMode: CollapseMode.parallax,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShimmerGradient(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome_rounded, size: 11),
                            const SizedBox(width: 4),
                            Text('AI CHAT', style: Styles.mBold.copyWith(fontSize: 10, letterSpacing: 2)),
                          ],
                        ),
                      ),
                      Text('Conversations', style: Styles.heading.copyWith(fontSize: 28)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'new-chat',
          backgroundColor: const Color(0xFF3949AB),
          onPressed: () => _startGeneralChat(context),
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
        body: BlocBuilder<ChatListCubit, ChatState>(
        builder: (context, state) {
          if (state.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: const Color(0xFF3949AB).withValues(alpha: 0.3), blurRadius: 20)],
                    ),
                    child: ShimmerGradient(
                      colors: const [Colors.white, Color(0xFFCE93D8), Colors.white],
                      child: const Icon(Icons.auto_awesome_rounded, size: 44),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut, duration: 800.ms),
                  const SizedBox(height: 24),
                  Text('No conversations yet', style: Styles.heading.copyWith(fontSize: 22, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Open any movie, TV show, or actor and tap the sparkle icon to start chatting with AI.',
                      textAlign: TextAlign.center,
                      style: Styles.mReg.copyWith(fontSize: 14, color: AppColors.textMuted, height: 1.5),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: state.conversations.length,
            itemBuilder: (context, i) {
              final convo = state.conversations[i];
              return _ConversationTile(convo: convo)
                  .animate(delay: (40 * i).ms).fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
            },
          );
        },
      ),
      ),
    );
  }

  void _startGeneralChat(BuildContext context) async {
    final listCubit = context.read<ChatListCubit>();
    final emptyGeneral = listCubit.state.conversations
        .where((c) => c.subject.type == ChatSubjectType.general && c.messages.isEmpty)
        .toList();
    if (emptyGeneral.isNotEmpty) {
      if (context.mounted) {
        Navigator.push(context, AppRoutes.slideUp(ChatScreen(conversation: emptyGeneral.first)));
      }
      return;
    }
    final subject = ChatSubject(
      id: DateTime.now().microsecondsSinceEpoch,
      title: 'Movie Chat',
      type: ChatSubjectType.general,
    );
    final convo = await listCubit.createConversation(subject);
    if (context.mounted) {
      Navigator.push(context, AppRoutes.slideUp(ChatScreen(conversation: convo)));
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _ConversationTile extends StatelessWidget {
  final Conversation convo;
  const _ConversationTile({required this.convo});

  @override
  Widget build(BuildContext context) {
    final typeLabel = convo.subject.type == ChatSubjectType.movie
        ? 'Movie'
        : convo.subject.type == ChatSubjectType.tvShow
            ? 'TV Show'
            : convo.subject.type == ChatSubjectType.actor
                ? 'Actor'
                : 'General';
    final typeIcon = convo.subject.type == ChatSubjectType.movie
        ? Icons.movie_rounded
        : convo.subject.type == ChatSubjectType.tvShow
            ? Icons.tv_rounded
            : convo.subject.type == ChatSubjectType.actor
                ? Icons.person_rounded
                : Icons.auto_awesome_rounded;
    final msgCount = convo.messages.where((m) => m.role != ChatRole.system).length;

    return Dismissible(
      key: Key(convo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 24),
            const SizedBox(height: 2),
            Text('Delete', style: Styles.mMed.copyWith(fontSize: 10, color: AppColors.error)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('Delete conversation?', style: Styles.mBold),
            content: Text(
              'This will permanently remove your chat about "${convo.subject.title}".',
              style: Styles.mReg.copyWith(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: Styles.mBold.copyWith(color: AppColors.error)),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => context.read<ChatListCubit>().deleteConversation(convo.id),
      child: GestureDetector(
        onTap: () => Navigator.push(context, AppRoutes.slideUp(ChatScreen(conversation: convo))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardLight.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              // Poster with type badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: convo.subject.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w200${convo.subject.posterPath}',
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppColors.cardLight,
                              child: Icon(typeIcon, color: AppColors.textMuted, size: 24),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: ShimmerGradient(
                      colors: const [Color(0xFF7986CB), Color(0xFFCE93D8), Color(0xFF7986CB)],
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        child: const Icon(Icons.auto_awesome_rounded, size: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      convo.subject.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mBold.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      convo.lastMessagePreview ?? 'New conversation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(typeLabel, style: Styles.mBold.copyWith(fontSize: 9, color: AppColors.primaryLight)),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chat_bubble_outline_rounded, size: 10, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text('$msgCount', style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted)),
                        const Spacer(),
                        Text(_formatTime(convo.updatedAt), style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
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
