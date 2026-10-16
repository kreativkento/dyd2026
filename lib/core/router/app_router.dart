import 'package:go_router/go_router.dart';

import '../../features/directory/diocese_screen.dart';
import '../../features/directory/directory_screen.dart';
import '../../features/directory/vicariates_screen.dart';
import '../../features/emergency/emergency_screen.dart';
import '../../features/event/event_screen.dart';
import '../../features/event/dyd_overview_screen.dart';
import '../../features/event/speakers_guests_screen.dart';
import '../../features/event/venue_map_screen.dart';
import '../../data/youth_group_clusters.dart';
import '../../features/groups/groups_screen.dart';
import '../../features/resources/resources_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../models/content_models.dart';
import '../../widgets/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      redirect: (_, __) => '/event',
    ),

    // Emergency (full-screen, outside main nav)
    GoRoute(
      path: '/emergency',
      builder: (_, __) => const EmergencyScreen(),
      routes: [
        GoRoute(
          path: 'first-aid',
          builder: (_, __) => const FirstAidScreen(),
        ),
        GoRoute(
          path: 'contacts',
          builder: (_, __) => const EmergencyContactsScreen(),
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // Event Details (default tab)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/event',
              builder: (_, __) => const EventScreen(),
              routes: [
                GoRoute(
                  path: 'host-parish',
                  builder: (_, state) => HostParishScreen(
                    hostParish: state.extra! as HostParishContent,
                  ),
                ),
                GoRoute(
                  path: 'dyd',
                  builder: (_, state) => DydOverviewScreen(
                    event: state.extra! as EventContent,
                  ),
                ),
                GoRoute(
                  path: 'history',
                  builder: (_, state) => EventContentDetailScreen(
                    section: state.extra! as ContentSection,
                  ),
                ),
                GoRoute(
                  path: 'map',
                  builder: (_, state) => VenueMapScreen(
                    section: state.extra! as ContentSection,
                  ),
                ),
                GoRoute(
                  path: 'schedule',
                  builder: (_, state) => ScheduleScreen(
                    schedule: state.extra! as List<ScheduleItem>,
                  ),
                  routes: [
                    GoRoute(
                      path: 'part',
                      builder: (_, state) => SchedulePartScreen(
                        part: state.extra! as SchedulePartDetail,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'speakers',
                  builder: (_, __) => const SpeakersGuestsScreen(),
                ),
                GoRoute(
                  path: 'guidelines',
                  builder: (_, state) => GuidelinesScreen(
                    guidelines: state.extra! as List<ContentSection>,
                  ),
                ),
                GoRoute(
                  path: 'committees',
                  builder: (_, state) => CommitteesScreen(
                    committees: state.extra! as List<CommitteeCluster>,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Diocesan Directory
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/directory',
              builder: (_, __) => const DirectoryScreen(),
              routes: [
                GoRoute(
                  path: 'diocese',
                  builder: (_, __) => const DioceseScreen(),
                  routes: [
                    GoRoute(
                      path: 'history',
                      builder: (_, state) => DioceseContentScreen(
                        section: state.extra! as ContentSection,
                      ),
                    ),
                    GoRoute(
                      path: 'mission',
                      builder: (_, state) => DioceseContentScreen(
                        section: state.extra! as ContentSection,
                      ),
                    ),
                    GoRoute(
                      path: 'bishop',
                      builder: (_, state) => DioceseContentScreen(
                        section: state.extra! as ContentSection,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'vicariates',
                  builder: (_, __) => const VicariatesScreen(),
                ),
              ],
            ),
          ],
        ),

        // Resources & Liturgy
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/resources',
              builder: (_, __) => const ResourcesScreen(),
              routes: [
                GoRoute(
                  path: 'prayers',
                  builder: (_, __) => const PrayersScreen(),
                  routes: [
                    GoRoute(
                      path: 'detail',
                      builder: (_, state) => PrayerDetailScreen(
                        prayer: state.extra! as PrayerEntry,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'mass-guide',
                  builder: (_, state) => MassGuideScreen(
                    guide: state.extra! as MassGuideContent,
                  ),
                ),
                GoRoute(
                  path: 'theme-song',
                  builder: (_, state) => ThemeSongScreen(
                    song: state.extra! as ThemeSongContent,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Event Groupings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/groups',
              builder: (_, __) => const GroupsScreen(),
              routes: [
                GoRoute(
                  path: 'assembly',
                  builder: (_, __) => const AssemblyPointsScreen(),
                ),
                GoRoute(
                  path: 'list',
                  builder: (_, __) => const GroupListScreen(),
                ),
                GoRoute(
                  path: 'cluster/:clusterId',
                  builder: (_, state) {
                    final id = state.pathParameters['clusterId']!;
                    final cluster = state.extra as YouthGroupCluster? ??
                        youthGroupClusterById(id);
                    if (cluster == null) {
                      return const GroupListScreen();
                    }
                    return ClusterGroupsScreen(cluster: cluster);
                  },
                ),
                GoRoute(
                  path: ':groupId',
                  builder: (_, state) => GroupMembersScreen(
                    group: state.extra! as YouthGroup,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
