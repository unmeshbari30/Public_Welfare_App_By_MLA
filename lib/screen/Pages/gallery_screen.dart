import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {

  Widget getScaffold(HomeState state){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("गॅलरी"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Center(
                child: Text("To be updated soon...", style:  TextStyle(fontSize: 22),),
              )

            ],
          ),
        )
      ),
    );

  }

  
  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
      data: (state) => getScaffold(state), 
      error:  (error, stackTrace) => const Scaffold(
              body: Text("Something Went Wrong"),
            ), 
      loading:  () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}