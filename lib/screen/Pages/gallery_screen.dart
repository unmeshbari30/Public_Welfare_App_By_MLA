import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {



  Widget getScaffold(HomeState state){

     List<Map<String, String>> galleryItems = [
    {
      'imagePath': "lib/assets/Gallery/ranipur_info.jpeg",
      'description': "राणीपूर येथील धरणावर जाऊन परिसरातील शेतकरी बांधवांना धरणातील गाळ त्यांच्या शेतात टाकण्याचे उपक्रमास सुरवात झाली. या उपक्रमामुळे शेतजमिनींची सुपीकता वाढेल आणि धरणातील पाणीसाठाही वाढण्यास मदत होईल. समृद्ध शेती आणि भरभराटीचा मार्ग याच उपक्रमातून नक्की खुलणार! शेतकरी राजा जिंदाबाद!",
    },
    {
      'imagePath': "lib/assets/Gallery/amoni_aasharam.jpeg",
      'description': "मा. महाराष्ट्र राज्याचे आदिवासी विकास मंत्री डॉ. अशोक उईके साहेब यांच्या संवाद चिमुकल्यांशी अभियानांतर्गत मा. आ. राजेशदादा पाडवी यांनी अमोनी आश्रम शाळेतील विद्यार्थ्यांशी संवाद साधला आणि त्यांचे प्रश्न, स्वप्ने व भविष्यासाठीच्या संधींवर मनमोकळा चर्चा केली."
    },
    
    {
      "imagePath": "lib/assets/Gallery/raksha_bandhan.jpeg",
      "description": "तळोदा येथे सार्वजनिक रक्षाबंधन निमित्ताने महिला चे समस्या ऐकून घेतले"
    },
    {
      "imagePath": "lib/assets/Gallery/birsa_munda.jpeg",
      "description": "तळोदा येथे आदिवासी दिनानिमित्ताने भगवान बिरसा मुंडा यांना अभिवादन केले"
    },
    {
      "imagePath": "lib/assets/bhausaheb.jpeg",
      "description": "लोणखेडा येथे अण्णासाहेब पी. के. अण्णा पाटील यांचा पुतळ्यास अभिवादन केले"

    }
  ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("गॅलरी"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                // Center(
                //   child: Text("To be updated soon...", style:  TextStyle(fontSize: 22),),
                // )
            
            
            
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
        )
      ),
    );

  }

  
  @override
  Widget build(BuildContext context) {
    var homeStateAsync = ref.watch(homeControllerProvider);
    return homeStateAsync.when(
      data: (state) => getScaffold(state), 
      error:  (error, stackTrace) => const Scaffold(
              body: Text("Something Went Wrong"),
            ), 
      loading:  () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}