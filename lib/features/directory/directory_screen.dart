import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/content_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/content_models.dart';
import '../../widgets/main_tab_scroll_view.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/section_header.dart';
import 'diocese_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  static const _directoryTabIndex = 1;

  late Future<DioceseContent> _pageFuture;
  int? _lastNavigationShellIndex;

  @override
  void initState() {
    super.initState();
    _pageFuture = ContentService.instance.diocese;
  }

  void _reloadWhenTabSelected() {
    final shell = StatefulNavigationShell.maybeOf(context);
    final index = shell?.currentIndex;
    if (index == null) return;

    if (index == _directoryTabIndex && _lastNavigationShellIndex != _directoryTabIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _pageFuture = ContentService.instance.diocese;
          _lastNavigationShellIndex = _directoryTabIndex;
        });
      });
    } else {
      _lastNavigationShellIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    _reloadWhenTabSelected();

    return Scaffold(
      body: FutureBuilder<DioceseContent>(
        future: _pageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MainTabScrollView(
              slivers: [
                SliverFillRemaining(child: LoadingView()),
              ],
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return MainTabScrollView.list(
              children: [
                SectionHeader(
                  title: 'Directory unavailable',
                  subtitle: 'Could not load diocese data. Try restarting the app.',
                ),
              ],
            );
          }

          final diocese = snapshot.data!;
          return MainTabScrollView.list(
            children: [
              SectionHeader(
                title: 'The Diocese of Catarman',
                subtitle:
                    '"Fostering faith, hope, and community service throughout the parishes of Northern Samar since 1974"',
                subtitleStyle: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
              ...dioceseContentMenuCards(
                context,
                diocese,
                variant: MenuCardVariant.prominent,
                spacing: 8,
                showBishopMessage: false,
                historyMissionSideBySide: true,
              ),
              const SizedBox(height: 16),
              ...dioceseYouthMessageMenuCards(context, diocese),
              const SizedBox(height: 12),
              MenuCard(
                title: 'Vicariates & Parishes',
                subtitle: 'Browse vicariates and parish listings',
                icon: Icons.church_outlined,
                color: AppColors.blue,
                variant: MenuCardVariant.prominent,
                onTap: () => context.push('/directory/vicariates'),
              ),
            ],
          );
        },
      ),
    );
  }
}
