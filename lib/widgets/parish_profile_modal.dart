import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../data/parish_image_assets.dart';
import '../models/content_models.dart';

Future<void> showParishProfileModal(
  BuildContext context,
  Parish parish, {
  String? vicariateDisplayName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ParishProfileSheet(
      parish: parish,
      vicariateDisplayName: vicariateDisplayName,
    ),
  );
}

class _ParishProfileSheet extends StatelessWidget {
  const _ParishProfileSheet({
    required this.parish,
    this.vicariateDisplayName,
  });

  final Parish parish;
  final String? vicariateDisplayName;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottomInset),
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  child: _ParishImage(parish: parish),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (parish.pastorLabel != null)
                      _ProfileRow(
                        label: parish.clergyRoleLabel,
                        value: parish.pastorLabel!,
                      ),
                    if (parish.address.isNotEmpty)
                      _ProfileRow(label: 'Address', value: parish.address),
                    if (parish.diocese != null)
                      _ProfileRow(
                        label: 'Archdiocese | Diocese',
                        value: parish.diocese!,
                      ),
                    if (vicariateDisplayName != null ||
                        parish.vicariate != null)
                      _ProfileRow(
                        label: 'Vicariate',
                        value: vicariateDisplayName ?? parish.vicariate!,
                      ),
                    if (parish.established != null)
                      _ProfileRow(
                        label: 'Established',
                        value: parish.established!,
                      ),
                    if (parish.feastDate != null)
                      _ProfileRow(
                        label: 'Feast Date',
                        value: parish.feastDate!,
                      ),
                    if (parish.contact != null)
                      _ProfileRow(label: 'Contact', value: parish.contact!),
                  ],
                ),
              ),
              if (parish.description != null &&
                  parish.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.2,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  parish.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13.5,
                        height: 1.45,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
              if (parish.delegates.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Delegates',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.2,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 6),
                ...parish.delegates.map(
                  (delegate) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person_outline,
                            size: 14,
                            color: AppColors.primary.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                delegate.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                  height: 1.25,
                                ),
                              ),
                              if (delegate.role != null ||
                                  delegate.contact != null)
                                Text(
                                  [
                                    if (delegate.role != null) delegate.role,
                                    if (delegate.contact != null)
                                      delegate.contact,
                                  ].join(' • '),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11.5,
                                    height: 1.25,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

class _ParishImage extends StatelessWidget {
  const _ParishImage({required this.parish});

  final Parish parish;

  static final _assetExistsCache = <String, bool>{};

  static Future<bool> _assetExists(String assetPath) async {
    final cached = _assetExistsCache[assetPath];
    if (cached != null) return cached;
    try {
      await rootBundle.load(assetPath);
      _assetExistsCache[assetPath] = true;
      return true;
    } catch (_) {
      _assetExistsCache[assetPath] = false;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = parishProfileImageAsset(parish);
    if (assetPath == null || assetPath.isEmpty) {
      return const _ParishImagePlaceholder(
        message: 'No parish photo assigned',
      );
    }

    return FutureBuilder<bool>(
      future: _assetExists(assetPath),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.asset(
            assetPath,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            width: double.infinity,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => _ParishImagePlaceholder(
              message: 'No parish photo assigned',
              expectedFile: parishImageFileNameFromPlaceName(
                parishAddressPlaceName(parish.address),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            width: double.infinity,
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _ParishImagePlaceholder(
          message: 'No parish photo assigned',
          expectedFile: parishImageFileNameFromPlaceName(
            parishAddressPlaceName(parish.address),
          ),
        );
      },
    );
  }
}

class _ParishImagePlaceholder extends StatelessWidget {
  const _ParishImagePlaceholder({
    this.message = 'No parish photo assigned',
    this.expectedFile,
  });

  final String message;
  final String? expectedFile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: DecoratedBox(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.church,
                  size: 40,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                if (expectedFile != null && expectedFile!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Expected: assets/images/parishes/$expectedFile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  height: 1.15,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }
}
