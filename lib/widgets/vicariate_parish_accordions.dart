import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/parish_image_assets.dart';
import '../data/vicariate_display.dart';
import '../models/content_models.dart';
import 'parish_profile_modal.dart';

/// Vicariate expansion tiles with tappable parish rows (from [vicariates.json]).
class VicariateParishAccordionList extends StatelessWidget {
  const VicariateParishAccordionList({
    super.key,
    required this.vicariates,
  });

  final List<Vicariate> vicariates;

  static String summarySubtitle(List<Vicariate> vicariates) {
    final parishCount =
        vicariates.fold<int>(0, (sum, v) => sum + v.parishes.length);
    final vCount = vicariates.length;
    return '$vCount vicariate${vCount == 1 ? '' : 's'} · '
        '$parishCount parish${parishCount == 1 ? '' : 'es'}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final vicariate in vicariates)
          VicariateParishAccordion(
            key: ValueKey('${vicariate.id}|${vicariate.name}'),
            vicariate: vicariate,
          ),
      ],
    );
  }
}

class VicariateParishAccordion extends StatelessWidget {
  const VicariateParishAccordion({super.key, required this.vicariate});

  final Vicariate vicariate;

  @override
  Widget build(BuildContext context) {
    final count = vicariate.parishes.length;
    final parishLabel = count == 0
        ? 'Parishes coming soon'
        : '$count parish${count == 1 ? '' : 'es'}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.trailing,
          tilePadding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.church_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vicariateAccordionTitle(vicariate),
                      softWrap: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      parishLabel,
                      softWrap: true,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            if (vicariate.parishes.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Text(
                  'Parish list for this vicariate will be added soon.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                ),
              )
            else
              ...vicariate.parishes.map(
                (parish) => ParishAccordionRow(
                  parish: parish,
                  parishesInVicariate: vicariate.parishes,
                  vicariateDisplayName: vicariateAccordionTitle(vicariate),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ParishAccordionRow extends StatelessWidget {
  const ParishAccordionRow({
    super.key,
    required this.parish,
    required this.parishesInVicariate,
    this.vicariateDisplayName,
  });

  final Parish parish;
  final List<Parish> parishesInVicariate;

  /// Full vicariate title from JSON (e.g. "Vicariate of St. Joseph").
  final String? vicariateDisplayName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showParishProfileModal(
          context,
          parish,
          vicariateDisplayName: vicariateDisplayName,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 7, 6, 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.blue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      parishAccordionPrimaryLabel(
                        parish,
                        parishesInVicariate,
                      ),
                      softWrap: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.25,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (parishAccordionShowPlaceSubtitle(
                      parish,
                      parishesInVicariate,
                    )) ...[
                      const SizedBox(height: 4),
                      Text(
                        parishAddressPlaceName(parish.address),
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 10.5,
                          height: 1.25,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.info_outline,
                  size: 17,
                  color: AppColors.textSecondary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
