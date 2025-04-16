import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class GrievanceScreen extends ConsumerStatefulWidget {
  const GrievanceScreen({super.key});

  @override
  ConsumerState<GrievanceScreen> createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends ConsumerState<GrievanceScreen> {
  
Widget getScaffold(HomeState state){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFFFBA800),
      automaticallyImplyLeading: true,
      centerTitle: true,
      title: Text("Raise Grievance"),
    ),

    body: SafeArea(child: 
    SingleChildScrollView(
      child: Column(
        children: [
          
        ],
      ),
    )),
  );
}
  
  
  
  
  
  
  
  
  
  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    homeStateAsync.when(
      data: (state) => getScaffold(state), 
      error:  (error, stackTrace) => const Scaffold(
              body: Text("Something Went Wrong"),
            ), 
      loading:  () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));


    return const Placeholder();
  }
}