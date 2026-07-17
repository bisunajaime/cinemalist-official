import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/bloc/chat/chat_cubit.dart';
import 'package:cinemalist/models/chat/chat_models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/chat/chat_screen.dart';

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
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.18,
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
                      Text('AI CHAT', style: Styles.mBold.copyWith(color: AppColors.primaryLight, fontSize: 10, letterSpacing: 2)),
                      Text('Conversations', style: Styles.heading.copyWith(fontSize: 28)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: BlocBuilder<ChatListCubit, ChatState>(
        builder: (context, state) {
          if (state.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                    child: Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textMuted, size: 56),
                  ),
                  const SizedBox(height: 20),
                  Text('No conversations yet', style: Styles.heading.copyWith(fontSize: 22, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Text(
                    'Open any movie, TV show, or actor\nand tap "Ask AI" to start chatting.',
                    textAlign: TextAlign.center,
                    style: Styles.mReg.copyWith(fontSize: 14, color: AppColors.textMuted, height: 1.5),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: state.conversations.length,
            itemBuilder: (context, i) {
              final convo = state.conversations[i];
              return _ConversationTile(convo: convo)
                  .animate(delay: (40 * i).ms).fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0);
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ConversationTile extends StatelessWidget {
  final Conversation convo;
  const _ConversationTile({required this.convo});

  @override
  Widget build(BuildContext context) {
    final typeIcon = convo.subject.type == ChatSubjectType.movie
        ? Icons.movie_rounded
        : convo.subject.type == ChatSubjectType.tvShow
            ? Icons.tv_rounded
            : Icons.person_rounded;

    return Dismissible(
      key: Key(convo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 28),
      ),
      onDismissed: (_) => context.read<ChatListCubit>().deleteConversation(convo.id),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, AppRoutes.slideUp(ChatScreen(conversation: convo)));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 50,
                  height: 50,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(typeIcon, size: 12, color: AppColors.primaryLight),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            convo.subject.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.mBold.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      convo.lastMessagePreview ?? 'New conversation',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(convo.updatedAt),
                    style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${convo.messages.where((m) => m.role != ChatRole.system).length} msgs',
                    style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
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
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat.MMMd().format(dt);
  }
}
