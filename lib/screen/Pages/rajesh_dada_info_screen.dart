import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';

class RajeshDadaInfoScreen extends ConsumerStatefulWidget {
  const RajeshDadaInfoScreen({super.key});

  @override
  ConsumerState<RajeshDadaInfoScreen> createState() =>
      _RajeshDadaInfoScreenState();
}

class _RajeshDadaInfoScreenState extends ConsumerState<RajeshDadaInfoScreen> {
  Widget getScaffold(HomeState state) {
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
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            //   child: Card(
            //       elevation: 2,
            //       child: ClipRRect(
            //           borderRadius: BorderRadius.circular(12),
            //           // child: Image.asset('lib/assets/Rajesh_Dada.jpg'))),
            //           child:
            //               Image.asset("lib/assets/rajesh_dada_info_img.jpeg"))),
            // ),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 300, 
                  height: 300,
                  child: Image.asset(
                    "lib/assets/Gallery/dada_info_img.png",
                    fit: BoxFit
                        .fill,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    '''
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0सातपुड्याच्या कुशीत सोमावल येथे 5 मे 1969 साली वातावरणाला तेजोमय करणारा अवकाशातला ताराच अवतरला. जणू काय या धरणीवर पुण्य अवतरावे. पाडवी कुटुंबात राजेश पाडवी यांचा जन्म झाला. पाडवी कुटुंबात जन्मलेला हा मुलगा पुढे जनतेच्या हृदयावर राज्य करणारा नेता होईल, याचा अंदाज तेव्हा कोणाला होता? या व्यक्तिमत्वाबद्दल बोलावं किती, लिहावं कीती याला कुठलीही सीमा नाही. असं कणखर, रुबाबदार, धाडसी तितकंच मनमिळावू, भावनिक असे हे आमचे 'दादा'. दादांचा जनतेशी असलेला संवाद अगदी सरळ, साधा असल्यामुळे प्रत्येकाला ते आपले वाटतात, आपल्या कुटुंबातील सदस्य वाटतात आणि म्हणुनच आमच्या दादांचा बोलबाला सर्वत्र सातपुड्याच्या कडेकपाऱ्यात गुंजतो.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0दादांचं प्राथमिक आणि माध्यमिक शिक्षण आश्रमशाळेत झालं. पुढील पदवीच्या शिक्षणासाठी त्यांनी मुंबई गाठली. मेहनत आणि चिकाटीच्या जोरावर महाराष्ट्र लोकसेवा आयोगाची परीक्षा उत्तीर्ण होत अखेर ते PSI बनले. एका लहानशा गावचं, आश्रमशाळेत शिकलेल पोरगं PSI होतं. त्या काळी पोलिसात नोकरी म्हणजे खूप मान, सन्मान! तेही मुंबई पोलिसात नोकरी म्हटली म्हणजे अख्खं गाव अदबीनं समोर यायचं. 27 वर्ष पोलिस खात्यात महाराष्ट्र राज्यासाठी सेवा देत त्यांनी उत्तम कामगिरी केली.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0सातपुड्याच्या विकासाची हुरहूर राजेश दादांच्या मनी होती. देश तर प्रगतीपथावर आहे पण याच भारत देशातील असे अनेक दुर्गम पाडे, गावं त्यांना खुणावत होते ज्यांच्यापर्यंत विकासाची गंगाच पोहोचली नव्हती. अखेर तो दिवस आला आपल्या मतदार संघाच्या विकासासाठी भरगच्च पगाराच्या सरकारी नोकरीला दादांनी ’अखेरचा राम राम' दिला.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0सातपुड्याची राकटता, सह्याद्रीची कणखरता, त्यांच्या नसानसांत भिनभिनली होती. आपल्या लोकांसाठी त्यांनी आपला पाय मतदार संघात ठेवला. पायाला भिंगरी बांधून अख्खा मतदारसंघ पिंजून काढला. पाड्यापासून शहरापर्यंत प्रत्येक नागरिकाची समस्या जाणून ती सोडवण्याचा प्रयत्न केला आणि 2019 साली भारतीय जनता पक्षाकडून आताचे मुख्यमंत्री देवेंद्रजी फडणवीस यांच्या नेतृत्वाखाली शहादा – तळोदा मतदार संघातून उमेदवारी मिळवत जनतेच्या आशीर्वादरुपी भरघोस मतांनी ते विजयी झाले. राजेश दादानी या विजयाला सार्थ ठरवण्यासाठी सर्वप्रथम तर 'आमदार' शब्दाची भनक सुद्धा नसलेल्या भागात जाऊन जनसंपर्क खूप मजबूत केला. जनतेला त्यांनी आपलंसं केलं.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0मतदार संघातील पायाभूत सुविधांवर लक्ष केंद्रित करत राजेशजी पाडवी यांनी शासन दरबारी आपल्या मतदार संघाच्या समस्या व त्यावरील उपाय योजने संदर्भात प्रस्ताव मांडले आणि खऱ्या अर्थाने आपला मतदारसंघ प्रगतीपथावर येऊ लागला. लॉकडाऊनमध्ये मतदार संघातील 27 हजार स्थलांतरितांना स्वगृही परत आणण्यासाठी त्यांनी पुढाकार घेतला. आणि या स्थलांतरितांचे एकूण 14 कोटी रुपये मोल मजुरीचे परत मिळवून दिले.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0आपला आदिवासी समाज अंधश्रद्धेला बळी पडू नये म्हणून कोरोनाच्या दुसऱ्या लाटेत त्यांनी स्वतः आधी लस घेतली आणि एवढ्यावरच न थांबता त्यांनी लसीकरण जनजागृतीसाठी अनोखा विडा उचलला बहुरूपी, सोंगाड्या यांच्या रूपात आदिवासी भाषेत गावोगावी, आणि पाड्यापाड्यांमध्ये लसीकरणाचं महत्व पटवून दिलं.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0आपला मतदार संघ शेतीप्रधान आहे हे त्यांनी योग्य वेळी हेरलं आणि शेतकरी बांधवांशी त्यांनी सख्ख्य जपलं. जमीन सिंचनाखाली आणणं, गावोगावी रस्त्यांची कनेक्टिव्हिटी वाढवण, शिक्षण, रोजगार यावर त्यांनी जोर देत. मनामनात आणि घराघरात आपलं स्थान निर्माण केलं आहे.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0मतदार संघातील याच सगळ्या कामाच्या जोरावर 2024 साली राजेश दादांना जनतेने मोठी साथ देत, प्रचंड मताधिक्याने निवडून आणलं आणि हा मताधिक्याचा आकडा अचंबित करणारा ठरला आणि आमचे दादा कार्यसम्राट बनले. शहादा-तळोदा विधानसभा मतदार संघातील मतदार राजाने आपल्याला दिलेली संधी आहे याचं सोनं करत पुन्हा नव्या उमेदीने, ताकदीने कामाला लागले. आता मतदार संघात अनेक ड्रीम प्रोजेक्ट्स येतील. जाहीरनाम्यात दिलेलं वचनपूर्तीसाठी राजेश दादा सदैव तयार आहेत. मतदारसंघातील प्रत्येक मनाच्या पाठीशी दादा आहेत. शहादा MIDC, मतदार संघात शिक्षणाची उत्तम सुविधा, सिंचित जमीन यासाठी सातत्याने पाठपुरावा सुरू आहे.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0आरोग्य सेवा बळकट करण्यासाठी तसंच या क्षेत्राला आणखी बळ देण्यासाठी राजेश पाडवी साहेबांचे प्रयत्न सुरू आहेत. 6 रुग्णवाहिका निःशुल्क पद्धतीने कार्यरत असून मतदार संघातील 1000 पेक्षा अधिक रुग्णाच्या वेगवेगळ्या शस्त्रक्रिया मोफत केल्या गेल्या आहेत.
      
      \u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0एका राजासारखा प्रजेला आपलंस करणारा आपला नेता म्हणजे आमदार राजेशदादा पाडवी. झटकन चर्चा पटकन निर्णय घेत ते जनतेसाठी, मतदार संघाच्या विकासासाठी कार्य करत आहेत. दादांची विशेष बाब म्हणजे मतदार संघातल्या कुणा व्यक्तीने त्यांना फोन केला आणि त्यांनी त्याला उत्तर दिलं नाही असं कदापी होत नाही. लहानग्यापासून मोठ्यांपर्यंत सगळ्यांशी सामंजस्याने वागणारं नेतृत्व शहादा तळोदा मतदार संघाला लाभलं आणि म्हणून या मतदार संघाचा कायापालट व्हायला सुरुवात झाली. आपल्या लोकांसाठी अविरत झटणारं हे नेतृत्व आहे. दादांच्या माध्यमातून आणि जनतेच्या आशीर्वाद रूपाने नक्कीच आपला मतदार संघ स्मार्ट आणि समृद्ध बनेल यात तिळमात्र शंका नाही.
      
      चला तर मग, दादांच्या सोबत उभं राहून आपल्या भागाचा नवा इतिहास घडवूया!
      ''',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
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
