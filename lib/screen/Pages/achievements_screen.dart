import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {

  Widget getScaffold(HomeState state) {
  final List<String> imagePaths = [
    "lib/assets/Rajesh_dada_101.jpeg",
    "lib/assets/Rajesh_dada_103.jpeg",
    "lib/assets/Rajesh_dada_104.jpeg",
    "lib/assets/Rajesh_dada_106.jpeg",
  ];

  return Scaffold(
    appBar: AppBar(
      title: Text("साधनेची यशस्वी वाटचाल"),
      centerTitle: true,
    ),
    body: SafeArea(
      child: ListView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 10, 0),
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    ),
  );
}

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