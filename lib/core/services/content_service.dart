import 'dart:convert';

import 'package:flutter/services.dart';

import '../../data/roster_avatar_assets.dart';
import '../../models/content_models.dart';

class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  DioceseContent? _diocese;
  ResourcesContent? _resources;
  GroupsContent? _groups;
  MembersRoster? _membersRoster;
  SpeakersGuestsContent? _speakersGuests;

  Future<DioceseContent> get diocese async {
    _diocese ??= DioceseContent.fromJson(
      await _loadJson('assets/data/diocese.json'),
    );
    return _diocese!;
  }

  /// Always read from [assets/data/vicariates.json] (no in-memory cache).
  Future<List<Vicariate>> get vicariates async {
    return (await _loadJson('assets/data/vicariates.json') as List)
        .map((e) => Vicariate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ResourcesContent> get resources async {
    _resources ??= ResourcesContent.fromJson(
      await _loadJson('assets/data/resources.json'),
    );
    return _resources!;
  }

  /// Always read from [assets/data/emergency.json] (no in-memory cache).
  Future<EmergencyContent> get emergency async {
    return EmergencyContent.fromJson(
      await _loadJson('assets/data/emergency.json'),
    );
  }

  Future<GroupsContent> get groups async {
    _groups ??= GroupsContent.fromJson(
      await _loadJson('assets/data/groups.json'),
    );
    return _groups!;
  }

  Future<MembersRoster> get membersRoster async {
    _membersRoster ??= MembersRoster.fromJson(
      await _loadJson('assets/data/members.json') as Map<String, dynamic>,
      resolveAvatarAsset: rosterAvatarAssetFor,
    );
    return _membersRoster!;
  }

  /// Always read from [assets/data/event.json] (no in-memory cache).
  Future<EventContent> get event async {
    return EventContent.fromJson(
      await _loadJson('assets/data/event.json'),
    );
  }

  Future<SpeakersGuestsContent> get speakersGuests async {
    _speakersGuests ??= SpeakersGuestsContent.fromJson(
      await _loadJson('assets/data/speakers.json') as Map<String, dynamic>,
    );
    return _speakersGuests!;
  }

  Future<dynamic> _loadJson(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw);
  }
}
