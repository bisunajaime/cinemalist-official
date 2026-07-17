import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  await _startChat(context, subject);
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
  await _startChat(context, subject);
}

Future<void> startActorChat(BuildContext context, String name, int id, String? profilePath) async {
  final subject = ChatSubject(
    id: id,
    title: name,
    type: ChatSubjectType.actor,
    posterPath: profilePath,
  );
  await _startChat(context, subject);
}

Future<void> _startChat(BuildContext context, ChatSubject subject) async {
  final listCubit = context.read<ChatListCubit>();
  final convo = await listCubit.createConversation(subject);
  if (context.mounted) {
    Navigator.push(context, AppRoutes.slideUp(ChatScreen(conversation: convo)));
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
