import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/content_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/committee_roster.dart';
import '../../data/schedule_roster.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/committee_section.dart';
import '../../widgets/content_scaffold.dart';
import '../../widgets/dyd_logo_modal.dart';
import '../../widgets/event_guidelines_view.dart';
import '../../widgets/host_parish_card.dart';
import '../../widgets/host_parish_modals.dart';
import '../../widgets/host_parish_profile_modal.dart';
import '../../widgets/main_tab_scroll_view.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/section_header.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<EventContent>(
        future: ContentService.instance.event,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MainTabScrollView(
              slivers: [
                SliverFillRemaining(child: LoadingView()),
              ],
            );
          }
          final event = snapshot.data!;
          return MainTabScrollView.list(
            padding: const EdgeInsets.fromLTRB(
              AppLayout.tabHorizontalPadding,
              10,
              AppLayout.tabHorizontalPadding,
              AppLayout.tabHorizontalPadding,
            ),
            children: [
              HostParishCard(
                parishName: event.hostParish.name,
                onTap: () => context.push('/event/host-parish', extra: event.hostParish),
              ),
              const SizedBox(height: 8),
              _EventDydHeroCard(
                onTap: () => context.push('/event/dyd', extra: event),
              ),
              const SizedBox(height: 12),
              MenuCard(
                title: 'Event Schedule',
                subtitle: '',
                icon: Icons.schedule,
                color: AppColors.green,
                variant: MenuCardVariant.prominent,
                onTap: () =>
                    context.push('/event/schedule', extra: event.schedule),
              ),
              const SizedBox(height: 10),
              MenuCard(
                title: 'Guidelines',
                subtitle: '',
                icon: Icons.rule,
                color: AppColors.blue,
                variant: MenuCardVariant.prominent,
                onTap: () =>
                    context.push('/event/guidelines', extra: event.guidelines),
              ),
              const SizedBox(height: 10),
              MenuCard(
                title: 'Committee Clusters',
                subtitle: '',
                icon: Icons.groups_2,
                color: AppColors.primary,
                variant: MenuCardVariant.prominent,
                onTap: () => context.push(
                  '/event/committees',
                  extra: resolveCommittees(event.committees),
                ),
              ),
              const SizedBox(height: 10),
              MenuCard(
                title: 'Venue Map',
                subtitle: '',
                icon: Icons.map_outlined,
                color: const Color(0xFF9CA3AF),
                variant: MenuCardVariant.prominent,
                onTap: () =>
                    context.push('/event/map', extra: event.venueMap),
              ),
              const SizedBox(height: 10),
              MenuCard(
                title: 'Speakers & Guests',
                subtitle: '',
                icon: Icons.forum_outlined,
                color: AppColors.blue,
                variant: MenuCardVariant.prominent,
                onTap: () => context.push('/event/speakers'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Full-width DYD hero; layout and gradient mirror [HostParishCard].
class _EventDydHeroCard extends StatefulWidget {
  const _EventDydHeroCard({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_EventDydHeroCard> createState() => _EventDydHeroCardState();
}

class _EventDydHeroCardState extends State<_EventDydHeroCard> {
  bool _hovering = false;

  static const _radius = 16.0;
  static const _height = 96.0;
  static const _logoSize = 64.0;
  static const _accent = Color(0xFF521418);

  @override
  Widget build(BuildContext context) {
    final labelColor =
        _hovering ? Colors.white : _accent.withValues(alpha: 0.92);
    final titleColor = _hovering ? Colors.white : _accent;
    final seeInfoColor =
        _hovering ? Colors.white : _accent.withValues(alpha: 0.88);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Material(
          color: const Color(0xFFB8860B),
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: AppColors.blue.withValues(alpha: 0.12),
            child: Ink(
              height: _height,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFFB8860B),
                    Color(0xFFF4BF02),
                  ],
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: _logoSize,
                          child: Center(
                            child: Image.asset(
                              dydLogoAsset,
                              width: _logoSize,
                              height: _logoSize,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_outlined,
                                size: _logoSize * 0.45,
                                color: _accent.withValues(alpha: 0.65),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'About',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: labelColor,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.35,
                                        fontSize: 11,
                                        height: 1.1,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'DYD 2026',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 14,
                    child: Text(
                      'See info >',
                      style: TextStyle(
                        color: seeInfoColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.5,
                        height: 1.1,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HostParishScreen extends StatelessWidget {
  const HostParishScreen({super.key, required this.hostParish});

  final HostParishContent hostParish;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(
            title: hostParish.name,
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  fontSize: 18,
                  height: 1.28,
                ),
          ),
          if (hostParish.address != null && hostParish.address!.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hostParish.address!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          MenuCard(
            title: 'History',
            subtitle: '',
            icon: Icons.history_edu,
            onTap: () => showContentSectionModal(context, hostParish.history),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: "Parish Priest's Message",
            subtitle: hostParish.priestMessage.subtitle ?? 'From the parish priest',
            icon: Icons.person_4_outlined,
            imageAsset: hostParishOfficialPhotoAsset(hostParish.priestMessage),
            variant: MenuCardVariant.prominent,
            onTap: () => showParishOfficialMessageModal(
              context,
              hostParish.priestMessage,
            ),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: "Associate Pastor's Message",
            subtitle: hostParish.associatePastorMessage.subtitle ?? '',
            icon: Icons.person_2_outlined,
            imageAsset:
                hostParishOfficialPhotoAsset(hostParish.associatePastorMessage),
            variant: MenuCardVariant.prominent,
            onTap: () => showParishOfficialMessageModal(
              context,
              hostParish.associatePastorMessage,
            ),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: "Parish Youth Coordinator's Message",
            subtitle: hostParish.coordinatorMessage.subtitle ?? '',
            icon: Icons.supervisor_account,
            imageAsset:
                hostParishOfficialPhotoAsset(hostParish.coordinatorMessage),
            variant: MenuCardVariant.prominent,
            onTap: () => showParishOfficialMessageModal(
              context,
              hostParish.coordinatorMessage,
            ),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: "Parish Youth Leader's Message",
            subtitle: hostParish.leaderMessage.subtitle ?? '',
            icon: Icons.emoji_people,
            imageAsset: hostParishOfficialPhotoAsset(hostParish.leaderMessage),
            variant: MenuCardVariant.prominent,
            onTap: () => showParishOfficialMessageModal(
              context,
              hostParish.leaderMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class EventContentDetailScreen extends StatelessWidget {
  const EventContentDetailScreen({super.key, required this.section});

  final ContentSection section;

  @override
  Widget build(BuildContext context) {
    return ContentScaffold(
      title: section.title,
      subtitle: section.subtitle,
      body: section.body,
      leading: _maybeImage(section.title),
    );
  }

  Widget? _maybeImage(String title) {
    if (title.toLowerCase().contains('logo')) {
      return _AssetImagePlaceholder(
        assetPath: 'assets/images/dyd_logo.png',
        label: 'Add dyd_logo.png to assets/images/',
      );
    }
    if (title.toLowerCase().contains('map') || title.toLowerCase().contains('venue')) {
      return _AssetImagePlaceholder(
        assetPath: 'assets/images/venue_map.png',
        label: 'Add venue_map.png to assets/images/',
      );
    }
    return null;
  }
}

class _AssetImagePlaceholder extends StatelessWidget {
  const _AssetImagePlaceholder({
    required this.assetPath,
    required this.label,
  });

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: double.infinity,
          height: 180,
          color: AppColors.primary.withValues(alpha: 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.4)),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class SchedulePartDetail {
  const SchedulePartDetail({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<ScheduleItem> items;
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key, required this.schedule});

  final List<ScheduleItem> schedule;

  List<ScheduleItem> get _items =>
      schedule.any(
        (item) =>
            item.part?.contains('Encounter') == true ||
            item.part?.contains('Mission') == true ||
            item.part?.contains('Part I') == true ||
            item.part?.contains('Part II') == true ||
            item.location?.contains('Encounter') == true,
      )
          ? schedule
          : officialEventSchedule();

  List<ScheduleItem> _partItems(ScheduleProgramPart part) => _items
      .where((item) => item.schedulePart == part)
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final partI = _partItems(ScheduleProgramPart.encounter);
    final partII = _partItems(ScheduleProgramPart.mission);

    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const SectionHeader(
            title: 'Event Schedule',
            subtitle: 'Part I & Part II program flow',
          ),
          const SizedBox(height: 8),
          _SchedulePartBlock(
            partLabel: 'Part I',
            partTitle: 'Encounter',
            subtitle: 'Morning & afternoon',
            accent: AppColors.green,
            icon: Icons.wb_sunny_outlined,
            items: partI,
          ),
          const SizedBox(height: 20),
          _SchedulePartBlock(
            partLabel: 'Part II',
            partTitle: 'Mission',
            subtitle: 'Evening program',
            accent: AppColors.blue,
            icon: Icons.nightlight_round,
            items: partII,
          ),
        ],
      ),
    );
  }
}

class _SchedulePartBlock extends StatelessWidget {
  const _SchedulePartBlock({
    required this.partLabel,
    required this.partTitle,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.items,
  });

  final String partLabel;
  final String partTitle;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final List<ScheduleItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: accent.withValues(alpha: 0.168)),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  accent.withValues(alpha: 0.12),
                  accent.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, color: accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$partLabel — $partTitle',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                                height: 1.25,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${items.length} activities · $subtitle',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.25,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _SchedulePartTile(item: items[i], accent: accent),
        ],
      ],
    );
  }
}

class SchedulePartScreen extends StatelessWidget {
  const SchedulePartScreen({super.key, required this.part});

  final SchedulePartDetail part;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: part.items.length + 1,
        separatorBuilder: (_, index) {
          if (index == 0) return const SizedBox(height: 12);
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return SectionHeader(
              title: part.title,
              subtitle: part.subtitle,
            );
          }
          return _SchedulePartTile(item: part.items[index - 1]);
        },
      ),
    );
  }
}

class _SchedulePartTile extends StatelessWidget {
  const _SchedulePartTile({
    required this.item,
    this.accent = AppColors.primary,
  });

  final ScheduleItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final detailLines = _scheduleDetailLines(item.description);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: accent.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 86,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  item.time,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: accent,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 5, right: 12),
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      height: 1.35,
                    ),
                  ),
                  if (detailLines.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...detailLines.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (detailLines.length > 1) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                line,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _scheduleDetailLines(String? description) {
  if (description == null || description.trim().isEmpty) return const [];
  return description
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .map((line) => line.startsWith('•') ? line.substring(1).trim() : line)
      .toList(growable: false);
}

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key, required this.guidelines});

  final List<ContentSection> guidelines;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const SectionHeader(
            title: 'Guidelines',
            subtitle: 'Dress code, venue rules, and safety for DYD 2026',
          ),
          const SizedBox(height: 12),
          EventGuidelinesView(guidelines: guidelines),
        ],
      ),
    );
  }
}

class CommitteesScreen extends StatelessWidget {
  const CommitteesScreen({super.key, required this.committees});

  final List<CommitteeCluster> committees;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: CommitteesAccordionView(committees: committees),
    );
  }
}
