import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class WomenEmpowermentScreen extends ConsumerStatefulWidget {
  const WomenEmpowermentScreen({super.key});

  @override
  ConsumerState<WomenEmpowermentScreen> createState() => _WomenEmpowermentScreenState();
}

class _WomenEmpowermentScreenState extends ConsumerState<WomenEmpowermentScreen> {
  List<Map<String, String>> galleryItems = [
    {
      'imagePath': "lib/assets/women_empowerment/savitribai_phule_jayanti.jpeg",
      'description': "8 मार्च रोजी महिला दिनानिम्मत सावित्रीबाई फुले ज्येष्ठ नागरिक महिला मंडळ यांच्या कार्यक्रमात उपस्थित होते."
    },
    {
      'imagePath': "lib/assets/women_empowerment/women_day.jpeg",
      'description': "बोरद येथे महिला दिनानिमित्त महिलांचे प्रश्न जाणून घेतले व त्यांना महिलांचे सरकार द्वारे मिळणाऱ्या  उपाययोजना समजून देण्यात आले.",
    },
    {
      "imagePath": "lib/assets/women_empowerment/bachatgat.jpeg",
      "description": "तळवे या गावी अंगणवाडी व महिला बचत गटाची बैठक घेऊन त्यांना नवीन उद्योगधंद्याबद्दल माहिती दिली"
    },
    // Add more items here
    {
      "imagePath": "lib/assets/women_empowerment/mod_bachatgat_meeting.jpeg",
      "description": "मोड या गावी महिला बचत गटाची मीटिंग ठेवून त्यांच्या समस्या जाणून घेतल्या व बचत गटाच्या नवीन उपाययोजना सांगण्यात आला."
    },
    {
      "imagePath": "lib/assets/women_empowerment/morwad.jpeg",
      "description": "मोरवड येथे तरुणींशी भेट घेऊन त्यांच्याजवळ चर्चा केली."
    },
    {
      "imagePath": "lib/assets/women_empowerment/morwad_mahile_charcha.jpeg",
      "description": "मोरवड या गावी महिलांशी चर्चा करून त्यांच्या समस्या ऐकून घेतल्या."
    },

    //
    {
      "imagePath": "lib/assets/women_empowerment/ranjanpur_prasad.jpeg",
      "description": "तीर्थक्षेत्र रंजनपुर येथे दर्शन घेऊन  महाप्रसादाच्या लाभ घेतला."
    },
    {
      "imagePath": "lib/assets/women_empowerment/bachatgat_meeting.jpeg",
      "description": "आम्हाला बचत गट महिलांची मीटिंग घेऊन त्यांच्या समस्या ऐकून त्यावर निराकरण केले."
    },
    {
      "imagePath": "lib/assets/women_empowerment/kalawati_foundation.jpeg",
      "description": "आ. राजेशदादा पाडवी यांच्या मार्गदर्शनाखाली कै. कलावती पाडवी फाउंडेशन च्या माध्यमातून कु. नेहा राजेशदादा पाडवी यांच्या हस्ते जिल्हा परिषदेचा शाळेत वॉटर प्युरिफायरचे लोकार्पण करण्यात आले."
    },
  ];

  Widget getScaffold(HomeState state) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("महिला सशक्तीकरण"),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
          
              // Center(
              //     child: Text("To be updated soon...", style:  TextStyle(fontSize: 22),),
              //   )

              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: galleryItems.length,
                  itemBuilder: (context, index) {
                    final item = galleryItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.asset(
                                item['imagePath'] ?? "",
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                item['description'] ?? "",
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.justify,
            
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            

            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
        data: (state) => getScaffold(state),
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
