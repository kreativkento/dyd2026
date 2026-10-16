import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import 'pwa_install_banner.dart';
import 'top_nav_overlay.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                navigationShell,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: TopNavOverlay(navigationShell: navigationShell),
                ),
              ],
            ),
          ),
          const PwaInstallBanner(),
        ],
      ),
      bottomNavigationBar: _MainNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class _MainNavBar extends StatelessWidget {
  const _MainNavBar({
    required this.currentIndex,
    required this.onTabSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  static const _barHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: _barHeight + bottomInset,
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.event_note_outlined,
                  selectedIcon: Icons.event_note,
                  label: 'Event',
                  isSelected: currentIndex == 0,
                  onTap: () => onTabSelected(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.church_outlined,
                  selectedIcon: Icons.church,
                  label: 'Directory',
                  isSelected: currentIndex == 1,
                  onTap: () => onTabSelected(1),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.menu_book_outlined,
                  selectedIcon: Icons.menu_book,
                  label: 'Liturgy',
                  isSelected: currentIndex == 2,
                  onTap: () => onTabSelected(2),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.groups_outlined,
                  selectedIcon: Icons.groups,
                  label: 'Groups',
                  isSelected: currentIndex == 3,
                  onTap: () => onTabSelected(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? AppColors.green
        : _hovering
            ? AppColors.blue
            : AppColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: widget.isSelected
            ? AppColors.green.withValues(alpha: 0.08)
            : AppColors.blue.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isSelected ? widget.selectedIcon : widget.icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
