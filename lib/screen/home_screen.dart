import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:test_app/providers/shared_preferences_provider.dart';
import 'package:test_app/screen/Login_Screens/login_screen.dart';
import 'package:test_app/screen/Pages/achievements_screen.dart';
import 'package:test_app/screen/Pages/grievance_screen.dart';
import 'package:test_app/screen/Pages/helpline_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
        // if (_tabController.index == 1 || _tabController.index == 2)
        //   Positioned.fill(
        //     child: Image.asset(
        //       'lib/assets/bg_image.jpeg',
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // Main UI with transparent Scaffold
        Scaffold(
          // backgroundColor: Colors.transparent, // make Scaffold transparent
          appBar: AppBar(
            centerTitle: true,
            title: Text("Welcome"),
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
                            ref
                                .read(authenticationControllerProvider.notifier)
                                .loggedOut();
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
                      Tab(
                          text: 'Home',
                          icon: Icon(
                            Icons.home,
                            size: 25,
                          )),
                      Tab(text: 'Profile', icon: Icon(Icons.person, size: 30)),
                      Tab(
                          text: 'Contact Us',
                          icon: Icon(Icons.contacts, size: 22)),
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
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Card(
                elevation: 1.5,
                color: Colors.white,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 0.8,
                  children: [
                    buildGridIcon(
                        "lib/assets/Rajesh_Dada.jpg", "राजेश दादा", () {}),
                    buildGridIcon(
                        "lib/assets/Rajesh_Dada.jpg", "तक्रार / विनंती", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrievanceScreen(),
                          ));
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "कामगिरी", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AchievementsScreen(),
                          ));
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "हेल्पलाईन",
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelplineScreen(),
                          ));
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "गॅलरी ", () {
                      print("Gallery pressed");
                    }),
                    buildGridIcon("lib/assets/Rajesh_Dada.jpg", "आगामी उपक्रम",
                        () {
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
                radius: 25,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: ClipOval(
              child: Image.asset(
                "lib/assets/Rajesh_Dada.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 180,
            child: Text(
              'Main Street, City, State\n+91 70xxxxxxx',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          Divider(thickness: 1.4),

          SizedBox(height: 10), // space after divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '''Designed & Developed By
Exaltasoft Solutions
          ''',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              '''Exaltasoft Solutions,  #15A, 4th Floor,
City Vista, Tower A, Fountain Road,
Kharadi, Pune - 411014''',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              'contact@exaltasoft.in',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
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
