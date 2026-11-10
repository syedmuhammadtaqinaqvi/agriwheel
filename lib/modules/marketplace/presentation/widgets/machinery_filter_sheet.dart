import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';

class MachineryFilterSheet extends StatefulWidget {
  const MachineryFilterSheet({super.key, required this.onApply});

  final ValueChanged<int> onApply;

  static Future<void> show(BuildContext context, {required ValueChanged<int> onApply}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MachineryFilterSheet(onApply: onApply),
    );
  }

  @override
  State<MachineryFilterSheet> createState() => _MachineryFilterSheetState();
}

class _MachineryFilterSheetState extends State<MachineryFilterSheet> {
  final _brands = {'Millat / MF'};
  final _cities = {'Faisalabad'};
  String _year = '2020 - 2024';
  String _condition = 'used';
  final _hp = {'70 - 85 HP'};
  int _resultCount = 42;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.82;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 48),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(width: 48, height: 4, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(8))),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.margin),
              child: Row(
                children: [
                  const Icon(Icons.tune, color: AppColors.brand),
                  const SizedBox(width: 8),
                  Text('Filter Farm Machinery', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.brand)),
                  const Spacer(),
                  TextButton(onPressed: _clearAll, child: const Text('Clear All')),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
                children: [
                  _sectionTitle('Brand / Make', '${_brands.length} Selected'),
                  _chipWrap(
                    ['Millat / MF', 'Al-Ghazi / Fiat', 'New Holland', 'John Deere', 'Kubota', 'Belarus / MTZ'],
                    _brands,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _sectionTitle('Price Range', 'PKR 5 Lac - PKR 50 Lac'),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(activeTrackColor: AppColors.brand, thumbColor: AppColors.secondaryContainer),
                    child: RangeSlider(
                      values: const RangeValues(0.1, 0.8),
                      onChanged: (_) {},
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _sectionTitle('Location / Division', 'Punjab Mandis'),
                  _chipWrap(
                    ['Faisalabad', 'Lahore', 'Multan', 'Sargodha', 'Rahim Yar Khan', 'Sahiwal'],
                    _cities,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Model Year', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['2020 - 2024', '2015 - 2019', 'Before 2015'].map((y) {
                      return ChoiceChip(
                        label: Text(y),
                        selected: _year == y,
                        onSelected: (_) => setState(() => _year = y),
                        selectedColor: AppColors.secondaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Equipment Condition', style: TextStyle(fontWeight: FontWeight.w600)),
                  RadioListTile<String>(
                    value: 'used',
                    groupValue: _condition,
                    onChanged: (v) => setState(() => _condition = v!),
                    title: const Text('Used / Second Hand'),
                    subtitle: const Text('38 Available'),
                  ),
                  RadioListTile<String>(
                    value: 'new',
                    groupValue: _condition,
                    onChanged: (v) => setState(() => _condition = v!),
                    title: const Text('Brand New (Zero Meter)'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _sectionTitle('Horsepower (HP)', ''),
                  _chipWrap(['50 - 65 HP', '70 - 85 HP', '85+ HP (Heavy Duty)'], _hp),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.margin),
              child: PrimaryButton(
                label: 'Apply Filters ($_resultCount Results)',
                icon: Icons.filter_alt,
                onPressed: () {
                  widget.onApply(_resultCount);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _brands.clear();
      _cities.clear();
      _hp.clear();
      _resultCount = 128;
    });
  }

  Widget _sectionTitle(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brand)),
          if (right.isNotEmpty) Text(right, style: const TextStyle(fontSize: 12, color: AppColors.brand)),
        ],
      ),
    );
  }

  Widget _chipWrap(List<String> labels, Set<String> selected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) {
        final isOn = selected.contains(label);
        return FilterChip(
          label: Text(label),
          selected: isOn,
          onSelected: (_) {
            setState(() {
              if (isOn) {
                selected.remove(label);
              } else {
                selected.add(label);
              }
            });
          },
          selectedColor: AppColors.secondaryContainer,
          checkmarkColor: AppColors.brand,
        );
      }).toList(),
    );
  }
}
