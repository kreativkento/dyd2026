import 'package:flutter/material.dart';

import '../core/layout/youth_group_cluster_grid_layout.dart';
import '../core/theme/app_theme.dart';
import '../data/youth_group_clusters.dart';
import 'youth_group_cluster_logo.dart';

class YouthGroupClusterTile extends StatelessWidget {
  const YouthGroupClusterTile({
    super.key,
    required this.cluster,
    required this.onTap,
  });

  final YouthGroupCluster cluster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth;
        final logoSize =
            YouthGroupClusterGridLayout.logoSizeForCellWidth(cellWidth);
        final labelFontSize =
            YouthGroupClusterGridLayout.labelFontSizeForCellWidth(cellWidth);
        final padding =
            YouthGroupClusterGridLayout.cellPaddingForCellWidth(cellWidth);
        final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w600,
              height: 1.1,
              color: AppColors.textPrimary,
            );

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            highlightColor: AppColors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: YouthGroupClusterLogo(
                          cluster: cluster,
                          size: logoSize,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        cluster.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
