import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rajesh_dada_padvi/controllers/authentication_controller.dart';
import 'package:rajesh_dada_padvi/controllers/home_controller.dart';
import 'package:rajesh_dada_padvi/helpers/enum.dart';
import 'package:rajesh_dada_padvi/helpers/helpers.dart';
import 'package:rajesh_dada_padvi/models/Files/files_response_model.dart';
import 'package:rajesh_dada_padvi/screen/Admin/admin_grievance_screen.dart';
import 'package:rajesh_dada_padvi/screen/Login_Screens/login_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/achievements_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/gallery_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/grievance_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/helpline_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/rajesh_dada_info_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/women_empowerment.dart';
import 'package:rajesh_dada_padvi/screen/certificate_screen/temp_cert_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart' show Shimmer;
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
  int _tapCount = 0;
  DateTime? _lastTapTime;
  String? firstName, lastName, bloodGroup, mobileNumber, mailId, gender, taluka;
  int? age;

  void _handleImageTap(HomeState state) {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > Duration(seconds: 2)) {
      _tapCount = 0; // reset if too slow
    }

    _lastTapTime = now;
    _tapCount++;

    if (_tapCount == 4) {
      _tapCount = 0; // reset counter
      _showAdminLoginDialog(state);
    }
  }

  void _showAdminLoginDialog(HomeState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Admin Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: state.adminUsernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: state.adminPasswordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show();
                try {
                  final loginResponse = await ref
                      .read(homeControllerProvider.notifier)
                      .adminSignIn();

                  Helpers.showSuccessOrFailureSnackBar(
                    context,
                    message: loginResponse?.isLoggedIn ?? false
                        ? "Login Successful"
                        : "Login Failed",
                    isSuccess: loginResponse?.isLoggedIn ?? false,
                  );

                  // if (true) {
                  if (loginResponse?.isLoggedIn ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminGrievanceScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  Helpers.showSuccessOrFailureSnackBar(
                    context,
                    message: "Login Failed",
                    isSuccess: false,
                  );
                } finally {
                  EasyLoading.dismiss();
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

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

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => _showDisclaimerDialog(),
    // );

    _loadPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // force the user to accept
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Disclaimer"),
          content: SingleChildScrollView(
            child: Text(
              "This app is not affiliated with any government, political party, or official body. It is an independent initiative aimed at providing citizens a digital platform to communicate with their elected MLA.",
              textAlign: TextAlign.justify,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Agree"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // TextButton(
            //   child: Text("Exit"),
            //   onPressed: () {
            //     // Exit the app if user disagrees
            //     Navigator.of(context).pop();
            //     Future.delayed(Duration(milliseconds: 300), () {
            //       // import 'dart:io';
            //       // exit(0); // Optional, use responsibly
            //     });
            //   },
            // ),
          ],
        );
      },
    );
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      firstName = prefs.getString(PrefrencesKeyEnum.firstName.key);
      lastName = prefs.getString(PrefrencesKeyEnum.lastName.key);
      bloodGroup = prefs.getString(PrefrencesKeyEnum.bloodGroup.key);
      age = prefs.getInt(PrefrencesKeyEnum.age.key);
      mobileNumber = prefs.getString(PrefrencesKeyEnum.mobileNumber.key);
      mailId = prefs.getString(PrefrencesKeyEnum.mailId.key);
      gender = prefs.getString(PrefrencesKeyEnum.gender.key);
      taluka = prefs.getString(PrefrencesKeyEnum.taluka.key);
    });
  }

  Widget getScaffold(HomeState state) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: GestureDetector(
                  onTap: () => _handleImageTap(state),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Icon(Icons.security),
                  ),
                ),
              ),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "आपले आमदार श्री. राजेश दादा",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // adjust size if needed
                  ),
                ),
                Text(
                  "जनसेवेचे नवे पाऊल",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16, // slightly smaller
                  ),
                ),
              ],
            ),
            //Text("🙏🏻आपला आमदार 🙏🏻"),
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFFBA800),
            elevation: 0,
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
                                builder: (context) => LoginScreen(),
                              ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Press back again to exit",
                    style: TextStyle(color: Colors.black),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.amberAccent,
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 60,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Home', icon: Icon(Icons.home, size: 25)),
                      Tab(text: 'Profile', icon: Icon(Icons.person, size: 30)),
                      Tab(
                        text: 'Contact Us',
                        icon: Icon(Icons.contacts, size: 22),
                      ),
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
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
        ),
      ],
    );
  }

  Widget tab1Screen(HomeState state) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(homeControllerProvider);
            await ref.read(homeControllerProvider.future);
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 280,
                    child: FutureBuilder<FileResponseModel?>(
                      future: state.homeDataResponse,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Shimmer for entire slider height
                          return Shimmer(
                            child: Container(
                              height: 280,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data == null) {
                          return Center(child: Text("Failed to load images."));
                        }

                        final imageItems = snapshot.data!.files;

                        if (_pageController == null) {
                          _pageController = PageController(initialPage: 0);
                          _timer?.cancel();

                          _timer = Timer.periodic(Duration(seconds: 3), (
                            Timer timer,
                          ) {
                            if (_pageController!.hasClients) {
                              if (_currentPage < imageItems!.length - 1) {
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

                        return PageView.builder(
                          controller: _pageController,
                          itemCount: imageItems?.length,
                          itemBuilder: (context, index) {
                            final base64String = imageItems?[index].base64Data;
                            Uint8List? imageBytes;
                            bool useFallbackImage = false;

                            if (base64String == null ||
                                base64String.trim().isEmpty) {
                              useFallbackImage = true;
                            } else {
                              try {
                                imageBytes = base64Decode(base64String);
                              } catch (e) {
                                useFallbackImage = true;
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: useFallbackImage
                                    ? Image.asset(
                                        "lib/assets/Icons/broken_image.png",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                    : Image.memory(
                                        imageBytes!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            );
                          },
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                          "lib/assets/Icons/rajesh_dada_icon.png",
                          "राजेश दादा",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RajeshDadaInfoScreen(),
                              ),
                            );
                          },
                        ),
                        buildGridIcon(
                          "lib/assets/Icons/grievance_icon.jpeg",
                          "तक्रार / विनंती",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GrievanceScreen(),
                              ),
                            );
                          },
                        ),
                        buildGridIcon(
                          "lib/assets/Icons/achievements_icon.jpeg",
                          "कामगिरी",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AchievementsScreen(),
                              ),
                            );
                          },
                        ),
                        buildGridIcon(
                          "lib/assets/Icons/helpline_icon.jpeg",
                          "हेल्पलाईन",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelplineScreen(),
                              ),
                            );
                          },
                        ),
                        buildGridIcon(
                          "lib/assets/Icons/gallery_icon.jpeg",
                          "गॅलरी ",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GalleryScreen(),
                              ),
                            );
                          },
                        ),
                        buildGridIcon(
                          "lib/assets/Icons/women_empowerment_icon.jpeg",
                          "महिला सशक्तीकरण",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WomenEmpowermentScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                      onPressed: () => launchURL(
                        "https://www.facebook.com/mlarajesh.padvi.3?mibextid=rS40aB7S9Ucbxw6v",
                      ),
                      iconSize: 36,
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.xTwitter,
                        color: Colors.black,
                      ),
                      onPressed: () => launchURL(
                        "https://x.com/MlaPadvi?t=sr656VMprkJ5qXyXIBpyvw&s=09",
                      ),
                      iconSize: 36,
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.purple,
                      ),
                      onPressed: () => launchURL(
                        "https://www.instagram.com/rajeshpadvi001/",
                      ),
                      iconSize: 36,
                    ),
                  ],
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tab2Screen(HomeState state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            SizedBox(
              height: 170,
              width: 180,
              child: ClipOval(
                child: Image.asset(
                  "lib/assets/Icons/dummy_profile_icon.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CertificateScreen()),
                );
              },
              child: Text("Download Certificate"),
            ),

            const SizedBox(height: 10),

            // Card Section
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profileRow("Name", "$firstName $lastName"),
                    const Divider(),
                    profileRow("Taluka", "$taluka"),
                    const Divider(),
                    profileRow("Gender", "$gender"),
                    const Divider(),
                    profileRow("Blood Group", "$bloodGroup"),
                    const Divider(),
                    profileRow("Age", "$age"),
                    const Divider(),
                    profileRow("Mail", "$mailId"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tab3Screen(HomeState state) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: ClipOval(
                  child: Image.asset(
                    "lib/assets/Icons/office_illustration.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 280,
                child: Text(
                  'संपर्क\n\n'
                  'शहादा : आमदार कार्यालय दत्त कॉलनी शहादा.\n'
                  'तळोदा : आमदार कार्यालय बिरसा मुंडा चौक तळोदा\n\n'
                  'अ‍ॅड. दीपक जयस्वाल  : 8380911028\n'
                  'किरण सूर्यवंशी  : 9132352222',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(thickness: 1.4),
            ],
          ),

          // Spacer pushes the bottom part to the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                Text(
                  '''Designed & Developed By
      Exaltasoft Solutions, Pune - 411014''',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'contact@exaltasoft.in',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          ),
        ],
      ),
    );
  }

  Widget profileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var asyncHomeState = ref.watch(homeControllerProvider);

    return asyncHomeState.when(
      data: (homeState) {
        return getScaffold(homeState);
      },
      error: (error, stackTrace) =>
          const Scaffold(body: Text("Something Went Wrong")),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
