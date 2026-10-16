import 'package:flutter/material.dart';

import '../../core/services/content_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/section_header.dart';
import '../../widgets/speakers_guest_modals.dart';

class SpeakersGuestsScreen extends StatelessWidget {
  const SpeakersGuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: FutureBuilder<SpeakersGuestsContent>(
        future: ContentService.instance.speakersGuests,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Could not load speakers and guests.'));
          }

          final content = snapshot.data!;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SectionHeader(
                    title: 'Speakers & Guests',
                    subtitle: 'Meet our esteemed event speakers and guests',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: _PlenarySpeakerCard(speaker: content.speaker),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: _KaKwentuhanSection(
                    participants: content.participants,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlenarySpeakerCard extends StatelessWidget {
  const _PlenarySpeakerCard({required this.speaker});

  final PlenarySpeakerProfile speaker;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showPlenarySpeakerModal(context, speaker),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.blue.withValues(alpha: 0.12),
                AppColors.blue.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(
              color: AppColors.blue.withValues(alpha: 0.22),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    SpeakersGuestAssets.cardPortrait,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: AppColors.blue.withValues(alpha: 0.08),
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.blue.withValues(alpha: 0.5),
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        speaker.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      if (speaker.credentials.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          speaker.credentials,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                        ),
                      ],
                      if (speaker.role.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          speaker.role,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.blue.withValues(alpha: 0.65),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KaKwentuhanSection extends StatelessWidget {
  const _KaKwentuhanSection({required this.participants});

  final List<EventGuestParticipant> participants;

  EventGuestParticipant? _participantForIndex(int index) {
    if (index < 0 || index >= participants.length) return null;
    return participants[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your Ka-Kwentuhan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
              ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 10,
            childAspectRatio: 0.92,
          ),
          itemCount: SpeakersGuestAssets.kaKwentuhanSlugs.length,
          itemBuilder: (context, index) {
            final slug = SpeakersGuestAssets.kaKwentuhanSlugs[index];
            final asset = SpeakersGuestAssets.kkAssetForSlug(slug);
            final participant = _participantForIndex(index);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: participant == null
                    ? null
                    : () => showKaKwentuhanGuestPosterModal(
                          context,
                          participant: participant,
                          slug: slug,
                        ),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.blue.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
