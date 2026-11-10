import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class OtpInputSection extends StatefulWidget {
  const OtpInputSection({
    super.key,
    required this.onCompleted,
    this.length = 4,
    this.showKeypad = true,
  });

  final ValueChanged<String> onCompleted;
  final int length;
  final bool showKeypad;

  @override
  State<OtpInputSection> createState() => _OtpInputSectionState();
}

class _OtpInputSectionState extends State<OtpInputSection> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
    _tick();
  }

  void _tick() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 30));
      return _secondsLeft > 0;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onDigit(String digit) {
    final index = _controllers.indexWhere((c) => c.text.isEmpty);
    if (index == -1) return;
    _controllers[index].text = digit;
    if (index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    _notify();
  }

  void _backspace() {
    final index = _controllers.lastIndexWhere((c) => c.text.isNotEmpty);
    if (index == -1) return;
    _controllers[index].clear();
    _nodes[index].requestFocus();
    _notify();
  }

  void _notify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length) widget.onCompleted(code);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (i) {
            return Padding(
              padding: EdgeInsets.only(right: i == widget.length - 1 ? 0 : AppSpacing.sm),
              child: SizedBox(
                width: 64,
                height: 64,
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _nodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.surfaceLow,
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  onChanged: (v) {
                    if (v.isNotEmpty && i < widget.length - 1) _nodes[i + 1].requestFocus();
                    if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                    _notify();
                  },
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_secondsLeft > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule, size: 18, color: AppColors.brand),
              const SizedBox(width: 6),
              Text('Resend code in ${_secondsLeft}s', style: Theme.of(context).textTheme.labelLarge),
            ],
          )
        else
          TextButton(onPressed: () => setState(() => _secondsLeft = 30), child: const Text('Resend code')),
        if (widget.showKeypad) ...[
          const SizedBox(height: AppSpacing.lg),
          _NumericKeypad(onDigit: _onDigit, onBackspace: _backspace),
        ],
      ],
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  const _NumericKeypad({required this.onDigit, required this.onBackspace});
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'fp', '0', 'bk'];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: keys.length,
        itemBuilder: (context, i) {
          final key = keys[i];
          if (key == 'fp') {
            return _Key(child: const Icon(Icons.fingerprint, size: 20), onTap: () {});
          }
          if (key == 'bk') {
            return _Key(child: const Icon(Icons.backspace_outlined, size: 20), onTap: onBackspace);
          }
          return _Key(child: Text(key, style: Theme.of(context).textTheme.titleMedium), onTap: () => onDigit(key));
        },
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Center(child: child)),
    );
  }
}
