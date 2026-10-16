import 'package:flutter/material.dart';

import '../../core/services/content_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/content_scaffold.dart';
import '../../widgets/host_parish_modals.dart';
import '../../widgets/section_header.dart';
import '../../widgets/menu_card.dart';

class DioceseScreen extends StatelessWidget {
  const DioceseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DioceseContent>(
      future: ContentService.instance.diocese,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageScaffold(body: LoadingView());
        }
        final data = snapshot.data!;
        return AppPageScaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionHeader(title: data.name, subtitle: 'Diocesan information'),
              ...dioceseContentMenuCards(context, data),
            ],
          ),
        );
      },
    );
  }
}

/// History, mission, and optional bishop message (Directory tab and Diocese route).
List<Widget> dioceseContentMenuCards(
  BuildContext context,
  DioceseContent data, {
  MenuCardVariant variant = MenuCardVariant.standard,
  double spacing = 12,
  bool showBishopMessage = true,
  bool historyMissionSideBySide = false,
}) {
  Widget gap() => SizedBox(height: spacing);

  final sideVariant = historyMissionSideBySide
      ? (variant == MenuCardVariant.prominent
          ? MenuCardVariant.prominent
          : MenuCardVariant.halfCompactRow)
      : variant;

  if (historyMissionSideBySide) {
    final widgets = <Widget>[
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: MenuCard(
                title: data.history.title,
                subtitle: '',
                icon: Icons.history_edu,
                color: sideVariant == MenuCardVariant.prominent
                    ? AppColors.blue
                    : null,
                variant: sideVariant,
                onTap: () => showContentSectionModal(context, data.history),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: MenuCard(
                title: data.mission.title,
                subtitle: '',
                icon: Icons.flag_outlined,
                color: sideVariant == MenuCardVariant.prominent
                    ? AppColors.green
                    : null,
                variant: sideVariant,
                onTap: () => showContentSectionModal(context, data.mission),
              ),
            ),
          ],
        ),
      ),
    ];
    if (showBishopMessage && data.bishopMessage != null) {
      final message = data.bishopMessage!;
      widgets.addAll([
        gap(),
        MenuCard(
          title: "Bishop's Message",
          subtitle: message.subtitle ?? 'Message from the bishop',
          icon: Icons.mail,
          color: variant == MenuCardVariant.prominent ? AppColors.primary : null,
          variant: variant,
          onTap: () => showParishOfficialMessageModal(context, message),
        ),
      ]);
    }
    return widgets;
  }

  final useProminentAccents = variant == MenuCardVariant.prominent;

  return [
    MenuCard(
      title: data.history.title,
      subtitle: variant == MenuCardVariant.directoryCompact
          ? ''
          : 'Learn about our diocese',
      icon: Icons.history_edu,
      color: useProminentAccents ? AppColors.blue : null,
      variant: variant,
      onTap: () => showContentSectionModal(context, data.history),
    ),
    gap(),
    MenuCard(
      title: data.mission.title,
      subtitle:
          variant == MenuCardVariant.directoryCompact ? '' : 'Our pastoral direction',
      icon: Icons.flag,
      color: useProminentAccents ? AppColors.green : null,
      variant: variant,
      onTap: () => showContentSectionModal(context, data.mission),
    ),
    if (showBishopMessage && data.bishopMessage != null) ...[
      gap(),
      MenuCard(
        title: "Bishop's Message",
        subtitle: data.bishopMessage!.subtitle ?? 'Message from the bishop',
        icon: Icons.mail,
        color: useProminentAccents ? AppColors.primary : null,
        variant: variant,
        onTap: () => showParishOfficialMessageModal(
          context,
          data.bishopMessage!,
        ),
      ),
    ],
  ];
}

/// Diocesan youth ministry message buttons (Directory tab).
List<Widget> dioceseYouthMessageMenuCards(
  BuildContext context,
  DioceseContent data, {
  double spacing = 10,
}) {
  Widget gap() => SizedBox(height: spacing);

  final entries = [
    (
      title: "Youth Director's Message",
      section: data.youthDirectorMessage,
      icon: Icons.record_voice_over_outlined,
    ),
    (
      title: "Asst. Youth Director's Message",
      section: data.assistantYouthDirectorMessage,
      icon: Icons.person_2_outlined,
    ),
    (
      title: "Diocesan Youth Coordinator's Message",
      section: data.diocesanYouthCoordinatorMessage,
      icon: Icons.supervisor_account_outlined,
    ),
    (
      title: "Diocesan Youth Leader's Message",
      section: data.diocesanYouthLeaderMessage,
      icon: Icons.emoji_people_outlined,
    ),
  ];

  final widgets = <Widget>[];
  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    if (i > 0) widgets.add(gap());
    final section = entry.section;
    final photo = section.imageAsset?.trim();
    widgets.add(
      MenuCard(
        title: entry.title,
        subtitle: section.subtitle ?? '',
        icon: entry.icon,
        imageAsset: (photo != null && photo.isNotEmpty) ? photo : null,
        color: AppColors.green,
        variant: MenuCardVariant.prominent,
        onTap: () => showParishOfficialMessageModal(context, section),
      ),
    );
  }
  return widgets;
}

class DioceseContentScreen extends StatelessWidget {
  const DioceseContentScreen({super.key, required this.section});

  final ContentSection section;

  @override
  Widget build(BuildContext context) {
    return ContentScaffold(
      title: section.title,
      subtitle: section.subtitle,
      body: section.body,
    );
  }
}
