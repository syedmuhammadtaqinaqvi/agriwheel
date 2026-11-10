import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../domain/chat_thread_model.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  String _tab = 'all';
  bool _unreadOnly = false;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<ChatThread> get _visible {
    var list = ChatThread.demoThreads;
    if (_tab != 'all') list = list.where((t) => t.category == _tab).toList();
    if (_unreadOnly) list = list.where((t) => t.unreadCount > 0).toList();
    final q = _search.text.trim().toLowerCase();
    if (q.isNotEmpty) list = list.where((t) => t.name.toLowerCase().contains(q) || t.machineryTag.toLowerCase().contains(q)).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AgriPrimaryAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search buyers, dealers or machinery...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
              children: [
                _TabPill(label: 'All Chats', count: 12, selected: _tab == 'all' && !_unreadOnly, onTap: () => setState(() { _tab = 'all'; _unreadOnly = false; })),
                _TabPill(label: 'Buying', count: 8, selected: _tab == 'buying', onTap: () => setState(() => _tab = 'buying')),
                _TabPill(label: 'Selling', count: 4, selected: _tab == 'selling', onTap: () => setState(() => _tab = 'selling')),
                _TabPill(label: 'Unread', selected: _unreadOnly, onTap: () => setState(() => _unreadOnly = !_unreadOnly)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.margin, vertical: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
            child: const Row(
              children: [
                Icon(Icons.verified_user, color: AppColors.brand, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('AgriWheel SafePay protects tractor advance token deposits.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          ..._visible.map((t) => _ChatRow(
                thread: t,
                onTap: () => context.push(RouteNames.chatThread, extra: t),
              )),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, this.count, required this.selected, required this.onTap});
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(count != null ? '$label ($count)' : label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.secondaryContainer,
        side: const BorderSide(color: AppColors.brand),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.thread, required this.onTap});
  final ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin, vertical: AppSpacing.md),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.brand, width: 0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(thread.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                if (thread.online)
                  const Positioned(right: 0, bottom: 0, child: CircleAvatar(radius: 6, backgroundColor: AppColors.brand)),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(thread.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onSurface))),
                      Text(thread.timeLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (thread.thumbUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: AgriNetworkImage(imageUrl: thread.thumbUrl!, width: 20, height: 20),
                        ),
                      const SizedBox(width: 6),
                      Text(thread.machineryTag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      Text(thread.priceHint, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: Text(thread.snippet, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if (thread.unreadCount > 0)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.brand,
                          child: Text('${thread.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
