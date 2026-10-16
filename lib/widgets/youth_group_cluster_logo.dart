import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../data/youth_group_clusters.dart';

/// Loads `assets/images/clusters/{id}.png` when present; otherwise shows a placeholder.
class YouthGroupClusterLogo extends StatelessWidget {
  const YouthGroupClusterLogo({
    super.key,
    required this.cluster,
    this.size = 64,
  });

  final YouthGroupCluster cluster;
  final double size;

  static final _assetExistsCache = <String, bool>{};

  static Future<bool> _assetExists(String assetPath) async {
    final cached = _assetExistsCache[assetPath];
    if (cached != null) return cached;
    try {
      await rootBundle.load(assetPath);
      _assetExistsCache[assetPath] = true;
      return true;
    } catch (_) {
      _assetExistsCache[assetPath] = false;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _assetExists(cluster.logoAsset),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return _LogoWithShadow(
            size: size,
            child: Image.asset(
              cluster.logoAsset,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  _Placeholder(cluster: cluster, size: size),
            ),
          );
        }
        return _Placeholder(cluster: cluster, size: size);
      },
    );
  }
}

class _LogoWithShadow extends StatelessWidget {
  const _LogoWithShadow({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.cluster, required this.size});

  final YouthGroupCluster cluster;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cluster.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Icon(
        cluster.icon,
        size: size * 0.42,
        color: cluster.color.withValues(alpha: 0.75),
      ),
    );
  }
}
