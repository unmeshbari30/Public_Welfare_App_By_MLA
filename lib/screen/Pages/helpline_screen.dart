import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineScreen extends ConsumerStatefulWidget {
  const HelplineScreen({super.key});

  @override
  ConsumerState<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends ConsumerState<HelplineScreen> {
  Widget getScaffold(HomeState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text("हेल्पलाईन"),
        centerTitle: true,
        backgroundColor: Color(0xFFFBA800),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: 2,
            //   itemBuilder:(context, index) {
            //     return Card(
            //       child: Text("hey"),

            //     );
            //   },

            //   )

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = emergencyContacts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                     leading :Icon(getIconForType(contact['icon']), color: Colors.purple, size: 30,),
                    title: Text(contact['name'] ?? ''),
                    subtitle: Text(contact['number'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.call, color: Colors.green),

                      onPressed: () async {
                        final Uri uri =
                            Uri(scheme: 'tel', path: contact['number']);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Cannot open dialer")),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      )),
    );
  }

  IconData getIconForType(String? type) {
  switch (type) {
    case "emergency":
      return Icons.emergency;
    case "police":
      return Icons.local_police;
    case "fire":
      return Icons.fire_truck;
    case "ambulance":
      return Icons.local_hospital;
    default:
      return Icons.phone;
  }
}


  final List<Map<String, String>> emergencyContacts = [
    {"name": "Emeregency No", "number": "112", "icon": "emergency"},
    {"name": "Police", "number": "100", "icon": "police" },
    {"name": "Fire", "number": "101", "icon": "fire"},
    {"name": "Ambulance", "number": "1091", "icon": "ambulance"},
    // {"name": "Ambulance", "number": "102"},
  ];

  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
        data: (state) {
          return getScaffold(state);
        },
        error: (error, stackTrace) => const Scaffold(
              body: Text("Something Went Wrong"),
            ),
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
