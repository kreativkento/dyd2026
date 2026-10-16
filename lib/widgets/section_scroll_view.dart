import 'package:flutter/material.dart';

import 'section_banner.dart';

/// Subsection layout: compact banner on top, then scrollable page content.
class SectionScrollView extends StatelessWidget {
  const SectionScrollView({
    super.key,
    required this.slivers,
  });

  factory SectionScrollView.list({
    Key? key,
    required List<Widget> children,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return SectionScrollView(
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
        const SliverToBoxAdapter(child: SectionBanner()),
        ...slivers,
      ],
    );
  }
}
