import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/youth_members_roster.dart';
import '../models/content_models.dart';
import 'member_avatar.dart';
import 'youth_group_cluster_logo.dart';

const _avatarSize = 96.0;
const _avatarRingPadding = 4.0;
const _avatarBorderWidth = 3.0;

double get _avatarOuterDiameter =>
    _avatarSize + 2 * _avatarRingPadding + 2 * _avatarBorderWidth;

double get _avatarHalfOverflow => _avatarOuterDiameter / 2;

/// Role text shown on the namecard only (members → Delegate, not raw CSV notes).
String? _namecardRoleLabel(RosterMember member) {
  if (member.isFacilitator) return 'Facilitator';
  if (member.notes.toLowerCase().contains('member')) return 'Delegate';
  if (member.notes.isNotEmpty) return member.notes;
  return null;
}

Future<void> showMemberNamecardModal(
  BuildContext context, {
  required RosterMember member,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      final cluster =
          youthGroupClusterForMembersJsonGroup(member.group);
      final accent = cluster?.color ?? AppColors.primary;
      final halfOverflow = _avatarHalfOverflow;
      final roleLabel = _namecardRoleLabel(member);

      return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.none,
        insetPadding: EdgeInsets.fromLTRB(
          28,
          halfOverflow + 24,
          28,
          24,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(top: halfOverflow),
              child: Material(
                color: AppColors.surface,
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 0.12),
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    halfOverflow + 18,
                    24,
                    28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        member.nickname.isNotEmpty
                            ? member.nickname
                            : member.fullName,
                        textAlign: TextAlign.center,
                        style: Theme.of(dialogContext)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: accent,
                              height: 1.15,
                            ),
                      ),
                      if (member.nickname.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          member.fullName,
                          textAlign: TextAlign.center,
                          style: Theme.of(dialogContext)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 16,
                            color: accent.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              member.parishMunicipality,
                              textAlign: TextAlign.center,
                              style: Theme.of(dialogContext)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: accent.withValues(alpha: 0.72),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (roleLabel != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Text(
                            roleLabel,
                            textAlign: TextAlign.center,
                            style: Theme.of(dialogContext)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (cluster != null)
                            YouthGroupClusterLogo(
                              cluster: cluster,
                              size: 22,
                            )
                          else
                            Icon(
                              Icons.groups_outlined,
                              size: 20,
                              color: accent,
                            ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              member.group,
                              textAlign: TextAlign.center,
                              style: Theme.of(dialogContext)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: accent,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(_avatarRingPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: accent, width: _avatarBorderWidth),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: MemberAvatar(
                  avatarAsset: member.avatarAsset,
                  size: _avatarSize,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
