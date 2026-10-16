import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('DYD 2026'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24, bottom: 56),
                    child: Icon(
                      Icons.church,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: OfflineBanner()),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Main Dashboard',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Everything you need for Diocese Youth Day — no internet required.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 20),
                MenuCard(
                  title: 'Diocesan Directory',
                  subtitle: 'Diocese, vicariates, parishes & delegates',
                  icon: Icons.account_balance,
                  onTap: () => context.push('/directory'),
                ),
                const SizedBox(height: 12),
                MenuCard(
                  title: 'Resources & Liturgy',
                  subtitle: 'Theme song, chants, prayers & mass guide',
                  icon: Icons.menu_book,
                  onTap: () => context.push('/resources'),
                ),
                const SizedBox(height: 12),
                MenuCard(
                  title: 'Emergency & Help',
                  subtitle: 'First aid info & emergency contacts',
                  icon: Icons.emergency,
                  color: AppColors.emergency,
                  onTap: () => context.push('/emergency'),
                ),
                const SizedBox(height: 12),
                MenuCard(
                  title: 'Event Groupings',
                  subtitle: 'Assembly points, clusters & members',
                  icon: Icons.groups,
                  onTap: () => context.push('/groups'),
                ),
                const SizedBox(height: 12),
                MenuCard(
                  title: 'Event Details',
                  subtitle: 'Schedule, speakers, host parish & committees',
                  icon: Icons.event,
                  onTap: () => context.push('/event'),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
