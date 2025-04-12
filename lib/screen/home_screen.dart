import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

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
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(text: 'Home', icon: Icon(Icons.home)),
          Tab(text: 'About', icon: Icon(Icons.info)),
          Tab(text: 'Contact Us', icon: Icon(Icons.contacts)),
        ]),
      ),

      // drawer: Drawer(
      //   backgroundColor: Colors.black ,
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         tileColor: const Color.fromARGB(255, 51, 65, 75),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //       ),
      //     ],
      //   ),
      // ),

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
    return PageView.builder(
      controller: _pageController,
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Image.asset(
          imagePaths[index],
          fit: BoxFit.cover,
        );
      },
      onPageChanged: (index) {
        _currentPage = index;
      },
    );
  }

  Widget tab2Screen(HomeState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            Center(
              child: Text("Testing"),
            )
          ],
        ),
      ),
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
