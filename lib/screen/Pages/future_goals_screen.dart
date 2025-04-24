import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class FutureGoalsScreen extends ConsumerStatefulWidget {
  const FutureGoalsScreen({super.key});

  @override
  ConsumerState<FutureGoalsScreen> createState() => _FutureGoalsScreenState();
}

class _FutureGoalsScreenState extends ConsumerState<FutureGoalsScreen> {
  Widget getScaffold(HomeState state) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("आगामी उपक्रम"),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),

            Center(
                child: Text("To be updated soon...", style:  TextStyle(fontSize: 22),),
              )

          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
        data: (state) => getScaffold(state),
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
