import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isMr => locale.languageCode == 'mr';

  // ── App bar ─────────────────────────────────────────────────────────────────
  String get appBarTitle =>
      isMr ? 'आपले आमदार श्री. राजेश दादा' : 'Our MLA Shri. Rajesh Dada';
  String get appBarSubtitle =>
      isMr ? 'जनसेवेचे नवे पाऊल' : 'A new step in public service';

  // ── Tabs ────────────────────────────────────────────────────────────────────
  String get tabHome => isMr ? 'मुख्यपृष्ठ' : 'Home';
  String get tabProfile => isMr ? 'प्रोफाइल' : 'Profile';
  String get tabSettings => isMr ? 'सेटिंग्ज' : 'Settings';

  // ── Home grid icons ─────────────────────────────────────────────────────────
  String get gridRajeshDada => isMr ? 'राजेश दादा' : 'Rajesh Dada';
  String get gridGrievance => isMr ? 'तक्रार / विनंती' : 'Grievance';
  String get gridAchievements => isMr ? 'कामगिरी' : 'Achievements';
  String get gridHelpline => isMr ? 'हेल्पलाइन' : 'Helpline';
  String get gridGallery => isMr ? 'गॅलरी' : 'Gallery';
  String get gridWomenEmpowerment =>
      isMr ? 'महिला सशक्तीकरण' : 'Women Empowerment';

  // ── Social media ─────────────────────────────────────────────────────────────
  String get socialMedia => isMr ? 'सोशल मीडिया' : 'Social Media';

  // ── Settings ────────────────────────────────────────────────────────────────
  String get settings => isMr ? 'सेटिंग्ज' : 'Settings';
  String get settingsSubtitle =>
      isMr ? 'ॲप थीम आणि खाते क्रिया व्यवस्थापित करा.' : 'Manage app theme and account actions.';
  String get darkMode => isMr ? 'डार्क मोड' : 'Dark Mode';
  String get language => isMr ? 'भाषा' : 'Language';
  String get langMarathi => 'मराठी';
  String get langEnglish => 'English';

  // ── Logout ──────────────────────────────────────────────────────────────────
  String get logout => isMr ? 'लॉगआउट' : 'Logout';
  String get confirmLogout => isMr ? 'लॉगआउट निश्चित करा' : 'Confirm Logout';
  String get logoutMessage =>
      isMr ? 'तुम्हाला खरोखर लॉगआउट करायचे आहे का?' : 'Are you sure you want to log out?';
  String get cancel => isMr ? 'रद्द करा' : 'Cancel';
  String get backToExit =>
      isMr ? 'बाहेर पडण्यासाठी पुन्हा मागे दाबा' : 'Press back again to exit';

  // ── Footer ──────────────────────────────────────────────────────────────────
  String get designedBy => isMr ? 'डिझाईन व विकसित केले' : 'Designed & Developed By';
  String get noEmailApp =>
      isMr ? 'हा पत्ता उघडण्यासाठी कोणतेही ईमेल ॲप सापडले नाही' : 'No email app found to open this address';

  // ── Profile tab ─────────────────────────────────────────────────────────────
  String get citizenProfile => isMr ? 'नागरिक प्रोफाइल' : 'Citizen profile';
  String get registeredDetails =>
      isMr ? 'तुमचे नोंदणीकृत तपशील येथे दिसतात' : 'Your registered details appear here';
  String get downloadCertificate =>
      isMr ? 'प्रमाणपत्र डाउनलोड करा' : 'Download Certificate';
  String get fieldName => isMr ? 'नाव' : 'Name';
  String get fieldTaluka => isMr ? 'तालुका' : 'Taluka';
  String get fieldGender => isMr ? 'लिंग' : 'Gender';
  String get fieldBloodGroup => isMr ? 'रक्त गट' : 'Blood Group';
  String get fieldAge => isMr ? 'वय' : 'Age';
  String get fieldMail => isMr ? 'ईमेल' : 'Mail';
  String get fieldMobile => isMr ? 'मोबाइल' : 'Mobile';

  // ── Admin login ─────────────────────────────────────────────────────────────
  String get adminLogin => isMr ? 'प्रशासक लॉगिन' : 'Admin Login';
  String get username => isMr ? 'वापरकर्ता नाव' : 'Username';
  String get password => isMr ? 'पासवर्ड' : 'Password';
  String get login => isMr ? 'लॉगिन' : 'Login';
  String get loginSuccessful => isMr ? 'लॉगिन यशस्वी' : 'Login Successful';
  String get loginFailed => isMr ? 'लॉगिन अयशस्वी' : 'Login Failed';

  // ── Certificate screen ───────────────────────────────────────────────────────
  String get certificate => isMr ? 'प्रमाणपत्र' : 'Certificate';
  String get certificateSubtitle =>
      isMr ? 'तुमचे प्रमाणपत्र पाहा आणि डाउनलोड करा.' : 'Preview and download your certificate.';

  // ── Page screen titles / subtitles ───────────────────────────────────────────
  String get rajeshDadaTitle => isMr ? 'आपले राजेश दादा' : 'Our Rajesh Dada';
  String get rajeshDadaSubtitle =>
      isMr ? 'प्रोफाइल आणि पार्श्वभूमी माहिती.' : 'Profile and background information.';

  String get grievanceTitle => isMr ? 'तक्रार / विनंती' : 'Grievance / Request';
  String get grievanceSubtitle =>
      isMr ? 'सर्व आवश्यक तपशीलांसह विनंती सादर करा.' : 'Submit your request with all required details.';

  String get achievementsTitle => isMr ? 'कामगिरी' : 'Achievements';
  String get achievementsSubtitle =>
      isMr ? 'महत्त्वाचे कार्य आणि विकास उपक्रम.' : 'Highlights and development work.';

  String get helplineTitle => isMr ? 'हेल्पलाइन' : 'Helpline';
  String get helplineSubtitle =>
      isMr ? 'महत्त्वाचे स्थानिक सहाय्य आणि आपत्कालीन संपर्क.' : 'Important local support and emergency contacts.';

  String get galleryTitle => isMr ? 'गॅलरी' : 'Gallery';
  String get gallerySubtitle =>
      isMr ? 'सार्वजनिक कार्यक्रमातील फोटो आणि क्षण.' : 'Photos and moments from public programs.';

  String get womenEmpowermentTitle => isMr ? 'महिला सशक्तीकरण' : 'Women Empowerment';
  String get womenEmpowermentSubtitle =>
      isMr ? 'कार्यक्रम, उपक्रम आणि अद्यतने.' : 'Programs, initiatives, and updates.';

  // ── Login screen ────────────────────────────────────────────────────────────
  String get loginGreeting => isMr ? 'नमस्कार 🙏' : 'Welcome Back';
  String get loginTitle => isMr ? 'पुन्हा स्वागत आहे' : 'Login to continue';
  String get loginSubtitle => isMr
      ? 'सार्वजनिक सेवा, तक्रार सहाय्य आणि स्थानिक अपडेटसाठी लॉगिन करा.'
      : 'Login to continue with public services, grievance support, and local updates.';
  String get mobileNumber => isMr ? 'मोबाइल नंबर' : 'Mobile Number';
  String get mobileRequired => isMr ? 'मोबाइल नंबर आवश्यक आहे' : 'Mobile number is required';
  String get mobileInvalid => isMr ? '10 अंकी वैध नंबर प्रविष्ट करा' : 'Enter a valid 10-digit number';
  String get passwordHint => isMr ? 'पासवर्ड' : 'Password';
  String get passwordRequired => isMr ? 'कृपया तुमचा पासवर्ड प्रविष्ट करा' : 'Please enter your password';
  String get rememberMe => isMr ? 'मला लक्षात ठेवा' : 'Remember me';
  String get loginButton => isMr ? 'लॉगिन करा' : 'Login';
  String get createAccount => isMr ? 'नवीन खाते तयार करा' : 'Create Account';
  String get loginSuccess => isMr ? 'लॉगिन यशस्वी' : 'Login successful';
  String get loginFailed2 => isMr ? 'लॉगिन अयशस्वी' : 'Login failed';

  // ── Registration screen ──────────────────────────────────────────────────────
  String get registerTitle => isMr ? 'नोंदणी' : 'Register';
  String get registerHeading => isMr ? 'खाते तयार करा' : 'Create an account';
  String get registerSubtitle => isMr
      ? 'सार्वजनिक सेवा, प्रमाणपत्र आणि तक्रार सहाय्यासाठी एकदा नोंदणी करा.'
      : 'Register once to access public services, certificates, and grievance support.';
  String get registerButton => isMr ? 'रजिस्टर करा' : 'Register';
  String get somethingWentWrongTitle => isMr ? 'काहीतरी चूक झाली' : 'Something went wrong';

  // ── Generic states ──────────────────────────────────────────────────────────
  String get failedToLoad =>
      isMr ? 'डेटा लोड होऊ शकला नाही.\nखाली खेचून पुन्हा प्रयत्न करा.' : 'Failed to load data.\nPull down to retry.';
  String get failedToLoadImages =>
      isMr ? 'प्रतिमा लोड होऊ शकल्या नाहीत.' : 'Failed to load images.';
  String get somethingWentWrong =>
      isMr ? 'काहीतरी चूक झाली' : 'Something went wrong';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'mr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
