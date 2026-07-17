import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/collections/collections_cubit.dart';
import 'package:cinemalist/models/collections/collection_models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

Future<void> showCollectionPicker(BuildContext context, CollectionItem item) async {
  HapticFeedback.lightImpact();
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _CollectionPickerSheet(item: item, parentContext: context),
  );
}

class _CollectionPickerSheet extends StatefulWidget {
  final CollectionItem item;
  final BuildContext parentContext;

  const _CollectionPickerSheet({required this.item, required this.parentContext});

  @override
  State<_CollectionPickerSheet> createState() => _CollectionPickerSheetState();
}

class _CollectionPickerSheetState extends State<_CollectionPickerSheet> {
  late Set<String> _selectedIds;
  final _newNameController = TextEditingController();
  bool _showNewField = false;

  @override
  void initState() {
    super.initState();
    final cubit = widget.parentContext.read<CollectionsCubit>();
    _selectedIds = cubit.state
        .collectionsContaining(widget.item.id, widget.item.type)
        .map((c) => c.id)
        .toSet();
  }

  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = widget.parentContext.read<CollectionsCubit>();
    final collections = cubit.state.collections;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
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
                Icon(Icons.bookmark_add_rounded, size: 20, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Save to collection', style: Styles.mBold.copyWith(fontSize: 16)),
                ),
                Text(widget.item.title, style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: collections.length,
              itemBuilder: (_, i) {
                final c = collections[i];
                final selected = _selectedIds.contains(c.id);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selected) {
                      _selectedIds.remove(c.id);
                    } else {
                      _selectedIds.add(c.id);
                    }
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary.withValues(alpha: 0.4) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: selected ? AppColors.primaryLight : AppColors.textMuted,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: Styles.mBold.copyWith(fontSize: 14)),
                              Text(
                                '${c.totalCount} items${c.isDefault ? ' · Default' : ''}',
                                style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        if (c.isDefault)
                          Icon(Icons.bookmark_rounded, size: 16, color: AppColors.primaryLight),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // New collection
          if (_showNewField)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newNameController,
                      autofocus: true,
                      style: Styles.mReg.copyWith(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Collection name',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onSubmitted: (_) => _createNew(cubit),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _createNew(cubit),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => setState(() => _showNewField = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, size: 18, color: AppColors.primaryLight),
                      const SizedBox(width: 6),
                      Text('New collection', style: Styles.mMed.copyWith(fontSize: 13, color: AppColors.primaryLight)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Save button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _save(cubit),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Done', style: Styles.mBold.copyWith(fontSize: 14)),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }

  void _createNew(CollectionsCubit cubit) {
    final name = _newNameController.text.trim();
    if (name.isEmpty) return;
    cubit.createCollection(name);
    _newNameController.clear();
    setState(() {
      _showNewField = false;
      // Select the newly created collection
      final newCollection = cubit.state.collections.last;
      _selectedIds.add(newCollection.id);
    });
  }

  void _save(CollectionsCubit cubit) {
    final current = cubit.state.collectionsContaining(widget.item.id, widget.item.type).map((c) => c.id).toSet();

    // Add to newly selected
    for (final id in _selectedIds) {
      if (!current.contains(id)) {
        cubit.addItemToCollection(id, widget.item);
      }
    }
    // Remove from deselected
    for (final id in current) {
      if (!_selectedIds.contains(id)) {
        cubit.removeItemFromCollection(id, widget.item.id, widget.item.type);
      }
    }

    Navigator.pop(context);
  }
}
