import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/dyd_logo_modal.dart';
import '../../widgets/dyd_history_modal.dart';
import '../../widgets/dyd_objectives_modal.dart';
import '../../widgets/dyd_image_gallery_modal.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/section_header.dart';

class DydOverviewScreen extends StatelessWidget {
  const DydOverviewScreen({super.key, required this.event});

  final EventContent event;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          SectionHeader(
            title: event.title,
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  fontSize: 18,
                  height: 1.28,
                ),
          ),
          const SizedBox(height: 12),
          MenuCard(
            title: 'History',
            subtitle: '',
            icon: Icons.history_edu,
            color: AppColors.blue,
            variant: MenuCardVariant.prominent,
            onTap: () => showDydHistoryModal(context, event.history),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: 'Objectives',
            subtitle: '',
            icon: Icons.flag_outlined,
            color: AppColors.green,
            variant: MenuCardVariant.prominent,
            onTap: () => showDydObjectivesModal(context, event.objectives),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: 'DYD Logo',
            subtitle: '',
            icon: Icons.image_outlined,
            color: AppColors.yellow,
            variant: MenuCardVariant.prominent,
            imageAsset: dydLogoAsset,
            onTap: () => showDydLogoModal(context),
          ),
          const SizedBox(height: 10),
          MenuCard(
            title: 'Branding',
            subtitle: '',
            icon: Icons.palette_outlined,
            color: AppColors.primary,
            variant: MenuCardVariant.prominent,
            onTap: () => showDydBrandingGalleryModal(context),
          ),
        ],
      ),
    );
  }
}
