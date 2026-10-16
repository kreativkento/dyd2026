import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'app_title_banner.dart';

/// Root tab layout: scrollable cover banner on top, then tab content.
class MainTabScrollView extends StatelessWidget {
  const MainTabScrollView({
    super.key,
    required this.slivers,
  });

  factory MainTabScrollView.list({
    Key? key,
    required List<Widget> children,
    EdgeInsets padding = AppLayout.tabContentPadding,
  }) {
    return MainTabScrollView(
      key: key,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildListDelegate(children),
          ),
        ),
      ],
    );
  }

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: AppTitleBanner()),
        ...slivers,
      ],
    );
  }
}
