import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:test_app/providers/shared_preferences_provider.dart';
import 'package:test_app/screen/Login_Screens/login_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int exitCounter = 1;
  late TabController _tabController;
  PageController? _pageController;
  Timer? _timer;
  int _currentPage = 0;

  final List<String> imagePaths = [
    "lib/assets/Rajesh_Dada.jpg",
    "lib/assets/rajeshDada1jpg.jpg",
    "lib/assets/rajeshDada2jpg.jpg",
    "lib/assets/rajeshDada3jpg.jpg",
    "lib/assets/rajeshDada4jpg.jpg"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
     _tabController.addListener(() {
    // Make sure it's a manual tab tap and not swiping event
    if (_tabController.indexIsChanging == false) {
      setState(() {});
    }
  });

    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_pageController != null && _pageController!.hasClients) {
        if (_currentPage < imagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController!.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

//with tab bar 
Widget getScaffold(HomeState state) {
  return Stack(
    children: [
      // Background image behind everything
       if (_tabController.index == 1 || _tabController.index == 2)
      Positioned.fill(
        child: Image.asset(
          'lib/assets/bg_image.jpeg',
          fit: BoxFit.cover,
        ),
      ),
      // Main UI with transparent Scaffold
      Scaffold(
        backgroundColor: Colors.transparent, // make Scaffold transparent
        appBar: AppBar(
          centerTitle: true,
          title: Text("Welcome Aboard"),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFFBA800), // transparent AppBar
          elevation: 0, // optional: remove AppBar shadow
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(homeControllerProvider.notifier).loggedOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (exitCounter == 2) {
              exit(0);
            }
            exitCounter++;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Press back again to exit",
                style: TextStyle(color: Colors.black),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.amberAccent,
            ));
          },
          
          child: Column(
            children: [
             Container(
                color: Colors.white,
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Home', icon: Icon(Icons.home, size: 25,)),
                    Tab(text: 'About', icon: Icon(Icons.info, size: 25)),
                    Tab(text: 'Contact Us', icon: Icon(Icons.contacts, size: 25)),
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              // SizedBox(height: 5),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    tab1Screen(state),
                    tab2Screen(state),
                    tab3Screen(state),
                  ],
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //         // color: Colors.white,
        //         height: 60,
        //         child: TabBar(
        //           controller: _tabController,
        //           tabs: [
        //             Tab(text: 'Home', icon: Icon(Icons.home, size: 25,)),
        //             Tab(text: 'About', icon: Icon(Icons.info, size: 25)),
        //             Tab(text: 'Contact Us', icon: Icon(Icons.contacts, size: 25)),
        //           ],
        //           indicatorSize: TabBarIndicatorSize.tab,
        //         ),
        //       ),
      ),
    ],
  );
}

  Widget tab1Screen(HomeState state) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(

          
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              // width: 220,
              child: Image.asset(
                // "lib/assets/dada_landing_photo.jpeg",
                "lib/assets/hm_img.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Card(
                elevation: 1.5,
                color: Colors.white,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9,
                  children: [
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "Rajesh Dada",
                        () {
                      print("Yanamala Divya");
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "Grievance", () {
                      print("Grievance pressed");
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "Schedules", () {
                      print("Schedules pressed");
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "Achievements", () {
                      print("Achievements pressed");
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "Gallery", () {
                      print("Gallery pressed");
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "Super Six", () {
                      print("Super Six pressed");
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildGridIcon(String assetPath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 6),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 2),
              ),
              padding: EdgeInsets.fromLTRB(2, 6, 2, 6),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(assetPath),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget tab2Screen(HomeState state) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Image.asset(
                imagePaths[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              );
            },
            onPageChanged: (index) {
              _currentPage = index;
            },
          ),
        ),
      ],
    );
  }

  Widget tab3Screen(HomeState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        '''
      
Rajesh Udesingh Padvi, born on May 5, 1969, in Talode, Maharashtra, is a prominent Indian politician affiliated with the Bharatiya Janata Party (BJP). He has been serving as the Member of the Maharashtra Legislative Assembly from the Shahada constituency since 2019 and was re-elected in the 2024 elections .

In 2024, Padvi secured a significant development fund of ₹91 crore for the Shahada-Taloda constituency, with ₹50 crore allocated from the tribal welfare department and ₹41 crore from the non-tribal sector. This funding aims to enhance infrastructure, including road construction, bridge building, and water supply improvements .

Additionally, he facilitated a ₹10 crore grant under a special scheme for the Shahada and Taloda municipal councils. This grant supports the construction of community halls for various social groups, road development, and other civic projects .

Padvi's dedication to his constituency is evident through his continuous efforts to address local issues and improve the quality of life for his constituents. His leadership reflects a commitment to inclusive development and responsive governance.
      ''',
        style: TextStyle(fontSize: 16.0),
        textAlign: TextAlign.justify,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var asyncHomeState = ref.watch(homeControllerProvider);

    return asyncHomeState.when(
        data: (homeState) {
          return getScaffold(homeState);
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
