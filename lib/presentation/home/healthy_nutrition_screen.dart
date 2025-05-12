import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';

class HealthyNutritionScreen extends StatefulWidget {
  const HealthyNutritionScreen({Key? key}) : super(key: key);

  @override
  State<HealthyNutritionScreen> createState() => _HealthyNutritionScreenState();
}

class _HealthyNutritionScreenState extends State<HealthyNutritionScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> faqsData = [];

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for Healthy Nutrition');
      
      // Get data from "articles" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      print('📄 Fetching articles with category: Home');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: 'Home')
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "Home"');
      
      List<Map<String, dynamic>> tempFaqs = [];
      
      // Filter for nutrition-related articles
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toLowerCase();
        final content = (data['content'] ?? '').toLowerCase();
        final subtitle = (data['subtitle'] ?? '').toLowerCase();
        
        if (content.contains('nutrition') || 
            content.contains('diet') || 
            content.contains('food') || 
            content.contains('eating') ||
            title.contains('nutrition') ||
            title.contains('diet') ||
            title.contains('food') ||
            subtitle.contains('nutrition') ||
            subtitle.contains('food') ||
            subtitle.contains('faq')) {
          
          tempFaqs.add(_extractArticleData(doc));
        }
      }
      
      setState(() {
        faqsData = tempFaqs;
        _isLoading = false;
      });
      
    } catch (e) {
      print('❌ Error fetching Firestore data: $e');
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }
  
  Map<String, dynamic> _extractArticleData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return {
      'id': doc.id,
      'title': data['title'] ?? 'No Title',
      'subtitle': data['subtitle'] ?? '',
      'content': data['content'] ?? 'No content available',
      'images': data['images'] ?? <String>[],
      'publicationDate': data['publicationDate'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBarWithBackArrow(),
            
            Expanded(
              child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading nutrition information...',
                          style: GoogleFonts.inriaSerif(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, 
                                 size: 50, 
                                 color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inriaSerif(
                                textStyle: const TextStyle(
                                  color: Colors.red, 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : faqsData.isEmpty 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu, 
                                 size: 50, 
                                 color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No nutrition content available',
                              style: GoogleFonts.inriaSerif(
                                textStyle: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    faqsData.any((faq) => faq['subtitle'].toString().toLowerCase().contains('faq')) ?
                                    'Nutrition FAQ' : 'Healthy Nutrition',
                                    style: GoogleFonts.inriaSerif(
                                      textStyle: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                Text(
                                  'Important nutritional information for pregnancy',
                                  style: GoogleFonts.inriaSerif(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // FAQ Header Card
                                if (faqsData.any((faq) => faq['subtitle'].toString().toLowerCase().contains('faq')))
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.pink.shade50, Colors.white],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.shade100.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(color: Colors.pink.shade100, width: 2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.help_outline, 
                                                 color: Colors.pink.shade300,
                                                 size: 24),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                faqsData.firstWhere(
                                                  (faq) => faq['subtitle'].toString().toLowerCase().contains('faq'),
                                                  orElse: () => {'subtitle': 'Frequently Asked Questions'}
                                                )['subtitle'],
                                                style: GoogleFonts.inriaSerif(
                                                  textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        if (faqsData.isNotEmpty && 
                                            faqsData[0]['images'] != null && 
                                            faqsData[0]['images'].isNotEmpty && 
                                            faqsData[0]['images'][0].toString().startsWith('http')) ...[
                                          const SizedBox(height: 12),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: faqsData[0]['images'][0],
                                              height: 160,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                height: 160,
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => const SizedBox.shrink(),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                
                                // FAQ Items
                                ...faqsData.where((faq) => 
                                   !faq['subtitle'].toString().toLowerCase().contains('faq') || 
                                   faq != faqsData.firstWhere(
                                     (f) => f['subtitle'].toString().toLowerCase().contains('faq'),
                                     orElse: () => {'id': ''}
                                   )
                                ).map((faq) => _buildFaqCard(faq)),
                                
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFaqCard(Map<String, dynamic> faq) {
    final List<String> images = faq['images'] != null 
        ? List<String>.from(faq['images']) 
        : [];
        
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.pink.shade100, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FAQ Question with Q icon
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'Q',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    faq['title'],
                    style: GoogleFonts.inriaSerif(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // FAQ Answer
          Padding(
            padding: EdgeInsets.fromLTRB(56, 0, 16, images.isEmpty ? 16 : 8),
            child: Text(
              faq['content'],
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          
          // FAQ Images (if available)
          if (images.isNotEmpty && images[0].toString().startsWith('http')) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewerPage(imageUrl: images[0]),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: images[0],
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 