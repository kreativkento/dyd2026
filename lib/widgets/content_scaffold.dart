import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'app_page_scaffold.dart';

class ContentScaffold extends StatelessWidget {
  const ContentScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final String body;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
          ),
          if (leading != null) ...[
            const SizedBox(height: 20),
            leading!,
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
