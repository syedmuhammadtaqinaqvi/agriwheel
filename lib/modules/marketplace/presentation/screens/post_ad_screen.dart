import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/listings/data/seller_listings_repository.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({super.key});

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  String _category = 'Tractor';
  final _price = TextEditingController(text: '3,450,000');
  String _lacBadge = '34.5 Lac';
  bool _publishing = false;

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  void _updateLacBadge(String raw) {
    final numeric = int.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    setState(() {
      if (numeric >= 10000000) {
        _lacBadge = '${(numeric / 10000000).toStringAsFixed(2)} Crore';
      } else if (numeric >= 100000) {
        _lacBadge = '${(numeric / 100000).toStringAsFixed(1)} Lac';
      } else {
        _lacBadge = '$numeric PKR';
      }
    });
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      final price = num.tryParse(_price.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      const repo = SellerListingsRepository();
      await repo.insertListing({
        'title': '$_category listing',
        'category': _category,
        'price': price,
        'city': 'Lahore',
        'description': 'Posted from AgriWheel app',
        'image_urls': <String>[],
      });
      if (!mounted) return;
      setState(() => _publishing = false);
      context.push(RouteNames.sellerMyAds);
    } catch (e) {
      if (!mounted) return;
      setState(() => _publishing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgriPrimaryAppBar(
        showBack: true,
        onBack: () => context.pop(),
        trailingTitle: 'Post Ad',
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Machine Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.brand)),
                Chip(label: const Text('STEP 1 OF 2'), backgroundColor: AppColors.brand, labelStyle: const TextStyle(color: Colors.white, fontSize: 11)),
              ],
            ),
            Text('Provide accurate specs to connect with verified buyers.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Machinery Photos', style: Theme.of(context).textTheme.labelLarge),
                const Text('1 / 15 Photos', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _PhotoThumb(
                  url:
                      'https://lh3.googleusercontent.com/aida/ALJJyrDnBGzSAYbJCS41oMJWOw6bHl5xz8AqICVN9d_ue6OIFJtZn5BBVPvPTUgqjEkocyom8bM846lan2ZCvSy7Yig87aLnXNxowI66_HkrfkOd9jEXfIW7vQSH9WLE91-NwGSoSULFr-0auygvF57d_nVr325EtpGBhqR88QRfgfsUMaUGcHuR-WOBFJE9buno5J_upXzs2kKzIMTCq4WlUEgNYgfKOBR53tRqmDcEeTZQ',
                ),
                _AddPhotoTile(),
                const _SlotTile(),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Category', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Tractor', 'Harvester', 'Trolley', 'Implement'].map((c) {
                return ChoiceChip(
                  label: Text(c),
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                  selectedColor: AppColors.secondaryContainer,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: 'millat-mf',
              decoration: const InputDecoration(labelText: 'Brand / Make'),
              items: const [
                DropdownMenuItem(value: 'millat-mf', child: Text('Millat Tractors / Massey Ferguson')),
                DropdownMenuItem(value: 'al-ghazi', child: Text('Al-Ghazi / New Holland')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: TextFormField(initialValue: '2022', decoration: const InputDecoration(labelText: 'Model Year'))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(initialValue: '450 hrs', decoration: const InputDecoration(labelText: 'Operating Hours'))),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price (PKR)', style: Theme.of(context).textTheme.labelLarge),
                Chip(label: Text(_lacBadge), backgroundColor: AppColors.secondaryContainer),
              ],
            ),
            TextFormField(
              controller: _price,
              onChanged: _updateLacBadge,
              decoration: const InputDecoration(prefixText: 'Rs '),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              initialValue: 'Faisalabad, Punjab',
              decoration: const InputDecoration(labelText: 'Location / City', prefixIcon: Icon(Icons.location_on)),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              maxLines: 4,
              initialValue: 'First owner, personal farm use in Faisalabad, 100% genuine condition, biometric available on spot.',
              decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.fieldHeight,
              child: ElevatedButton.icon(
                onPressed: _publishing ? null : _publish,
                icon: Icon(_publishing ? Icons.hourglass_top : Icons.rocket_launch),
                label: Text(_publishing ? 'Publishing...' : 'Publish Ad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryContainer,
                  foregroundColor: AppColors.brand,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('100% Free Listing • Direct WhatsApp and Phone Inquiries', style: TextStyle(fontSize: 12))),
          ],
        ),
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: AgriNetworkImage(imageUrl: url)),
        const Positioned(top: 4, left: 4, child: Chip(label: Text('COVER', style: TextStyle(fontSize: 9)), padding: EdgeInsets.zero)),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo), Text('Add More', style: TextStyle(fontSize: 11))]),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceLow.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image), Text('Slot 3', style: TextStyle(fontSize: 10))]),
    );
  }
}
