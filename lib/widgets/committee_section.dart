import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/committee_roster.dart';
import '../models/content_models.dart';
import 'member_avatar.dart';
import 'menu_card.dart';
import 'section_header.dart';
import 'speakers_guest_modals.dart';

const _avatarYellow = 'assets/images/avatars/img_avatar1.png';
const _avatarBlue = 'assets/images/avatars/img_avatar2.png';
const _avatarGreen = 'assets/images/avatars/img_avatar3.png';
const _avatarRed = 'assets/images/avatars/img_avatar4.png';

String committeeAvatarAssetForAccent(Color accent) {
  final value = accent.toARGB32();
  if (value == AppColors.yellow.toARGB32()) return _avatarYellow;
  if (value == AppColors.blue.toARGB32()) return _avatarBlue;
  if (value == AppColors.green.toARGB32()) return _avatarGreen;
  if (value == AppColors.primary.toARGB32()) return _avatarRed;
  return _avatarYellow;
}

Color committeeAccentGlyph(Color accent) =>
    accent.toARGB32() == AppColors.yellow.toARGB32()
        ? AppColors.primaryDark
        : accent;

Color committeeAccentSurface(Color accent) =>
    accent.toARGB32() == AppColors.yellow.toARGB32()
        ? AppColors.yellow.withValues(alpha: 0.35)
        : accent.withValues(alpha: 0.12);

IconData committeeClusterIcon(String clusterId) {
  return switch (clusterId) {
    'main-organizers' => Icons.workspace_premium_outlined,
    'ministers' => Icons.church_outlined,
    'secretariat' => Icons.admin_panel_settings_outlined,
    'program' => Icons.celebration_outlined,
    'general-services' => Icons.handyman_outlined,
    'finance' => Icons.account_balance_wallet_outlined,
    'social-communication' => Icons.campaign_outlined,
    _ => Icons.groups_2_outlined,
  };
}

String displayClusterName(String name) {
  return name.replaceFirst(RegExp(r'^\d+\.\s*'), '');
}

Future<void> showCommitteeMembersModal(
  BuildContext context,
  CommitteeCluster cluster, {
  required Color accentColor,
}) {
  final resolved = resolveCommittees([cluster]).first;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => _CommitteeMembersDialog(
      cluster: resolved,
      accentColor: accentColor,
    ),
  );
}

class CommitteesAccordionView extends StatelessWidget {
  const CommitteesAccordionView({super.key, required this.committees});

  final List<CommitteeCluster> committees;

  @override
  Widget build(BuildContext context) {
    final clusters = resolveCommittees(committees);
    final totalMembers =
        clusters.fold<int>(0, (sum, c) => sum + c.members.length);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SectionHeader(
              title: 'Committee Clusters',
              subtitle:
                  '${clusters.length} clusters · $totalMembers members · tap to view',
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cluster = clusters[index];
                final count = cluster.members.length;
                final memberLabel = count == 0
                    ? 'Members TBD'
                    : '$count member${count == 1 ? '' : 's'}';

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < clusters.length - 1 ? 10 : 0,
                  ),
                  child: MenuCard(
                    title: displayClusterName(cluster.name),
                    subtitle: memberLabel,
                    icon: committeeClusterIcon(cluster.id),
                    color: AppColors.primary,
                    variant: MenuCardVariant.prominent,
                    onTap: () => showCommitteeMembersModal(
                      context,
                      cluster,
                      accentColor: AppColors.primary,
                    ),
                  ),
                );
              },
              childCount: clusters.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CommitteeMembersDialog extends StatelessWidget {
  const _CommitteeMembersDialog({
    required this.cluster,
    required this.accentColor,
  });

  final CommitteeCluster cluster;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;
    final title = displayClusterName(cluster.name);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final glyph = committeeAccentGlyph(accentColor);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: maxHeight),
        child: Material(
          color: AppColors.surface,
          elevation: 12,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      accentColor.withValues(alpha: 0.14),
                      accentColor.withValues(alpha: 0.03),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: committeeAccentSurface(accentColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          committeeClusterIcon(cluster.id),
                          color: glyph,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    height: 1.25,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cluster.members.isEmpty
                                  ? 'Member list to be updated'
                                  : '${cluster.members.length} member${cluster.members.length == 1 ? '' : 's'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.3,
                                  ),
                            ),
                            if (cluster.description != null &&
                                cluster.description!.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                cluster.description!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textSecondary,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
                  itemCount:
                      cluster.members.isEmpty ? 1 : cluster.members.length,
                  separatorBuilder: cluster.members.isEmpty
                      ? (_, __) => const SizedBox.shrink()
                      : (_, __) => Divider(
                            height: 1,
                            color: accentColor.withValues(alpha: 0.12),
                          ),
                  itemBuilder: (context, index) {
                    if (cluster.members.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Names will be posted here soon.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                        ),
                      );
                    }

                    final member = cluster.members[index];
                    return _CommitteeMemberRow(
                      member: member,
                      accentColor: accentColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommitteeMemberRow extends StatelessWidget {
  const _CommitteeMemberRow({
    required this.member,
    required this.accentColor,
  });

  final Person member;
  final Color accentColor;

  static const _avatarSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final role = member.role?.trim();
    final hasRole = role != null && role.isNotEmpty;
    final photoAsset = member.imageAsset?.trim();
    final hasPhoto = photoAsset != null && photoAsset.isNotEmpty;
    final avatarAsset = hasPhoto
        ? photoAsset
        : committeeAvatarAssetForAccent(accentColor);
    final posterAsset = hasPhoto ? photoAsset : avatarAsset;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showParticipantPosterModal(
            context,
            imageAsset: posterAsset,
            name: member.name,
            role: member.role,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment:
                hasRole ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              MemberAvatar(
                avatarAsset: avatarAsset,
                size: _avatarSize,
                fit: hasPhoto ? BoxFit.contain : BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: hasRole
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  fontSize: 14.5,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            role,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      )
                    : Text(
                        member.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              fontSize: 14.5,
                            ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
