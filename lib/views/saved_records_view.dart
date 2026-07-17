import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/collections/collections_cubit.dart';
import 'package:cinemalist/models/collections/collection_models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class SavedRecordsPage extends StatelessWidget {
  const SavedRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collections', style: Styles.heading.copyWith(fontSize: 26)),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new-collection',
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: BlocBuilder<CollectionsCubit, CollectionsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.collections.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                    child: Icon(Icons.collections_bookmark_rounded, color: AppColors.textMuted, size: 56),
                  ),
                  const SizedBox(height: 20),
                  Text('No collections', style: Styles.heading.copyWith(fontSize: 22, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Text('Tap + to create one', style: Styles.mReg.copyWith(fontSize: 14, color: AppColors.textMuted)),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            itemCount: state.collections.length,
            itemBuilder: (context, i) {
              final collection = state.collections[i];
              return _CollectionCard(collection: collection)
                  .animate(delay: (40 * i).ms).fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('New Collection', style: Styles.mBold),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: Styles.mReg.copyWith(fontSize: 15),
          decoration: const InputDecoration(hintText: 'e.g. Watch Later, Horror Picks'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              context.read<CollectionsCubit>().createCollection(value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<CollectionsCubit>().createCollection(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Create', style: Styles.mBold.copyWith(color: AppColors.primaryLight)),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final Collection collection;
  const _CollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    final previewItems = collection.allItems.take(4).toList();

    return GestureDetector(
      onTap: () => Navigator.push(context, AppRoutes.slideUp(_CollectionDetailPage(collection: collection))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: collection.isDefault ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview grid
            if (previewItems.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: List.generate(
                      previewItems.length.clamp(0, 4),
                      (i) => Expanded(
                        child: previewItems[i].posterPath != null
                            ? CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w200${previewItems[i].posterPath}',
                                fit: BoxFit.cover,
                                height: 100,
                              )
                            : Container(
                                color: AppColors.cardLight,
                                child: Icon(
                                  _iconForType(previewItems[i].type),
                                  color: AppColors.textMuted,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: AppColors.cardLight,
                  child: Center(
                    child: Icon(Icons.collections_bookmark_rounded, color: AppColors.textMuted.withValues(alpha: 0.3), size: 28),
                  ),
                ),
              ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  if (collection.isDefault)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.bookmark_rounded, size: 18, color: AppColors.primaryLight),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(collection.name, style: Styles.mBold.copyWith(fontSize: 16)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (collection.movies.isNotEmpty)
                              _CountChip(Icons.movie_rounded, collection.movies.length),
                            if (collection.tvShows.isNotEmpty)
                              _CountChip(Icons.tv_rounded, collection.tvShows.length),
                            if (collection.actors.isNotEmpty)
                              _CountChip(Icons.person_rounded, collection.actors.length),
                            if (collection.isEmpty)
                              Text('Empty', style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(CollectionItemType type) {
    switch (type) {
      case CollectionItemType.movie: return Icons.movie_rounded;
      case CollectionItemType.tvShow: return Icons.tv_rounded;
      case CollectionItemType.actor: return Icons.person_rounded;
    }
  }
}

class _CountChip extends StatelessWidget {
  final IconData icon;
  final int count;
  const _CountChip(this.icon, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textMuted),
          const SizedBox(width: 3),
          Text('$count', style: Styles.mMed.copyWith(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// Collection detail page
class _CollectionDetailPage extends StatelessWidget {
  final Collection collection;
  const _CollectionDetailPage({required this.collection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsCubit, CollectionsState>(
      builder: (context, state) {
        final current = state.collections.firstWhere(
          (c) => c.id == collection.id,
          orElse: () => collection,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(current.name, style: Styles.mBold.copyWith(fontSize: 18)),
            actions: [
              if (!current.isDefault)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded),
                  color: AppColors.surface,
                  onSelected: (value) {
                    if (value == 'rename') _showRename(context, current);
                    if (value == 'delete') _showDelete(context, current);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'rename', child: Text('Rename', style: Styles.mReg)),
                    PopupMenuItem(value: 'delete', child: Text('Delete', style: Styles.mReg.copyWith(color: AppColors.error))),
                  ],
                ),
            ],
          ),
          body: current.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_rounded, color: AppColors.textMuted, size: 56),
                      const SizedBox(height: 12),
                      Text('No items yet', style: Styles.mMed.copyWith(color: AppColors.textMuted, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('Save movies, shows, or actors here', style: Styles.mReg.copyWith(color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (current.movies.isNotEmpty) ...[
                      _SectionTitle('MOVIES', current.movies.length),
                      const SizedBox(height: 8),
                      _ItemGrid(items: current.movies, collectionId: current.id),
                      const SizedBox(height: 20),
                    ],
                    if (current.tvShows.isNotEmpty) ...[
                      _SectionTitle('TV SHOWS', current.tvShows.length),
                      const SizedBox(height: 8),
                      _ItemGrid(items: current.tvShows, collectionId: current.id),
                      const SizedBox(height: 20),
                    ],
                    if (current.actors.isNotEmpty) ...[
                      _SectionTitle('ACTORS', current.actors.length),
                      const SizedBox(height: 8),
                      _ActorRow(actors: current.actors, collectionId: current.id),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
        );
      },
    );
  }

  void _showRename(BuildContext context, Collection c) {
    final controller = TextEditingController(text: c.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Rename', style: Styles.mBold),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: Styles.mReg,
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) {
              context.read<CollectionsCubit>().renameCollection(c.id, v.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted))),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<CollectionsCubit>().renameCollection(c.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Save', style: Styles.mBold.copyWith(color: AppColors.primaryLight)),
          ),
        ],
      ),
    );
  }

  void _showDelete(BuildContext context, Collection c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete "${c.name}"?', style: Styles.mBold),
        content: Text('This will remove the collection and all ${c.totalCount} items in it.', style: Styles.mReg.copyWith(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted))),
          TextButton(
            onPressed: () {
              context.read<CollectionsCubit>().deleteCollection(c.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Delete', style: Styles.mBold.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;
  const _SectionTitle(this.title, this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Styles.heading.copyWith(fontSize: 18)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: Text('$count', style: Styles.mBold.copyWith(fontSize: 11, color: AppColors.primaryLight)),
        ),
      ],
    );
  }
}

class _ItemGrid extends StatelessWidget {
  final List<CollectionItem> items;
  final String collectionId;
  const _ItemGrid({required this.items, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onLongPress: () => _confirmRemove(context, item),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                item.posterPath != null
                    ? CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w200${item.posterPath}', fit: BoxFit.cover)
                    : Container(color: AppColors.cardLight, child: Center(child: Icon(Icons.image_not_supported, color: AppColors.textMuted))),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent])),
                    child: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Styles.mBold.copyWith(fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: (30 * i).ms).fadeIn(duration: 200.ms);
      },
    );
  }

  void _confirmRemove(BuildContext context, CollectionItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Remove "${item.title}"?', style: Styles.mBold),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted))),
          TextButton(
            onPressed: () {
              context.read<CollectionsCubit>().removeItemFromCollection(collectionId, item.id, item.type);
              Navigator.pop(context);
            },
            child: Text('Remove', style: Styles.mBold.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ActorRow extends StatelessWidget {
  final List<CollectionItem> actors;
  final String collectionId;
  const _ActorRow({required this.actors, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final actor = actors[i];
          return GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: Text('Remove "${actor.title}"?', style: Styles.mBold),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted))),
                    TextButton(
                      onPressed: () {
                        context.read<CollectionsCubit>().removeItemFromCollection(collectionId, actor.id, actor.type);
                        Navigator.pop(context);
                      },
                      child: Text('Remove', style: Styles.mBold.copyWith(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.card,
                    backgroundImage: actor.posterPath != null ? NetworkImage('https://image.tmdb.org/t/p/w200${actor.posterPath}') : null,
                    child: actor.posterPath == null ? const Icon(Icons.person_rounded, color: AppColors.textMuted) : null,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 64,
                    child: Text(actor.title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: Styles.mMed.copyWith(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ).animate(delay: (40 * i).ms).fadeIn(duration: 200.ms);
        },
      ),
    );
  }
}
