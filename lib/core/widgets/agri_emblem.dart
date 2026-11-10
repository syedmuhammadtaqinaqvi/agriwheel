import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'agri_wheel_logo.dart';

class AgriEmblem extends StatelessWidget {
  const AgriEmblem({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AgriWheelLogo(size: size, wheelColor: AppColors.green, accentColor: AppColors.yellow);
  }
}
