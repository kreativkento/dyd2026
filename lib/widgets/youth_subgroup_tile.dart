import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/youth_group_clusters.dart';
import '../data/youth_subgroups.dart';
import '../models/content_models.dart';
import 'youth_group_cluster_logo.dart';

class YouthSubgroupTile extends StatelessWidget {
  const YouthSubgroupTile({
    super.key,
    required this.group,
    required this.clusterId,
    required this.memberCount,
    required this.facilitatorCount,
    required this.onTap,
  });

  final YouthGroup group;
  final String clusterId;
  final int memberCount;
  final int facilitatorCount;
  final VoidCallback onTap;

  static const _thumbSize = 72.0;

  @override
  Widget build(BuildContext context) {
    final index = subgroupIndexForGroup(group) ??
        int.tryParse(group.id.split('-').last) ??
        1;
    final imageAsset = youthSubgroupImageAsset(clusterId, index);
    final memberLabel =
        '$memberCount member${memberCount == 1 ? '' : 's'}';
    final facilitatorLabel =
        '$facilitatorCount facilitator${facilitatorCount == 1 ? '' : 's'}';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageAsset,
                  width: _thumbSize,
                  height: _thumbSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    final cluster = youthGroupClusterById(clusterId);
                    return Container(
                      width: _thumbSize,
                      height: _thumbSize,
                      color: AppColors.primary.withValues(alpha: 0.06),
                      child: Center(
                        child: cluster != null
                            ? YouthGroupClusterLogo(
                                cluster: cluster,
                                size: 40,
                              )
                            : Icon(
                                Icons.groups_outlined,
                                size: 32,
                                color: AppColors.primary.withValues(alpha: 0.4),
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group $index',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$memberLabel • $facilitatorLabel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
