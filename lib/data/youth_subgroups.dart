import '../models/content_models.dart';
import 'youth_group_clusters.dart';

const subgroupsPerCluster = 5;

/// PNG paths: `assets/images/groups/{clusterId}_{1-5}.png`.
String youthSubgroupImageAsset(String clusterId, int index) {
  assert(index >= 1 && index <= subgroupsPerCluster);
  return 'assets/images/groups/${clusterId}_$index.png';
}

YouthGroupCluster? youthGroupClusterForName(String clusterName) {
  for (final cluster in youthGroupClusters) {
    if (cluster.name == clusterName) return cluster;
  }
  return null;
}

String? subgroupImageAssetForGroup(YouthGroup group) {
  final cluster = youthGroupClusterForName(group.cluster);
  if (cluster == null) return null;

  final index = _subgroupIndexFromId(group.id);
  if (index == null) return null;
  return youthSubgroupImageAsset(cluster.id, index);
}

int? subgroupIndexForGroup(YouthGroup group) => _subgroupIndexFromId(group.id);

int? _subgroupIndexFromId(String id) {
  final dash = id.lastIndexOf('-');
  if (dash <= 0 || dash >= id.length - 1) return null;
  final index = int.tryParse(id.substring(dash + 1));
  if (index == null || index < 1 || index > subgroupsPerCluster) return null;
  return index;
}

/// Five subgroups per cluster; merges [loaded] JSON when ids match `{clusterId}-1` … `-5`.
List<YouthGroup> youthSubgroupsForCluster(
  YouthGroupCluster cluster,
  List<YouthGroup> loaded,
) {
  final inCluster =
      loaded.where((g) => g.cluster == cluster.name).toList();

  return List.generate(subgroupsPerCluster, (i) {
    final index = i + 1;
    final id = '${cluster.id}-$index';
    final match = inCluster.where((g) => g.id == id).firstOrNull;
    if (match != null) return match;

    final legacy = inCluster
        .where((g) => _subgroupIndexFromId(g.id) == null)
        .toList();
    if (legacy.length > i) {
      final source = legacy[i];
      return YouthGroup(
        id: id,
        name: source.name,
        cluster: cluster.name,
        assemblyPoint: source.assemblyPoint,
        members: source.members,
      );
    }

    return YouthGroup(
      id: id,
      name: 'Group $index',
      cluster: cluster.name,
      members: const [],
    );
  });
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
