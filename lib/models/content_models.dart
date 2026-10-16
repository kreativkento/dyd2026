class ContentSection {
  const ContentSection({
    required this.title,
    required this.body,
    this.subtitle,
    this.imageAsset,
    this.signatoryName,
    this.signatoryRole,
    this.signatoryAffiliation,
  });

  final String title;
  final String? subtitle;
  final String body;
  final String? imageAsset;
  final String? signatoryName;
  final String? signatoryRole;
  final String? signatoryAffiliation;

  bool get hasSignatoryBlock =>
      (signatoryName != null && signatoryName!.trim().isNotEmpty) ||
      (signatoryRole != null && signatoryRole!.trim().isNotEmpty) ||
      (signatoryAffiliation != null && signatoryAffiliation!.trim().isNotEmpty);

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      body: json['body'] as String,
      imageAsset: json['imageAsset'] as String?,
      signatoryName: json['signatoryName'] as String?,
      signatoryRole: json['signatoryRole'] as String?,
      signatoryAffiliation: json['signatoryAffiliation'] as String?,
    );
  }
}

class DioceseContent {
  const DioceseContent({
    required this.name,
    required this.history,
    required this.mission,
    required this.youthDirectorMessage,
    required this.assistantYouthDirectorMessage,
    required this.diocesanYouthCoordinatorMessage,
    required this.diocesanYouthLeaderMessage,
    this.bishopMessage,
  });

  final String name;
  final ContentSection history;
  final ContentSection mission;
  final ContentSection youthDirectorMessage;
  final ContentSection assistantYouthDirectorMessage;
  final ContentSection diocesanYouthCoordinatorMessage;
  final ContentSection diocesanYouthLeaderMessage;
  final ContentSection? bishopMessage;

  factory DioceseContent.fromJson(Map<String, dynamic> json) {
    final bishopRaw = json['bishopMessage'];
    return DioceseContent(
      name: json['name'] as String,
      history: ContentSection.fromJson(json['history'] as Map<String, dynamic>),
      mission: ContentSection.fromJson(json['mission'] as Map<String, dynamic>),
      youthDirectorMessage: ContentSection.fromJson(
        json['youthDirectorMessage'] as Map<String, dynamic>,
      ),
      assistantYouthDirectorMessage: ContentSection.fromJson(
        json['assistantYouthDirectorMessage'] as Map<String, dynamic>,
      ),
      diocesanYouthCoordinatorMessage: ContentSection.fromJson(
        json['diocesanYouthCoordinatorMessage'] as Map<String, dynamic>,
      ),
      diocesanYouthLeaderMessage: ContentSection.fromJson(
        json['diocesanYouthLeaderMessage'] as Map<String, dynamic>,
      ),
      bishopMessage: bishopRaw is Map<String, dynamic>
          ? ContentSection.fromJson(bishopRaw)
          : null,
    );
  }
}

class Person {
  const Person({
    required this.name,
    this.role,
    this.parish,
    this.contact,
    this.imageAsset,
  });

  final String name;
  final String? role;
  final String? parish;
  final String? contact;
  final String? imageAsset;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      role: json['role'] as String?,
      parish: json['parish'] as String?,
      contact: json['contact'] as String?,
      imageAsset: json['imageAsset'] as String?,
    );
  }
}

class Parish {
  const Parish({
    required this.id,
    required this.name,
    this.address = '',
    this.priest,
    this.pastorModerator,
    this.pastorTitle,
    this.diocese,
    this.vicariate,
    this.established,
    this.titular,
    this.feastDate,
    this.contact,
    this.imageAsset,
    this.delegates = const [],
    this.description,
  });

  final String id;
  final String name;
  final String address;
  final String? priest;
  final String? pastorModerator;
  final String? pastorTitle;
  final String? diocese;
  final String? vicariate;
  final String? established;
  final String? titular;
  final String? feastDate;
  final String? contact;
  final String? imageAsset;
  final List<Person> delegates;
  final String? description;

  String? get pastorLabel =>
      pastorModerator ?? priest;

  String get clergyRoleLabel =>
      (pastorTitle != null && pastorTitle!.trim().isNotEmpty)
          ? pastorTitle!.trim()
          : 'Pastor Moderator';

  factory Parish.fromJson(Map<String, dynamic> json) {
    return Parish(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      priest: json['priest'] as String?,
      pastorModerator: json['pastorModerator'] as String?,
      pastorTitle: json['pastorTitle'] as String?,
      diocese: json['diocese'] as String?,
      vicariate: json['vicariate'] as String?,
      established: json['established'] as String?,
      titular: json['titular'] as String?,
      feastDate: json['feastDate'] as String?,
      contact: json['contact'] as String?,
      imageAsset: json['imageAsset'] as String?,
      description: json['description'] as String?,
      delegates: (json['delegates'] as List? ?? [])
          .map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Vicariate {
  const Vicariate({
    required this.id,
    required this.name,
    required this.parishes,
  });

  final String id;
  final String name;
  final List<Parish> parishes;

  factory Vicariate.fromJson(Map<String, dynamic> json) {
    final nameRaw =
        json['name'] ?? json['title'] ?? json['label'] ?? json['displayName'];
    final name = nameRaw is String ? nameRaw.trim() : '';
    return Vicariate(
      id: json['id'] as String,
      name: name,
      parishes: (json['parishes'] as List? ?? [])
          .map((e) => Parish.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PrayerEntry {
  const PrayerEntry({
    required this.title,
    required this.content,
    this.category,
  });

  final String title;
  final String? category;
  final String content;

  factory PrayerEntry.fromJson(Map<String, dynamic> json) {
    return PrayerEntry(
      title: json['title'] as String,
      category: json['category'] as String?,
      content: json['content'] as String,
    );
  }
}

class LiturgyPsalmStanza {
  const LiturgyPsalmStanza({
    required this.lines,
    this.response,
  });

  final List<String> lines;
  final String? response;

  factory LiturgyPsalmStanza.fromJson(Map<String, dynamic> json) {
    return LiturgyPsalmStanza(
      lines: (json['lines'] as List).map((e) => e as String).toList(),
      response: json['response'] as String?,
    );
  }
}

class LiturgyReading {
  const LiturgyReading({
    required this.title,
    this.citation,
    this.response,
    this.content = '',
    this.psalmStanzas = const [],
  });

  final String title;
  final String? citation;
  final String? response;
  final String content;
  final List<LiturgyPsalmStanza> psalmStanzas;

  bool get isPsalm => psalmStanzas.isNotEmpty;

  factory LiturgyReading.fromJson(Map<String, dynamic> json) {
    final rawContent = json['content'];
    var text = '';
    var stanzas = <LiturgyPsalmStanza>[];

    if (rawContent is String) {
      text = rawContent.replaceAll('\r\n', '\n').trim();
    } else if (rawContent is Map<String, dynamic>) {
      final verses = rawContent['verses'] as List?;
      if (verses != null) {
        stanzas = verses
            .map((e) => LiturgyPsalmStanza.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return LiturgyReading(
      title: json['title'] as String,
      citation: json['citation'] as String?,
      response: json['response'] as String?,
      content: text,
      psalmStanzas: stanzas,
    );
  }
}

class MassGuideContent {
  const MassGuideContent({
    required this.title,
    this.subtitle,
    this.readings = const [],
    this.body = '',
  });

  final String title;
  final String? subtitle;
  final List<LiturgyReading> readings;
  final String body;

  factory MassGuideContent.fromJson(Map<String, dynamic> json) {
    final readingsJson = json['readings'] as List?;
    return MassGuideContent(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      body: json['body'] as String? ?? '',
      readings: readingsJson == null
          ? const []
          : readingsJson
              .map((e) => LiturgyReading.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

enum ThemeSongSectionKind { verse, chorus, note, finale }

class ThemeSongSection {
  const ThemeSongSection({
    required this.label,
    required this.lines,
    this.kind = ThemeSongSectionKind.verse,
  });

  final String label;
  final List<String> lines;
  final ThemeSongSectionKind kind;

  factory ThemeSongSection.fromJson(Map<String, dynamic> json) {
    final kindRaw = json['kind'] as String? ?? 'verse';
    final kind = ThemeSongSectionKind.values.firstWhere(
      (k) => k.name == kindRaw,
      orElse: () => ThemeSongSectionKind.verse,
    );
    return ThemeSongSection(
      label: json['label'] as String? ?? '',
      lines: (json['lines'] as List? ?? []).map((e) => e as String).toList(),
      kind: kind,
    );
  }
}

class ThemeSongContent {
  const ThemeSongContent({
    required this.title,
    required this.tagline,
    required this.sections,
  });

  final String title;
  final String tagline;
  final List<ThemeSongSection> sections;

  factory ThemeSongContent.fromJson(Map<String, dynamic> json) {
    return ThemeSongContent(
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      sections: (json['sections'] as List)
          .map((e) => ThemeSongSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ResourcesContent {
  const ResourcesContent({
    required this.prayers,
    required this.massGuide,
    required this.themeSong,
  });

  final List<PrayerEntry> prayers;
  final MassGuideContent massGuide;
  final ThemeSongContent themeSong;

  factory ResourcesContent.fromJson(Map<String, dynamic> json) {
    return ResourcesContent(
      prayers: (json['prayers'] as List? ?? [])
          .map((e) => PrayerEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      massGuide: MassGuideContent.fromJson(
        json['massGuide'] as Map<String, dynamic>,
      ),
      themeSong: ThemeSongContent.fromJson(
        json['themeSong'] as Map<String, dynamic>,
      ),
    );
  }
}

class EmergencyContact {
  const EmergencyContact({
    required this.name,
    required this.number,
    this.notes,
    this.section,
  });

  final String name;
  final String number;
  final String? notes;

  /// Optional heading shown above this contact (e.g. provincial backup group).
  final String? section;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] as String,
      number: json['number'] as String,
      notes: json['notes'] as String?,
      section: json['section'] as String?,
    );
  }
}

class EmergencyContent {
  const EmergencyContent({
    required this.firstAid,
    required this.contacts,
  });

  final List<ContentSection> firstAid;
  final List<EmergencyContact> contacts;

  factory EmergencyContent.fromJson(Map<String, dynamic> json) {
    return EmergencyContent(
      firstAid: (json['firstAid'] as List)
          .map((e) => ContentSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List)
          .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AssemblyPoint {
  const AssemblyPoint({
    required this.name,
    required this.location,
    this.notes,
  });

  final String name;
  final String location;
  final String? notes;

  factory AssemblyPoint.fromJson(Map<String, dynamic> json) {
    return AssemblyPoint(
      name: json['name'] as String,
      location: json['location'] as String,
      notes: json['notes'] as String?,
    );
  }
}

class YouthGroup {
  const YouthGroup({
    required this.id,
    required this.name,
    required this.cluster,
    required this.members,
    this.assemblyPoint,
  });

  final String id;
  final String name;
  final String cluster;
  final String? assemblyPoint;
  final List<Person> members;

  factory YouthGroup.fromJson(Map<String, dynamic> json) {
    return YouthGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      cluster: json['cluster'] as String,
      assemblyPoint: json['assemblyPoint'] as String?,
      members: (json['members'] as List? ?? [])
          .map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RosterMember {
  const RosterMember({
    required this.fullName,
    required this.nickname,
    required this.parishMunicipality,
    required this.notes,
    required this.group,
    required this.avatarAsset,
  });

  final String fullName;
  final String nickname;
  final String parishMunicipality;
  final String notes;
  final String group;
  final String avatarAsset;

  factory RosterMember.fromJson(
    Map<String, dynamic> json, {
    required int index,
    String Function({
      required String fullName,
      required String group,
      required int index,
      required String parishMunicipality,
    })? avatarFallback,
  }) {
    final fullName = json['fullName'] as String;
    final group = json['group'] as String;
    final parishMunicipality = json['parishMunicipality'] as String;
    final avatarFromJson = json['avatarAsset'] as String?;
    final resolvedAvatar = (avatarFromJson != null && avatarFromJson.isNotEmpty)
        ? avatarFromJson
        : avatarFallback?.call(
            fullName: fullName,
            group: group,
            index: index,
            parishMunicipality: parishMunicipality,
          );
    return RosterMember(
      fullName: fullName,
      nickname: json['nickname'] as String,
      parishMunicipality: json['parishMunicipality'] as String,
      notes: json['notes'] as String,
      group: group,
      avatarAsset:
          resolvedAvatar ?? 'assets/images/avatars/img_avatar1.png',
    );
  }

  bool get isFacilitator =>
      notes.toLowerCase().contains('facilitator');
}

class MembersRoster {
  const MembersRoster({required this.members, required this.byGroup});

  final List<RosterMember> members;
  final Map<String, List<RosterMember>> byGroup;

  factory MembersRoster.fromJson(
    Map<String, dynamic> json, {
    String Function({
      required String fullName,
      required String group,
      required int index,
      required String parishMunicipality,
    })? resolveAvatarAsset,
  }) {
    final rawMembers = json['members'] as List;
    final members = <RosterMember>[];
    for (var i = 0; i < rawMembers.length; i++) {
      members.add(
        RosterMember.fromJson(
          rawMembers[i] as Map<String, dynamic>,
          index: i,
          avatarFallback: resolveAvatarAsset,
        ),
      );
    }
    final byGroup = <String, List<RosterMember>>{};
    for (final member in members) {
      byGroup.putIfAbsent(member.group, () => []).add(member);
    }
    return MembersRoster(members: members, byGroup: byGroup);
  }

  List<RosterMember> forGroupLabel(String groupLabel) =>
      byGroup[groupLabel] ?? const [];
}

class GroupsContent {
  const GroupsContent({
    required this.assemblyPoints,
    required this.groups,
  });

  final List<AssemblyPoint> assemblyPoints;
  final List<YouthGroup> groups;

  factory GroupsContent.fromJson(Map<String, dynamic> json) {
    return GroupsContent(
      assemblyPoints: (json['assemblyPoints'] as List)
          .map((e) => AssemblyPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      groups: (json['groups'] as List)
          .map((e) => YouthGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ScheduleItem {
  const ScheduleItem({
    required this.time,
    required this.title,
    this.part,
    this.location,
    this.description,
  });

  final String time;
  final String title;

  /// Program segment, e.g. "Part I — Encounter" or "Part II — Mission".
  final String? part;

  /// Physical venue (optional). Not used for program parts.
  final String? location;
  final String? description;

  ScheduleProgramPart get schedulePart {
    final segment = part ?? location ?? '';
    if (segment.contains('Mission') || segment.contains('Part II')) {
      return ScheduleProgramPart.mission;
    }
    return ScheduleProgramPart.encounter;
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      time: json['time'] as String,
      title: json['title'] as String,
      part: json['part'] as String? ?? json['location'] as String?,
      location: json['venue'] as String?,
      description: json['description'] as String?,
    );
  }
}

enum ScheduleProgramPart {
  encounter('Part I — Encounter'),
  mission('Part II — Mission');

  const ScheduleProgramPart(this.label);
  final String label;
}

class Speaker {
  const Speaker({
    required this.name,
    required this.topic,
    this.bio,
    this.imageAsset,
  });

  final String name;
  final String topic;
  final String? bio;
  final String? imageAsset;

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] as String,
      topic: json['topic'] as String,
      bio: json['bio'] as String?,
      imageAsset: json['imageAsset'] as String?,
    );
  }
}

class PlenarySpeakerProfile {
  const PlenarySpeakerProfile({
    required this.name,
    required this.credentials,
    required this.role,
    required this.copy,
  });

  final String name;
  final String credentials;
  final String role;
  final String copy;

  factory PlenarySpeakerProfile.fromJson(Map<String, dynamic> json) {
    return PlenarySpeakerProfile(
      name: json['name'] as String,
      credentials: json['credentials'] as String? ?? '',
      role: json['role'] as String? ?? '',
      copy: json['copy'] as String? ?? '',
    );
  }
}

class EventGuestParticipant {
  const EventGuestParticipant({
    required this.name,
    required this.role,
  });

  final String name;
  final String role;

  factory EventGuestParticipant.fromJson(Map<String, dynamic> json) {
    return EventGuestParticipant(
      name: json['name'] as String,
      role: json['role'] as String? ?? '',
    );
  }
}

class SpeakersGuestsContent {
  const SpeakersGuestsContent({
    required this.speaker,
    required this.participants,
  });

  final PlenarySpeakerProfile speaker;
  final List<EventGuestParticipant> participants;

  factory SpeakersGuestsContent.fromJson(Map<String, dynamic> json) {
    return SpeakersGuestsContent(
      speaker: PlenarySpeakerProfile.fromJson(
        json['speaker'] as Map<String, dynamic>,
      ),
      participants: (json['participants'] as List)
          .map(
            (e) => EventGuestParticipant.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class CommitteeCluster {
  const CommitteeCluster({
    required this.id,
    required this.name,
    required this.members,
    this.description,
  });

  final String id;
  final String name;
  final String? description;
  final List<Person> members;

  factory CommitteeCluster.fromJson(Map<String, dynamic> json) {
    final directMembers = (json['members'] as List? ?? [])
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();
    final unitMembers = (json['units'] as List? ?? [])
        .expand((unit) {
          final map = unit as Map<String, dynamic>;
          return (map['members'] as List? ?? []).map(
            (e) => Person.fromJson(e as Map<String, dynamic>),
          );
        })
        .toList();

    return CommitteeCluster(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      members: directMembers.isNotEmpty ? directMembers : unitMembers,
    );
  }
}

class HostParishContent {
  const HostParishContent({
    required this.name,
    required this.history,
    required this.priestMessage,
    required this.associatePastorMessage,
    required this.coordinatorMessage,
    required this.leaderMessage,
    this.location,
    this.address,
  });

  final String name;
  final String? location;
  final String? address;
  final ContentSection history;
  final ContentSection priestMessage;
  final ContentSection associatePastorMessage;
  final ContentSection coordinatorMessage;
  final ContentSection leaderMessage;

  factory HostParishContent.fromJson(Map<String, dynamic> json) {
    return HostParishContent(
      name: json['name'] as String,
      location: json['location'] as String?,
      address: json['address'] as String?,
      history: ContentSection.fromJson(json['history'] as Map<String, dynamic>),
      priestMessage: ContentSection.fromJson(
        json['priestMessage'] as Map<String, dynamic>,
      ),
      associatePastorMessage: ContentSection.fromJson(
        json['associatePastorMessage'] as Map<String, dynamic>,
      ),
      coordinatorMessage: ContentSection.fromJson(
        json['coordinatorMessage'] as Map<String, dynamic>,
      ),
      leaderMessage: ContentSection.fromJson(
        json['leaderMessage'] as Map<String, dynamic>,
      ),
    );
  }
}

class DydHistoryEntry {
  const DydHistoryEntry({required this.title, this.bullets = const []});

  final String title;
  final List<String> bullets;

  factory DydHistoryEntry.fromJson(Map<String, dynamic> json) {
    return DydHistoryEntry(
      title: json['title'] as String,
      bullets: (json['bullets'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}

class DydHistoryGroup {
  const DydHistoryGroup({
    required this.title,
    this.entries = const [],
  });

  final String title;
  final List<DydHistoryEntry> entries;

  factory DydHistoryGroup.fromJson(Map<String, dynamic> json) {
    return DydHistoryGroup(
      title: json['title'] as String,
      entries: (json['entries'] as List? ?? [])
          .map((e) => DydHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DydHistorySection {
  const DydHistorySection({
    required this.heading,
    this.paragraphs = const [],
    this.groups = const [],
  });

  final String heading;
  final List<String> paragraphs;
  final List<DydHistoryGroup> groups;

  factory DydHistorySection.fromJson(Map<String, dynamic> json) {
    return DydHistorySection(
      heading: json['heading'] as String,
      paragraphs: (json['paragraphs'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      groups: (json['groups'] as List? ?? [])
          .map((e) => DydHistoryGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DydHistoryContent {
  const DydHistoryContent({
    required this.title,
    required this.headline,
    this.bylines = const [],
    this.sections = const [],
    this.body = '',
  });

  final String title;
  final String headline;
  final List<String> bylines;
  final List<DydHistorySection> sections;
  final String body;

  bool get isStructured =>
      headline.trim().isNotEmpty && sections.isNotEmpty;

  factory DydHistoryContent.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List?;
    return DydHistoryContent(
      title: json['title'] as String? ?? 'History',
      headline: json['headline'] as String? ?? '',
      bylines: (json['bylines'] as List? ?? []).map((e) => e as String).toList(),
      sections: sectionsJson == null
          ? const []
          : sectionsJson
              .map((e) => DydHistorySection.fromJson(e as Map<String, dynamic>))
              .toList(),
      body: json['body'] as String? ?? '',
    );
  }
}

DydHistoryContent _eventHistoryFromJson(Map<String, dynamic> json) {
  if (json['history'] is Map<String, dynamic>) {
    return DydHistoryContent.fromJson(json['history'] as Map<String, dynamic>);
  }
  if (json['historyObjective'] is Map<String, dynamic>) {
    final legacy =
        ContentSection.fromJson(json['historyObjective'] as Map<String, dynamic>);
    return DydHistoryContent(
      title: 'History',
      headline: legacy.title,
      body: legacy.body,
    );
  }
  return const DydHistoryContent(title: 'History', headline: '', body: '');
}

class DydObjectiveItem {
  const DydObjectiveItem({required this.keyword, required this.text});

  final String keyword;
  final String text;

  factory DydObjectiveItem.fromJson(Map<String, dynamic> json) {
    return DydObjectiveItem(
      keyword: json['keyword'] as String,
      text: json['text'] as String,
    );
  }
}

class DydObjectivesContent {
  const DydObjectivesContent({
    required this.title,
    this.items = const [],
    this.body = '',
  });

  final String title;
  final List<DydObjectiveItem> items;
  final String body;

  factory DydObjectivesContent.fromJson(Map<String, dynamic> json) {
    return DydObjectivesContent(
      title: json['title'] as String? ?? 'Objectives',
      items: (json['items'] as List? ?? [])
          .map((e) => DydObjectiveItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: json['body'] as String? ?? '',
    );
  }
}

DydObjectivesContent _eventObjectivesFromJson(Map<String, dynamic> json) {
  if (json['objectives'] is Map<String, dynamic>) {
    return DydObjectivesContent.fromJson(
      json['objectives'] as Map<String, dynamic>,
    );
  }
  if (json['historyObjective'] is Map<String, dynamic>) {
    final legacy =
        ContentSection.fromJson(json['historyObjective'] as Map<String, dynamic>);
    return DydObjectivesContent(title: 'Objectives', body: legacy.body);
  }
  return const DydObjectivesContent(title: 'Objectives', body: '');
}

class EventContent {
  const EventContent({
    required this.title,
    required this.tagline,
    required this.hostParish,
    required this.history,
    required this.objectives,
    required this.branding,
    required this.venueMap,
    required this.schedule,
    required this.speakers,
    required this.guidelines,
    required this.committees,
  });

  final String title;
  final String tagline;
  final HostParishContent hostParish;
  final DydHistoryContent history;
  final DydObjectivesContent objectives;
  final ContentSection branding;
  final ContentSection venueMap;
  final List<ScheduleItem> schedule;
  final List<Speaker> speakers;
  final List<ContentSection> guidelines;
  final List<CommitteeCluster> committees;

  factory EventContent.fromJson(Map<String, dynamic> json) {
    return EventContent(
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      hostParish: HostParishContent.fromJson(
        json['hostParish'] as Map<String, dynamic>,
      ),
      history: _eventHistoryFromJson(json),
      objectives: _eventObjectivesFromJson(json),
      branding: ContentSection.fromJson(
        json['branding'] as Map<String, dynamic>,
      ),
      venueMap: ContentSection.fromJson(
        json['venueMap'] as Map<String, dynamic>,
      ),
      schedule: (json['schedule'] as List)
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      speakers: (json['speakers'] as List)
          .map((e) => Speaker.fromJson(e as Map<String, dynamic>))
          .toList(),
      guidelines: (json['guidelines'] as List)
          .map((e) => ContentSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      committees: (json['committees'] as List)
          .map((e) => CommitteeCluster.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
