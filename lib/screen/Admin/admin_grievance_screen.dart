import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/Admin/grievance_controller.dart';

class AdminGrievanceScreen extends ConsumerStatefulWidget {
  const AdminGrievanceScreen({super.key});

  @override
  ConsumerState<AdminGrievanceScreen> createState() => _AdminGrievanceScreenState();
}

Widget getScaffold(GrievanceState state){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.amber,

    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [

            
            
          ],
        ),
      ),
    ),

  );
  
}

class _AdminGrievanceScreenState extends ConsumerState<AdminGrievanceScreen> {
  @override
  Widget build(BuildContext context) {
     var grievanceState = ref.watch(grievanceControllerProvider);
    return grievanceState.when(
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