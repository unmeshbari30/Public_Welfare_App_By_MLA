import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {

  Widget getScaffold(HomeState state){
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ListView.builder(
              //   itemCount: 4,
              //   itemBuilder: (context, index) {
              //     return ListTile(
                    
              //     );
              //   },)
              ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                // final contact = emergencyContacts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  // child: ListTile(
                  //   //  leading :Icon(getIconForType(contact['icon']), color: Colors.purple, size: 30,),
                  //   title: Text("U" ?? ''),
                  //   subtitle: Text(contact['number'] ?? ''),
                  //   trailing: IconButton(
                  //     icon: Icon(Icons.call, color: Colors.green),

                  //     onPressed: () async {
                        
                  //     },
                  //   ),
                  // ),
                );
              },
            )
          
            ],
          ),
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