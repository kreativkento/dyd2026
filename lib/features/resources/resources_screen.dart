import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/content_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/content_scaffold.dart';
import '../../widgets/liturgy_reading_accordion.dart';
import '../../widgets/main_tab_scroll_view.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/theme_song_view.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ResourcesContent>(
        future: ContentService.instance.resources,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MainTabScrollView(
              slivers: [
                SliverFillRemaining(child: LoadingView()),
              ],
            );
          }

          final data = snapshot.data!;
          final guide = data.massGuide;
          final song = data.themeSong;

          return MainTabScrollView.list(
            padding: const EdgeInsets.fromLTRB(
              AppLayout.tabHorizontalPadding,
              14,
              AppLayout.tabHorizontalPadding,
              AppLayout.tabHorizontalPadding,
            ),
            children: [
              MenuCard(
                title: song.title,
                subtitle: 'Jn 16:33 — Take courage',
                icon: Icons.music_note_rounded,
                color: AppColors.yellow,
                variant: MenuCardVariant.prominent,
                onTap: () =>
                    context.push('/resources/theme-song', extra: song),
              ),
              const SizedBox(height: 10),
              MenuCard(
                title: guide.title,
                subtitle: guide.subtitle ?? 'Readings for the celebration',
                icon: Icons.menu_book_rounded,
                color: AppColors.green,
                variant: MenuCardVariant.prominent,
                onTap: () =>
                    context.push('/resources/mass-guide', extra: guide),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ThemeSongScreen extends StatelessWidget {
  const ThemeSongScreen({super.key, required this.song});

  final ThemeSongContent song;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          SectionHeader(title: song.title),
          const SizedBox(height: 8),
          ThemeSongView(song: song),
        ],
      ),
    );
  }
}

class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SectionHeader(title: 'Mass Guide'),
        ],
      ),
    );
  }
}

class PrayerDetailScreen extends StatelessWidget {
  const PrayerDetailScreen({super.key, required this.prayer});

  final PrayerEntry prayer;

  @override
  Widget build(BuildContext context) {
    return ContentScaffold(
      title: prayer.title,
      subtitle: prayer.category,
      body: prayer.content,
    );
  }
}

class MassGuideScreen extends StatelessWidget {
  const MassGuideScreen({super.key, required this.guide});

  final MassGuideContent guide;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          SectionHeader(title: guide.title, subtitle: guide.subtitle),
          const SizedBox(height: 12),
          if (guide.readings.isNotEmpty)
            LiturgyReadingAccordionList(readings: guide.readings)
          else if (guide.body.isNotEmpty)
            Text(
              guide.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
            ),
        ],
      ),
    );
  }
}
