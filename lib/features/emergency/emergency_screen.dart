import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/content_service.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/emergency_contacts_list.dart';
import '../../widgets/section_header.dart';
import '../../widgets/menu_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(
            title: 'Safety & Assistance',
            subtitle: 'First aid info and emergency contacts',
          ),
          MenuCard(
            title: 'First Aid / Medical Info',
            subtitle: 'Basic first aid procedures',
            icon: Icons.medical_services,
            color: const Color(0xFFC0392B),
            onTap: () => context.push('/emergency/first-aid'),
          ),
          const SizedBox(height: 12),
          MenuCard(
            title: 'Local Emergency Contacts',
            subtitle: 'MDRRMO, police, fire, health & provincial backup',
            icon: Icons.phone_in_talk,
            color: const Color(0xFFC0392B),
            onTap: () => context.push('/emergency/contacts'),
          ),
        ],
      ),
    );
  }
}

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: FutureBuilder<EmergencyContent>(
        future: ContentService.instance.emergency,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final sections = snapshot.data!.firstAid;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sections.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: SectionHeader(
                    title: 'First Aid',
                    subtitle: 'Medical information',
                  ),
                );
              }
              final section = sections[index - 1];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: const Icon(Icons.healing, color: Color(0xFFC0392B)),
                  title: Text(
                    section.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        section.body,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: FutureBuilder<EmergencyContent>(
        future: ContentService.instance.emergency,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final contacts = snapshot.data!.contacts;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(
                title: 'Emergency Contacts',
                subtitle: 'Local hotlines and provincial backup numbers',
              ),
              EmergencyContactsList(contacts: contacts),
            ],
          );
        },
      ),
    );
  }
}
