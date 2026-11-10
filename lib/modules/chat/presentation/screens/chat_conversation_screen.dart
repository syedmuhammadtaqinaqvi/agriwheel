import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../domain/chat_thread_model.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({super.key, required this.thread});

  final ChatThread thread;

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final _input = TextEditingController();
  final _messages = <_Msg>[
    const _Msg(incoming: true, text: 'Assalam-o-Alaikum bhai! Millat MF 385 (2021) is fully genuine at our Multan showroom.'),
    const _Msg(incoming: false, text: 'Walaikum Assalam. Total meter hours kitne hain? Tyres condition?'),
    const _Msg(incoming: true, text: 'Genuine 680 working hours. Single-hand farm use only.'),
    const _Msg(incoming: false, text: 'Biometric on spot? Mechanic hydraulic test kal la sakta hun?'),
    const _Msg(incoming: true, text: '100% biometric spot par. Documents complete — mechanic field test welcome.'),
  ];

  void _send([String? preset]) {
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(incoming: false, text: text));
      _input.clear();
    });
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgriPrimaryAppBar(
        showBack: true,
        onBack: () => context.pop(),
        trailingTitle: 'Chat Conversation',
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin, vertical: AppSpacing.sm),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.white, child: Text(widget.thread.initials)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.thread.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      const Text('Online • Verified Dealer', style: TextStyle(color: AppColors.accent, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AgriNetworkImage(
                      imageUrl: widget.thread.thumbUrl ?? MachineryListingThumb.mf385,
                      width: 56,
                      height: 56,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Millat MF 385 (85 HP)', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('PKR 3,450,000', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.brand)),
                        Text('Multan Cantt • 2021 • 4WD', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  OutlinedButton(onPressed: () {}, child: const Text('View Ad')),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _Bubble(msg: _messages[i]),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
              children: [
                ActionChip(label: const Text('Send Location'), onPressed: () => _send('Can you share exact showroom pin location?')),
                ActionChip(label: const Text('Final Cash Offer?'), onPressed: () => _send('What is the final cash offer price?')),
                ActionChip(label: const Text('Cold Start Video'), onPressed: () => _send('Can you send a short cold start engine video?')),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(hintText: 'Type your message...', isDense: true),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _send(),
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  const _Msg({required this.incoming, required this.text});
  final bool incoming;
  final String text;
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final align = msg.incoming ? Alignment.centerLeft : Alignment.centerRight;
    final bg = msg.incoming ? AppColors.surfaceLow : AppColors.brand;
    final fg = msg.incoming ? AppColors.brand : Colors.white;
    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.incoming ? 4 : 16),
            bottomRight: Radius.circular(msg.incoming ? 16 : 4),
          ),
        ),
        child: Text(msg.text, style: TextStyle(color: fg, height: 1.4)),
      ),
    );
  }
}

abstract final class MachineryListingThumb {
  static const mf385 =
      'https://lh3.googleusercontent.com/aida/ALJJyrDnBGzSAYbJCS41oMJWOw6bHl5xz8AqICVN9d_ue6OIFJtZn5BBVPvPTUgqjEkocyom8bM846lan2ZCvSy7Yig87aLnXNxowI66_HkrfkOd9jEXfIW7vQSH9WLE91-NwGSoSULFr-0auygvF57d_nVr325EtpGBhqR88QRfgfsUMaUGcHuR-WOBFJE9buno5J_upXzs2kKzIMTCq4WlUEgNYgfKOBR53tRqmDcEeTZQ';
}
