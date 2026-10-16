import 'package:flutter_test/flutter_test.dart';
import 'package:dyd2026/data/committee_roster.dart';
import 'package:dyd2026/models/content_models.dart';

void main() {
  test('ContentSection parses from JSON', () {
    final section = ContentSection.fromJson({
      'title': 'Test',
      'body': 'Body text',
    });
    expect(section.title, 'Test');
    expect(section.body, 'Body text');
  });

  test('CommitteeCluster parses members', () {
    final cluster = CommitteeCluster.fromJson({
      'id': 'program',
      'name': 'Program Cluster',
      'members': [
        {'name': 'Joyce Arcipe'},
      ],
    });
    expect(cluster.members.length, 1);
    expect(cluster.members.first.name, 'Joyce Arcipe');
  });

  test('resolveCommittees fills empty clusters from the roster', () {
    final resolved = resolveCommittees([
      const CommitteeCluster(id: 'program', name: 'Program Cluster', members: []),
    ]);
    expect(resolved.any((c) => c.id == 'main-organizers'), isTrue);
    expect(
      resolved.firstWhere((c) => c.id == 'program').members,
      isNotEmpty,
    );
  });
}
