import '../models/content_models.dart';
import 'youth_group_clusters.dart';
import 'youth_subgroups.dart';

/// Resolves cluster brand color from a [members.json] `group` value (e.g. `Facebook 1`).
YouthGroupCluster? youthGroupClusterForMembersJsonGroup(String groupLabel) {
  final label = groupLabel.trim();
  for (final cluster in youthGroupClusters) {
    for (var i = 1; i <= subgroupsPerCluster; i++) {
      if (membersJsonGroupLabel(cluster, i) == label) {
        return cluster;
      }
    }
  }
  return null;
}

/// Labels in [members.json] `group` field (e.g. `Chat Gpt 3`, `Capcut 1`).
String membersJsonGroupLabel(YouthGroupCluster cluster, int index) {
  final prefix = switch (cluster.id) {
    'chatgpt' => 'Chat Gpt',
    'capcut' => 'Capcut',
    'youtube' => 'Youtube',
    'tiktok' => 'Tiktok',
    _ => cluster.name,
  };
  return '$prefix $index';
}

String? membersJsonGroupLabelForYouthGroup(YouthGroup group) {
  final cluster = youthGroupClusterForName(group.cluster);
  final index = subgroupIndexForGroup(group);
  if (cluster == null || index == null) return null;
  return membersJsonGroupLabel(cluster, index);
}

List<RosterMember> rosterMembersForYouthGroup(
  MembersRoster roster,
  YouthGroup group,
) {
  final label = membersJsonGroupLabelForYouthGroup(group);
  if (label == null) return const [];
  return roster.forGroupLabel(label);
}

int rosterMemberCount(MembersRoster roster, YouthGroup group) =>
    rosterMembersForYouthGroup(roster, group).length;

int rosterFacilitatorCount(MembersRoster roster, YouthGroup group) =>
    rosterMembersForYouthGroup(roster, group)
        .where((m) => m.isFacilitator)
        .length;
