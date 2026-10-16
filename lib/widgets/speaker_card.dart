import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';

class SpeakerCard extends StatefulWidget {
  const SpeakerCard({
    super.key,
    required this.speaker,
    required this.onTap,
  });

  final Speaker speaker;
  final VoidCallback onTap;

  @override
  State<SpeakerCard> createState() => _SpeakerCardState();
}

class _SpeakerCardState extends State<SpeakerCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: AppColors.blue.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color: _hovering
                ? AppColors.blue.withValues(alpha: 0.06)
                : Colors.transparent,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _SpeakerImage(speaker: widget.speaker),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.speaker.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: _hovering ? AppColors.blue : null,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.speaker.topic,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _hovering ? AppColors.blue : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeakerImage extends StatelessWidget {
  const _SpeakerImage({required this.speaker});

  final Speaker speaker;

  @override
  Widget build(BuildContext context) {
    if (speaker.imageAsset != null && speaker.imageAsset!.isNotEmpty) {
      return Image.asset(
        speaker.imageAsset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _SpeakerImagePlaceholder(name: speaker.name),
      );
    }
    return _SpeakerImagePlaceholder(name: speaker.name);
  }
}

class _SpeakerImagePlaceholder extends StatelessWidget {
  const _SpeakerImagePlaceholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.85),
            AppColors.blue.withValues(alpha: 0.75),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

Future<void> showSpeakerDetailModal(BuildContext context, Speaker speaker) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SpeakerDetailSheet(speaker: speaker),
  );
}

class _SpeakerDetailSheet extends StatelessWidget {
  const _SpeakerDetailSheet({required this.speaker});

  final Speaker speaker;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _SpeakerImage(speaker: speaker),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                speaker.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                speaker.topic,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (speaker.bio != null && speaker.bio!.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  speaker.bio!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
