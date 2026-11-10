import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

/// Remote images with placeholder, cache, and offline fallback.
class AgriNetworkImage extends StatelessWidget {
  const AgriNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final child = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (_, __) => const _ImagePlaceholder(),
      errorWidget: (_, __, ___) => const _ImagePlaceholder(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}

class AgriAvatarImage extends StatelessWidget {
  const AgriAvatarImage({super.key, this.networkUrl, this.radius = 34});

  final String? networkUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
  if (networkUrl == null || networkUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(AppAssets.appIcon),
        backgroundColor: AppColors.surfaceLow,
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceLow,
      child: ClipOval(
        child: AgriNetworkImage(imageUrl: networkUrl!, width: radius * 2, height: radius * 2),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceLow,
      child: Center(
        child: Image.asset(
          AppAssets.appIcon,
          width: 56,
          height: 56,
          opacity: const AlwaysStoppedAnimation(0.35),
          errorBuilder: (_, __, ___) => const Icon(Icons.agriculture, color: AppColors.brand, size: 40),
        ),
      ),
    );
  }
}
