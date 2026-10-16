import 'package:flutter/material.dart';

import '../../core/services/content_service.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/section_header.dart';
import '../../widgets/vicariate_parish_accordions.dart';

class VicariatesScreen extends StatelessWidget {
  const VicariatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: FutureBuilder<List<Vicariate>>(
        future: ContentService.instance.vicariates,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final vicariates = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionHeader(
                title: 'Vicariates & Parishes',
                subtitle: VicariateParishAccordionList.summarySubtitle(vicariates),
              ),
              VicariateParishAccordionList(vicariates: vicariates),
            ],
          );
        },
      ),
    );
  }
}
