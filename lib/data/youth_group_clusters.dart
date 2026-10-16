import 'package:flutter/material.dart';

class YouthGroupCluster {
  const YouthGroupCluster({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  /// Matches [YouthGroup.cluster] in `groups.json`.
  final String name;
  final IconData icon;
  final Color color;

  /// PNG logos: `assets/images/clusters/{id}.png` (e.g. `facebook.png`).
  String get logoAsset => 'assets/images/clusters/$id.png';
}

const youthGroupClusters = <YouthGroupCluster>[
  YouthGroupCluster(
    id: 'facebook',
    name: 'Facebook',
    icon: Icons.facebook,
    color: Color(0xFF1877F2),
  ),
  YouthGroupCluster(
    id: 'instagram',
    name: 'Instagram',
    icon: Icons.camera_alt_outlined,
    color: Color(0xFFE4405F),
  ),
  YouthGroupCluster(
    id: 'tiktok',
    name: 'TikTok',
    icon: Icons.music_note_outlined,
    color: Color(0xFF010101),
  ),
  YouthGroupCluster(
    id: 'x',
    name: 'X',
    icon: Icons.tag,
    color: Color(0xFF000000),
  ),
  YouthGroupCluster(
    id: 'youtube',
    name: 'YouTube',
    icon: Icons.play_circle_outline,
    color: Color(0xFFFF0000),
  ),
  YouthGroupCluster(
    id: 'google',
    name: 'Google',
    icon: Icons.search,
    color: Color(0xFF4285F4),
  ),
  YouthGroupCluster(
    id: 'chrome',
    name: 'Chrome',
    icon: Icons.language,
    color: Color(0xFF4285F4),
  ),
  YouthGroupCluster(
    id: 'chatgpt',
    name: 'ChatGPT',
    icon: Icons.auto_awesome_outlined,
    color: Color(0xFF10A37F),
  ),
  YouthGroupCluster(
    id: 'messenger',
    name: 'Messenger',
    icon: Icons.chat_bubble_outline,
    color: Color(0xFF0084FF),
  ),
  YouthGroupCluster(
    id: 'capcut',
    name: 'CapCut',
    icon: Icons.movie_creation_outlined,
    color: Color(0xFF000000),
  ),
];

YouthGroupCluster? youthGroupClusterById(String id) {
  for (final cluster in youthGroupClusters) {
    if (cluster.id == id) return cluster;
  }
  return null;
}
