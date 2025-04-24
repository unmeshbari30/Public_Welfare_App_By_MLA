import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class RajeshDadaInfoScreen extends ConsumerStatefulWidget {
  const RajeshDadaInfoScreen({super.key});

  @override
  ConsumerState<RajeshDadaInfoScreen> createState() => _RajeshDadaInfoScreenState();
}

class _RajeshDadaInfoScreenState extends ConsumerState<RajeshDadaInfoScreen> {

  Widget getScaffold(HomeState state){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("आपले राजेश दादा"),
        backgroundColor: Colors.amber,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
               Padding(
                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                 child: Image.asset('lib/assets/Rajesh_Dada.jpg'),
               ),
               const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
  '''
\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0राजेश दादा पाडवी यांचा प्रवास म्हणजे एका सामान्य घरातून उठून कार्यसम्राट बनण्याची जिद्दीची आणि सेवाभावाची कहाणी आहे. लहानपणापासूनच कष्ट, संघर्ष आणि समाजासाठी काही तरी करून दाखवण्याची दुर्दम्य इच्छाशक्ती त्यांच्या मनात रुजली होती. कोणतंही मोठं पाठबळ नसताना, खांद्यावर झोळी आणि मनात फक्त जनतेसाठी काहीतरी करण्याची तळमळ घेऊन त्यांनी राजकारणाच्या वाटेवर पाऊल ठेवलं. शिक्षण, प्रामाणिकपणा आणि सेवाभाव हेच त्यांच्या जीवनाचे मुख्य शस्त्र होते. गावागावात सायकलवर फिरून लोकांच्या अडचणी समजून घेत, त्या सोडवण्यासाठी झटणाऱ्या राजेश दादांनी जनतेच्या मनात विश्वास निर्माण केला आणि आज ते मतदारसंघाचेच नव्हे तर संपूर्ण जिल्ह्याचे अभिमान बनले आहेत.

\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0तुमचा एका मताने काय केलं आमदार पाडवी साहेबांनी, तर या मतदारसंघातील सर्वसामान्य हजारो नागरिकांचे निशुल्क ऑपरेशन त्यांनी मुंबई, नाशिक आणि नंदुरबार येथील नामांकित हॉस्पिटलमध्ये करून दाखवले. तुमचा एका मताने पाडवी साहेबांनी काय केलं तर हजारो गोरगरीब कष्टकरी नागरिकांसाठी निशुल्क, तातडीने वैद्यकीय उपचार मिळवण्यासाठी प्रयत्न केलेत.

\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0तुमचा एका मताने काय केले या मतदारसंघासाठी तर मतदार संघातील ७० वर्षांपासून रखडलेले गाव अंतर्गत गावजोड रस्ते पूर्ण करून दाखवलेत. तांबडता वाघ व ओझरटा वाघडे या परिसरात कधी नव्हती फळबागायती केली जात नव्हती, तिथे बंधारे आणि खेटीवेअरच्या माध्यमातून परिसर सुजलाम सुफलाम करत हजारो हेक्टर जमीन ओलिताखाली आणण्याचं कार्य तुमच्या एका मताने झालं.

\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0वनपट्टे प्रलंबित होते, पिढ्यानपिढ्या संघर्ष करत असणाऱ्या कुटुंबांना स्वतःचा हक्काचा सातबारा मिळवून देण्यासाठी त्यांनी अपार मेहनत घेतली. विकलांग बांधवांसाठी कृत्रिम पाय बसवून त्यांना स्वतःच्या पायावर उभं राहता यावं, यासाठी त्यांनी स्वतः पुढाकार घेतला. त्यांच्या नेतृत्वातून जिल्ह्यातील एकमेव आमदार म्हणून सहा हून अधिक रुग्णवाहिका कार्यरत आहेत, ज्या सर्वसामान्य जनतेसाठी आरोग्य सेवा वेळेत पोहोचवतात.

\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0तुमच्या एका मताने या मतदारसंघाला पूर्ण वेळ, सकाळी सहाच्या ठोक्याला जनतेसाठी सज्ज असणारा लोकप्रतिनिधी लाभला. आदिवासी समाजासाठी अभिमानाचा क्षण ठरावा अशा प्रकारे बिरसा मुंडा यांचं स्मारक उभारून युवकांना प्रेरणा देण्याचं काम केलं.

\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0तळोदा शहराला विकासाच्या मुख्य प्रवाहात आणण्यासाठी शहरातील रस्ते बांधले गेले, सौंदर्यीकरण करण्यात आलं आणि संपूर्ण शहराच्या जीवनमानात वाढ झाली. त्यांनी राजपथ निर्माण करून तळोदा शहराला एक आगळीवेगळी ओळख दिली.

\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0हे सर्व शक्य झालं ते केवळ तुमच्या एका मतामुळे. आज संपूर्ण जिल्ह्यात सर्वात वेगाने विकसित होणारा मतदारसंघ म्हणून ओळख मिळवलेली आहे, आणि हे सर्व घडवून आणणाऱ्या कार्यसम्राट आमदार राजेश दादा पाडवी साहेबांचे हे योगदान तुमच्या एका मताने सुरू झालेल्या विश्वासाच्या प्रवासाचं प्रतीक आहे.
''',
  textAlign: TextAlign.justify,
),

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