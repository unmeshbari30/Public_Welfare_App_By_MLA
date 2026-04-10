import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rajesh_dada_padvi/controllers/home_controller.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineScreen extends ConsumerStatefulWidget {
  const HelplineScreen({super.key});

  @override
  ConsumerState<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends ConsumerState<HelplineScreen> {
  Widget getScaffold(HomeState state) {
    final theme = Theme.of(context);

    return AppPageFrame(
      title: 'हेल्पलाइन',
      subtitle: 'Important local support and emergency contacts.',
      icon: Icons.support_agent_rounded,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: emergencyContacts.length,
        itemBuilder: (context, index) {
          final contact = emergencyContacts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    getIconForType(contact['icon']),
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name'] ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(contact['number'] ?? ''),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call_rounded),
                  onPressed: () async {
                    final Uri uri = Uri(scheme: 'tel', path: contact['number']);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData getIconForType(String? type) {
    switch (type) {
      case 'emergency':
        return Icons.emergency_rounded;
      case 'police':
        return Icons.local_police_rounded;
      case 'fire':
        return Icons.fire_truck_rounded;
      case 'ambulance':
        return Icons.local_hospital_rounded;
      case 'tehsil':
        return Icons.apartment_rounded;
      default:
        return Icons.phone_rounded;
    }
  }

  final List<Map<String, String>> emergencyContacts = [
    {'name': 'Taloda Ambulance', 'number': '9372079397', 'icon': 'ambulance'},
    {'name': 'Shahada Ambulance', 'number': '9096971535', 'icon': 'ambulance'},
    {'name': 'Taloda Police', 'number': '9764287587', 'icon': 'police'},
    {'name': 'Shahada Police', 'number': '8380911028', 'icon': 'police'},
    {'name': 'Taloda Tehsil Office', 'number': '9764287587', 'icon': 'tehsil'},
    {
      'name': 'Shahada Tehsil (Hemraj Pawar)',
      'number': '9096971535',
      'icon': 'tehsil',
    },
    {
      'name': 'PMAY घरकुल (Kiran Suryawanshi)',
      'number': '9764287587',
      'icon': 'tehsil',
    },
    {
      'name': 'PHC Centre /SDH Hospital Taloda',
      'number': '8381056451',
      'icon': 'tehsil',
    },
    {
      'name': 'Borad PHC (Ravin Bhau)',
      'number': '9834525343',
      'icon': 'tehsil',
    },
    {
      'name': 'Masavad PHC (Sachin Pawara)',
      'number': '8888133897',
      'icon': 'tehsil',
    },
    {
      'name': 'Shahada Water Supply & Fire',
      'number': '9763342959',
      'icon': 'fire',
    },
    {'name': 'Taloda Fire Brigade', 'number': '8484028386', 'icon': 'fire'},
  ];

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) =>
          const Scaffold(body: Center(child: Text('Something Went Wrong'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
