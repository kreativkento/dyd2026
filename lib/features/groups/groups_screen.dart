import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/youth_group_cluster_grid_layout.dart';
import '../../core/services/content_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/youth_group_clusters.dart';
import '../../data/youth_members_roster.dart';
import '../../data/youth_subgroups.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/main_tab_scroll_view.dart';
import '../../widgets/section_header.dart';
import '../../widgets/youth_group_cluster_tile.dart';
import '../../widgets/member_avatar.dart';
import '../../widgets/member_namecard_dialog.dart';
import '../../widgets/member_search_field.dart';
import '../../widgets/youth_subgroup_tile.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainTabScrollView(
        slivers: youthGroupClusterGridSlivers(
          context,
          headerPadding: const EdgeInsets.fromLTRB(
            AppLayout.tabHorizontalPadding,
            16,
            AppLayout.tabHorizontalPadding,
            0,
          ),
        ),
      ),
    );
  }
}

List<Widget> youthGroupClusterGridSlivers(
  BuildContext context, {
  EdgeInsets headerPadding = const EdgeInsets.fromLTRB(
    AppLayout.tabHorizontalPadding,
    16,
    AppLayout.tabHorizontalPadding,
    0,
  ),
}) {
  return [
    SliverToBoxAdapter(
      child: Padding(
        padding: headerPadding,
        child: const SectionHeader(
          title: 'Youth Groupings',
          subtitle: 'Tap a cluster to view groups and members',
        ),
      ),
    ),
    SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          headerPadding.left,
          12,
          headerPadding.right,
          0,
        ),
        child: const MemberSearchField(),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppLayout.tabHorizontalPadding,
        12,
        AppLayout.tabHorizontalPadding,
        16,
      ),
      sliver: SliverGrid(
        gridDelegate: YouthGroupClusterGridLayout.gridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final cluster = youthGroupClusters[index];
            return YouthGroupClusterTile(
              cluster: cluster,
              onTap: () => context.push(
                '/groups/cluster/${cluster.id}',
                extra: cluster,
              ),
            );
          },
          childCount: youthGroupClusters.length,
        ),
      ),
    ),
  ];
}

class AssemblyPointsScreen extends StatelessWidget {
  const AssemblyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: FutureBuilder<GroupsContent>(
        future: ContentService.instance.groups,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final points = snapshot.data!.assemblyPoints;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: points.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: SectionHeader(
                    title: 'Assembly Points',
                    subtitle: 'Where clusters meet',
                  ),
                );
              }
              final point = points[index - 1];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(point.name),
                  subtitle: Text([
                    point.location,
                    if (point.notes != null) point.notes,
                  ].join('\n')),
                  isThreeLine: point.notes != null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: CustomScrollView(
        slivers: youthGroupClusterGridSlivers(context),
      ),
    );
  }
}

class ClusterGroupsScreen extends StatelessWidget {
  const ClusterGroupsScreen({super.key, required this.cluster});

  final YouthGroupCluster cluster;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: FutureBuilder<(GroupsContent, MembersRoster)>(
        future: Future.wait([
          ContentService.instance.groups,
          ContentService.instance.membersRoster,
        ]).then((r) => (r[0] as GroupsContent, r[1] as MembersRoster)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final (groupsContent, roster) = snapshot.data!;
          final groups = youthSubgroupsForCluster(
            cluster,
            groupsContent.groups,
          );

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SectionHeader(
                    title: cluster.name,
                    subtitle: '${groups.length} groups',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final group = groups[index];
                      return YouthSubgroupTile(
                        group: group,
                        clusterId: cluster.id,
                        memberCount: rosterMemberCount(roster, group),
                        facilitatorCount: rosterFacilitatorCount(roster, group),
                        onTap: () =>
                            context.push('/groups/${group.id}', extra: group),
                      );
                    },
                    childCount: groups.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key, required this.group});

  final YouthGroup group;

  @override
  Widget build(BuildContext context) {
    final groupIndex = subgroupIndexForGroup(group) ?? 1;

    return AppPageScaffold(
      body: FutureBuilder<MembersRoster>(
        future: ContentService.instance.membersRoster,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final roster = snapshot.data!;
          final allInGroup = rosterMembersForYouthGroup(roster, group);
          final facilitators =
              allInGroup.where((m) => m.isFacilitator).toList();
          final members =
              allInGroup.where((m) => !m.isFacilitator).toList();
          final clusterColor =
              youthGroupClusterForName(group.cluster)?.color;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (subgroupImageAssetForGroup(group) case final imageAsset?)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imageAsset,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.groups_outlined,
                          color: AppColors.primary.withValues(alpha: 0.35),
                        ),
                      ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '${group.cluster} $groupIndex',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.primary,
                              height: 1.15,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Facilitator',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
              ),
              const SizedBox(height: 8),
              if (facilitators.isEmpty)
                Text(
                  'Not assigned yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                )
              else
                ...facilitators.map(
                  (facilitator) => _RosterMemberTile(
                    member: facilitator,
                    highlightColor: clusterColor,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Members (${members.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
              ),
              const SizedBox(height: 8),
              if (members.isEmpty)
                Text(
                  'No members listed yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                )
              else
                ...members.map(
                  (member) => _RosterMemberTile(member: member),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RosterMemberTile extends StatelessWidget {
  const _RosterMemberTile({
    required this.member,
    this.highlightColor,
  });

  final RosterMember member;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final tint = highlightColor;
    final cardColor = tint != null
        ? Color.alphaBlend(tint.withValues(alpha: 0.06), AppColors.surface)
        : AppColors.surface;

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: tint != null
              ? tint.withValues(alpha: 0.14)
              : AppColors.primary.withValues(alpha: 0.08),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showMemberNamecardModal(
          context,
          member: member,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MemberAvatar(avatarAsset: member.avatarAsset),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    member.fullName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 14,
                          color:
                              AppColors.textSecondary.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              member.parishMunicipality,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    height: 1.0,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
