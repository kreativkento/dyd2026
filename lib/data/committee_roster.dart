import '../models/content_models.dart';

List<CommitteeCluster> defaultCommitteeRoster() {
  return const [
    CommitteeCluster(
      id: 'main-organizers',
      name: 'Main Organizers',
      members: [
        Person(
          name: 'Jessa Mae Arcipe',
          role: 'Overall Chairman',
          imageAsset: 'assets/images/committee/mo/mo_jessa.png',
        ),
        Person(
          name: 'John Andrew Registos',
          role: 'Overall Vice-Chairman',
          imageAsset: 'assets/images/committee/mo/mo_andrew.png',
        ),
      ],
    ),
    CommitteeCluster(
      id: 'ministers',
      name: 'Ministers',
      members: [
        Person(
          name: 'Fr. Prospero Elmo Cabili',
          role: 'Parish Priest',
          imageAsset: 'assets/people/img_parishpriest.png',
        ),
        Person(
          name: 'Fr. Leo Almasco',
          role: 'Asst. Parish Priest',
          imageAsset: 'assets/people/img_assocpastor.png',
        ),
      ],
    ),
    CommitteeCluster(
      id: 'secretariat',
      name: 'General Secretariat Cluster',
      members: [
        Person(
          name: 'Mary Grace Quirol',
          imageAsset: 'assets/images/committee/gsec/gsec_grace.png',
        ),
        Person(
          name: 'Lovely Sampayan',
          imageAsset: 'assets/images/committee/gsec/gsec_lovely.png',
        ),
        Person(
          name: 'Lyndee Sampayan',
          imageAsset: 'assets/images/committee/gsec/gsec_lyndee.png',
        ),
      ],
    ),
    CommitteeCluster(
      id: 'program',
      name: 'Program Cluster',
      members: [
        Person(
          name: 'Ranz Darien Bardelas',
          imageAsset: 'assets/images/committee/prog/prog_ranz.png',
        ),
        Person(
          name: 'Joyce Arcipe',
          imageAsset: 'assets/images/committee/prog/prog_joyce.png',
        ),
        Person(
          name: 'Elijah Quirol',
          imageAsset: 'assets/images/committee/prog/prog_elijah.png',
        ),
        Person(
          name: 'Mira Parayray',
          imageAsset: 'assets/images/committee/prog/prog_mira.png',
        ),
        Person(
          name: 'Paul Narca',
          imageAsset: 'assets/images/committee/prog/prog_paul.png',
        ),
        Person(
          name: 'Trisha Prudenciado',
          imageAsset: 'assets/images/committee/prog/prog_trisha.png',
        ),
        Person(
          name: 'Heart Cinco',
          imageAsset: 'assets/images/committee/prog/prog_heart.png',
        ),
        Person(
          name: 'Ken Aleganza',
          imageAsset: 'assets/images/committee/prog/prog_ken_b.png',
        ),
        Person(
          name: 'Ingrid Infante',
          imageAsset: 'assets/images/committee/prog/prog_ingrid.png',
        ),
        Person(
          name: 'Abby Amor',
          imageAsset: 'assets/images/committee/prog/prog_abby.png',
        ),
        Person(name: 'John Amiel Quirol'),
        Person(
          name: 'Jhay',
          imageAsset: 'assets/images/committee/prog/prog_jhay.png',
        ),
        Person(
          name: 'Irish',
          imageAsset: 'assets/images/committee/prog/prog_irish.png',
        ),
        Person(
          name: 'Ken',
          imageAsset: 'assets/images/committee/prog/prog_ken_1.png',
        ),
      ],
    ),
    CommitteeCluster(
      id: 'general-services',
      name: 'General Services Cluster',
      members: [
        Person(
          name: 'Jhon Joy Jace Amante',
          imageAsset: 'assets/images/committee/gserv/gserv_jayjay.png',
        ),
        Person(
          name: 'Mary Joy Mente',
          imageAsset: 'assets/images/committee/gserv/gserv_maryjoy.png',
        ),
        Person(
          name: 'Rigine Butad',
          imageAsset: 'assets/images/committee/prog/prog_rigine.png',
        ),
        Person(
          name: 'Gabriel Arcipe',
          imageAsset: 'assets/images/committee/gserv/gserv_gabriel.png',
        ),
        Person(
          name: 'Michael Jude Arcipe',
          imageAsset: 'assets/images/committee/prog/prog_jude.png',
        ),
        Person(
          name: 'Katherine Mapa',
          imageAsset: 'assets/images/committee/gserv/gserv_katherine.png',
        ),
        Person(name: 'Ezekiel Jazmin'),
        Person(
          name: 'Niño Sampayan',
          imageAsset: 'assets/images/committee/prog/prog_nino.png',
        ),
      ],
    ),
    CommitteeCluster(
      id: 'finance',
      name: 'Finance Cluster',
      members: [
        Person(
          name: 'Shiem Angel Florano',
          imageAsset: 'assets/images/committee/prog/prog_shiem.png',
        ),
        Person(
          name: 'Eduardo Empelis Jr.',
          imageAsset: 'assets/images/speakers/kk_eduardo.png',
        ),
      ],
    ),
    CommitteeCluster(
      id: 'social-communication',
      name: 'Social Communication Cluster',
      members: [
        Person(
          name: 'Froilan Arcipe',
          imageAsset: 'assets/images/committee/socom/socom_froilan.png',
        ),
        Person(
          name: 'Jhay Centus',
          imageAsset: 'assets/images/committee/socom/socom_jhay.png',
        ),
        Person(
          name: 'John Andrew Registos',
          imageAsset: 'assets/images/committee/socom/socom_andrew.png',
        ),
        Person(
          name: 'Juriss Puaso',
          imageAsset: 'assets/images/committee/socom/socom_juriss.png',
        ),
        Person(
          name: 'Wilkris Cabatingan',
          imageAsset: 'assets/images/committee/socom/socom_wilkris.png',
        ),
      ],
    ),
  ];
}

Person _mergeCommitteeMember(Person parsed, Person? rosterMember) {
  if (rosterMember == null) return parsed;
  final parsedPhoto = parsed.imageAsset?.trim();
  final rosterPhoto = rosterMember.imageAsset?.trim();
  return Person(
    name: parsed.name,
    role: parsed.role ?? rosterMember.role,
    parish: parsed.parish ?? rosterMember.parish,
    contact: parsed.contact ?? rosterMember.contact,
    imageAsset: (parsedPhoto != null && parsedPhoto.isNotEmpty)
        ? parsedPhoto
        : (rosterPhoto != null && rosterPhoto.isNotEmpty ? rosterPhoto : null),
  );
}

CommitteeCluster _mergeCommitteeCluster(
  CommitteeCluster parsed,
  CommitteeCluster? rosterCluster,
) {
  if (rosterCluster == null) return parsed;
  final rosterByName = {
    for (final member in rosterCluster.members)
      member.name.trim().toLowerCase(): member,
  };
  return CommitteeCluster(
    id: parsed.id,
    name: parsed.name,
    description: parsed.description ?? rosterCluster.description,
    members: parsed.members
        .map(
          (member) => _mergeCommitteeMember(
            member,
            rosterByName[member.name.trim().toLowerCase()],
          ),
        )
        .toList(),
  );
}

/// Fills empty clusters from the official roster and adds any missing groups.
List<CommitteeCluster> resolveCommittees(List<CommitteeCluster> parsed) {
  final roster = defaultCommitteeRoster();
  final rosterById = {for (final cluster in roster) cluster.id: cluster};
  final seen = <String>{};
  final resolved = <CommitteeCluster>[];

  for (final cluster in parsed) {
    seen.add(cluster.id);
    if (cluster.members.isNotEmpty) {
      resolved.add(_mergeCommitteeCluster(cluster, rosterById[cluster.id]));
    } else {
      resolved.add(rosterById[cluster.id] ?? cluster);
    }
  }

  for (final cluster in roster) {
    if (!seen.contains(cluster.id)) {
      resolved.add(cluster);
    }
  }

  return resolved;
}
