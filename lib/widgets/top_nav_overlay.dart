import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/services/content_service.dart';
import '../core/theme/app_theme.dart';
import '../models/content_models.dart';
import 'emergency_contacts_list.dart';
import 'section_banner.dart';

/// Floating top navigation over the banner: back (when available) and emergency.
class TopNavOverlay extends StatelessWidget {
  const TopNavOverlay({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _buttonSize = 40.0;

  static const _branchRoots = [
    '/event',
    '/directory',
    '/resources',
    '/groups',
  ];

  bool _branchCanPop(BuildContext context) {
    final index = navigationShell.currentIndex;
    if (index < 0 || index >= _branchRoots.length) return false;

    final location = GoRouterState.of(context).uri.path;
    final root = _branchRoots[index];
    return location != root && location.startsWith('$root/');
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return ListenableBuilder(
      listenable: router.routerDelegate,
      builder: (context, _) {
        final topInset = MediaQuery.paddingOf(context).top;
        final canPop = _branchCanPop(context);

        return SizedBox(
          height: topInset + _buttonSize + 12,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, topInset + 6, 8, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (canPop)
                  _OverlayNavButton(
                    icon: CupertinoIcons.back,
                    iconColor: Colors.white,
                    onTap: () => context.pop(),
                  )
                else
                  const SizedBox(width: _buttonSize),
                const Spacer(),
                _OverlayNavButton(
                  icon: Icons.emergency,
                  iconColor: AppColors.yellow,
                  onTap: () => showEmergencyContactsModal(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OverlayNavButton extends StatefulWidget {
  const _OverlayNavButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  State<_OverlayNavButton> createState() => _OverlayNavButtonState();
}

class _OverlayNavButtonState extends State<_OverlayNavButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: _hovering
            ? AppColors.blue.withValues(alpha: 0.75)
            : Colors.black.withValues(alpha: 0.38),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: TopNavOverlay._buttonSize,
            height: TopNavOverlay._buttonSize,
            child: Icon(
              widget.icon,
              color: _hovering ? Colors.white : widget.iconColor,
              size: widget.icon == CupertinoIcons.back ? 24 : 22,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showEmergencyContactsModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _EmergencyContactsSheet(),
  );
}

class _EmergencyContactsSheet extends StatelessWidget {
  const _EmergencyContactsSheet();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    const sheetPadding = EdgeInsets.fromLTRB(18, 10, 18, 0);

    return DraggableScrollableSheet(
      initialChildSize: 0.76,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FutureBuilder<EmergencyContent>(
            future: ContentService.instance.emergency,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final contacts = snapshot.data!.contacts;

              return ListView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  sheetPadding.left,
                  sheetPadding.top,
                  sheetPadding.right,
                  18 + bottomInset,
                ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emergency_outlined,
                        color: AppColors.emergency.withValues(alpha: 0.85),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Emergency Contacts',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    height: 1.25,
                                    color: AppColors.textPrimary,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    height: 24,
                    color: AppColors.textSecondary.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 6),
                  EmergencyContactsList(
                    contacts: contacts,
                    compact: true,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

/// @deprecated Back navigation is handled by [TopNavOverlay] in the app shell.
class IosBackButton extends StatelessWidget {
  const IosBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Page shell for detail routes. Top navigation lives in [TopNavOverlay].
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.body,
    this.showBack,
    this.includeSectionBanner = true,
  });

  final Widget body;
  final bool? showBack;
  final bool includeSectionBanner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: includeSectionBanner
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionBanner(),
                Expanded(child: body),
              ],
            )
          : body,
    );
  }
}
