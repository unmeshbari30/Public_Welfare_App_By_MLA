import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:test_app/controllers/Admin/grievance_controller.dart';

class AdminGrievanceScreen extends ConsumerStatefulWidget {
  const AdminGrievanceScreen({super.key});

  @override
  ConsumerState<AdminGrievanceScreen> createState() => _AdminGrievanceScreenState();
}

String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd-MM-yyyy hh:mm a').format(date);
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

           Padding(
  padding: const EdgeInsets.all(8.0),
  child: ListView.builder(
    shrinkWrap: true, // <-- Add this
    physics: NeverScrollableScrollPhysics(), // <-- Prevent nested scrolling
    itemCount: state.complaintsList?.complaints?.length ?? 0,
    itemBuilder: (context, index) {
      final complaint = state.complaintsList?.complaints?[index];
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${complaint?.fullName ?? 'N/A'}", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text("Mobile: ${complaint?.mobileNumber ?? 'N/A'}"),
              Text("Tehsil: ${complaint?.tehsil ?? 'N/A'}"),
              Text("Gender: ${complaint?.gender ?? 'N/A'}"),
              Text("Address: ${complaint?.address ?? 'N/A'}"),
              Text("Message: ${complaint?.yourMessage ?? 'N/A'}"),
              Text("Created At: ${formatDate(complaint?.createdAt)}"),
            ],
          ),
        ),
      );
    },
  ),
),


            
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