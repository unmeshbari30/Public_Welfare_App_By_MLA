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
import 'package:rajesh_dada_padvi/providers/theme_provider.dart';
import 'package:rajesh_dada_padvi/screen/Admin/admin_grievance_screen.dart';
import 'package:rajesh_dada_padvi/screen/Login_Screens/login_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/achievements_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/gallery_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/grievance_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/helpline_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/rajesh_dada_info_screen.dart';
import 'package:rajesh_dada_padvi/screen/Pages/women_empowerment.dart';
import 'package:rajesh_dada_padvi/screen/certificate_screen/certificate_screen.dart';
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
  String? firstName;
  String? lastName;
  String? bloodGroup;
  String? mobileNumber;
  String? mailId;
  String? gender;
  String? taluka;
  int? age;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController?.dispose();
    _timer?.cancel();
    super.dispose();
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

  void _handleImageTap(HomeState state) {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 0;
    }
    _lastTapTime = now;
    _tapCount++;
    if (_tapCount == 4) {
      _tapCount = 0;
      _showAdminLoginDialog(state);
    }
  }

  void _showAdminLoginDialog(HomeState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: state.adminUsernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: state.adminPasswordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                EasyLoading.show();
                try {
                  final loginResponse = await ref
                      .read(homeControllerProvider.notifier)
                      .adminSignIn();
                  Helpers.showSuccessOrFailureSnackBar(
                    context,
                    message: loginResponse?.isLoggedIn ?? false
                        ? 'Login Successful'
                        : 'Login Failed',
                    isSuccess: loginResponse?.isLoggedIn ?? false,
                  );
                  if (loginResponse?.isLoggedIn ?? false) {
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminGrievanceScreen(),
                      ),
                    );
                  }
                } finally {
                  EasyLoading.dismiss();
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authenticationControllerProvider.notifier).loggedOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget getScaffold(HomeState state) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => _handleImageTap(state),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Icon(
                Icons.admin_panel_settings_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'आपले आमदार श्री. राजेश दादा',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            Text(
              'जनसेवेचे नवे पाऊल',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (exitCounter == 2) {
            exit(0);
          }
          exitCounter++;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit')),
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    splashBorderRadius: BorderRadius.circular(16),
                    labelPadding: EdgeInsets.zero,
                    tabs: const [
                      Tab(
                        height: 50,
                        icon: Icon(Icons.home_rounded, size: 20),
                        text: 'Home',
                      ),
                      Tab(
                        height: 50,
                        icon: Icon(Icons.person_rounded, size: 20),
                        text: 'Profile',
                      ),
                      Tab(
                        height: 50,
                        icon: Icon(Icons.settings_rounded, size: 20),
                        text: 'Settings',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [tab1Screen(state), tab2Screen(), tab3Screen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tab1Screen(HomeState state) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(homeControllerProvider);
        await ref.read(homeControllerProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          _buildHeroSection(state),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
              children: [
                _buildGridIcon(
                  'lib/assets/Icons/rajesh_dada_icon.png',
                  'राजेश दादा',
                  Icons.account_box_rounded,
                  () => _openScreen(const RajeshDadaInfoScreen()),
                ),
                _buildGridIcon(
                  'lib/assets/Icons/grievance_icon.jpeg',
                  'तक्रार / विनंती',
                  Icons.campaign_rounded,
                  () => _openScreen(const GrievanceScreen()),
                ),
                _buildGridIcon(
                  'lib/assets/Icons/achievements_icon.jpeg',
                  'कामगिरी',
                  Icons.workspace_premium_rounded,
                  () => _openScreen(const AchievementsScreen()),
                ),
                _buildGridIcon(
                  'lib/assets/Icons/helpline_icon.jpeg',
                  'हेल्पलाइन',
                  Icons.support_agent_rounded,
                  () => _openScreen(const HelplineScreen()),
                ),
                _buildGridIcon(
                  'lib/assets/Icons/gallery_icon.jpeg',
                  'गॅलरी',
                  Icons.photo_library_rounded,
                  () => _openScreen(const GalleryScreen()),
                ),
                _buildGridIcon(
                  'lib/assets/Icons/women_empowerment_icon.jpeg',
                  'महिला सशक्तीकरण',
                  Icons.groups_2_rounded,
                  () => _openScreen(const WomenEmpowermentScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social Media',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _socialButton(
                      FontAwesomeIcons.facebookF,
                      'Facebook',
                      const Color(0xFF1877F2),
                      'https://www.facebook.com/mlarajesh.padvi.3?mibextid=rS40aB7S9Ucbxw6v',
                    ),
                    const SizedBox(width: 10),
                    _socialButton(
                      FontAwesomeIcons.xTwitter,
                      'X',
                      theme.colorScheme.onSurface,
                      'https://x.com/MlaPadvi?t=sr656VMprkJ5qXyXIBpyvw&s=09',
                    ),
                    const SizedBox(width: 10),
                    _socialButton(
                      FontAwesomeIcons.instagram,
                      'Instagram',
                      const Color(0xFFE4405F),
                      'https://www.instagram.com/rajeshpadvi001/',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(HomeState state) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: FutureBuilder<FileResponseModel?>(
          future: state.homeDataResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Shimmer(
                  color: Colors.grey.shade500,
                  colorOpacity: 0.8,
                  child: Container(color: Colors.grey.shade400),
                ),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null ||
                (snapshot.data?.files?.isEmpty ?? true)) {
              return const Center(child: Text('Failed to load images.'));
            }

            final imageItems = snapshot.data!.files!;
            _setupAutoScroll(imageItems.length);

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageItems.length,
                    itemBuilder: (context, index) {
                      final bytes = _decodeImage(imageItems[index].base64Data);
                      return bytes == null
                          ? Image.asset(
                              'lib/assets/Icons/broken_image.png',
                              fit: BoxFit.cover,
                            )
                          : Image.memory(bytes, fit: BoxFit.cover);
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imageItems.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentPage == index ? 22 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _setupAutoScroll(int length) {
    if (_pageController != null || length == 0) return;
    _pageController = PageController(initialPage: 0);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController?.hasClients ?? false) {
        _currentPage = _currentPage < length - 1 ? _currentPage + 1 : 0;
        _pageController?.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Uint8List? _decodeImage(String? base64String) {
    if (base64String == null || base64String.trim().isEmpty) return null;
    try {
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  Widget tab2Screen() {
    final theme = Theme.of(context);
    final fullName = [firstName, lastName]
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(' ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'lib/assets/Icons/dummy_profile_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName.isEmpty ? 'Citizen profile' : fullName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                taluka ?? 'Your registered details appear here',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => _openScreen(const CertificateScreen()),
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download Certificate'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _profileCard('Name', fullName),
        const SizedBox(height: 12),
        _profileCard('Taluka', taluka),
        const SizedBox(height: 12),
        _profileCard('Gender', gender),
        const SizedBox(height: 12),
        _profileCard('Blood Group', bloodGroup),
        const SizedBox(height: 12),
        _profileCard('Age', age?.toString()),
        const SizedBox(height: 12),
        _profileCard('Mail', mailId),
        const SizedBox(height: 12),
        _profileCard('Mobile', mobileNumber),
      ],
    );
  }

  Widget tab3Screen() {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Text(
                'Settings',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage app theme and account actions.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _settingsTile(
          icon: isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          title: 'Dark Mode',
          trailing: Switch(
            value: isDarkMode,
            onChanged: (_) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ),
        const SizedBox(height: 12),
        _settingsTile(
          icon: Icons.logout_rounded,
          title: 'Logout',
          trailing: FilledButton(
            onPressed: _showLogoutDialog,
            child: const Text('Logout'),
          ),
        ),
        const SizedBox(height: 18),
        _sectionCard(
          child: Column(
            children: [
              Text(
                'Designed & Developed By',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Exaltasoft Solutions, Pune - 411014',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => launchURL('mailto:contact@exaltasoft.in'),
                child: Text(
                  'contact@exaltasoft.in',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )],
          ),
        ),
      ],
    );
  }

  Widget _buildGridIcon(
    String assetPath,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.surface,
                  backgroundImage: AssetImage(assetPath),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 10,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(String title, String? value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              (value == null || value.trim().isEmpty) ? '-' : value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }

  Widget _socialButton(
    IconData icon,
    String label,
    Color color,
    String url,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () => launchURL(url),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              FaIcon(icon, color: color, size: 18),
              const SizedBox(height: 8),
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactRow({
    required String title,
    required String subtitle,
    required String phone,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.call_rounded, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(subtitle, style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => launchURL('tel:$phone'),
                  child: Text(
                    phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncHomeState = ref.watch(homeControllerProvider);
    return asyncHomeState.when(
      data: (homeState) => getScaffold(homeState),
      error: (error, stackTrace) =>
          const Scaffold(body: Center(child: Text('Something went wrong'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
