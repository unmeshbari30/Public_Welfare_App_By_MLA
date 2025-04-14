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


  Widget getScaffold(HomeState state) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome Aboard"),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: Scaffold.of(context).openDrawer,
                icon: Icon(Icons.menu));
          },
        ),
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
              Navigator.of(context).pop(); // close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close the dialog\
              ref.read(homeControllerProvider.notifier).loggedOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  },
  icon: Icon(Icons.logout),
)

        ],
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: 'Home', icon: Icon(Icons.home)),
          Tab(text: 'About', icon: Icon(Icons.info)),
          Tab(text: 'Contact Us', icon: Icon(Icons.contacts)),
        ]),
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
          child: TabBarView(controller: _tabController, children: [
            tab1Screen(state),
            tab2Screen(state),
            tab3Screen(state),
          ])),
    );
  }

  Widget tab1Screen(HomeState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10,),
          SizedBox(
                    height: 220,
                    width: 220,
                    child: ClipOval(
                      child: Image.asset(
                        "lib/assets/Rajesh_Dada.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          Column( 
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  
                ],
              )

               


            ],
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
    return Center(child: Text('Content of Tab 3'));
  }

  @override
  Widget build(BuildContext context) {
    var asyncHomeState = ref.watch(homeControllerProvider);

    return asyncHomeState.when(
        data: (homeState) {
          return getScaffold(homeState);
        },
        error: (error, stackTrace) => const Scaffold(
              body: CircularProgressIndicator(),
            ),
        loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
