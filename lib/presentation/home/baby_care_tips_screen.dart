import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';

class BabyCareScreen extends StatefulWidget {
  const BabyCareScreen({Key? key}) : super(key: key);

  @override
  State<BabyCareScreen> createState() => _BabyCareScreenState();
}

class _BabyCareScreenState extends State<BabyCareScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, List<Map<String, dynamic>>> ageGroupData = {
    'birth_to_3': [],
    '3_to_6': [],
    '6_to_9': [],
    '9_to_12': [],
    '1_to_3_years': [],
    'general': [],
  };

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for Baby Care Tips');
      
      // Get data from "articles" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      print('📄 Fetching articles with category: Home');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: 'Home')
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "Home"');
      
      // Filter for baby care articles and categorize by age
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toLowerCase();
        final content = (data['content'] ?? '').toLowerCase();
        final subtitle = (data['subtitle'] ?? '').toLowerCase();
        
        if (content.contains('baby') || 
            content.contains('infant') || 
            content.contains('newborn') || 
            content.contains('child') ||
            title.contains('baby') ||
            title.contains('infant') ||
            title.contains('newborn') ||
            subtitle.contains('baby') ||
            subtitle.contains('care')) {
          
          final articleData = _extractArticleData(doc);
          
          // Categorize by age
          if (title.contains('birth') || title.contains('0-3') || 
              content.contains('newborn') || content.contains('first 3 months')) {
            ageGroupData['birth_to_3']!.add(articleData);
          } else if (title.contains('3-6') || title.contains('3 to 6') || 
                    content.contains('3-6 months') || content.contains('3 to 6 months')) {
            ageGroupData['3_to_6']!.add(articleData);
          } else if (title.contains('6-9') || title.contains('6 to 9') || 
                    content.contains('6-9 months') || content.contains('6 to 9 months')) {
            ageGroupData['6_to_9']!.add(articleData);
          } else if (title.contains('9-12') || title.contains('9 to 12') || 
                    content.contains('9-12 months') || content.contains('9 to 12 months')) {
            ageGroupData['9_to_12']!.add(articleData);
          } else if (title.contains('1-3 years') || title.contains('toddler') || 
                    content.contains('1-3 years') || content.contains('toddler')) {
            ageGroupData['1_to_3_years']!.add(articleData);
          } else {
            // General baby care tips
            ageGroupData['general']!.add(articleData);
          }
        }
      }
      
      setState(() {
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
                          'Loading baby care tips...',
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
                  : (ageGroupData['birth_to_3']!.isEmpty && 
                     ageGroupData['3_to_6']!.isEmpty && 
                     ageGroupData['6_to_9']!.isEmpty &&
                     ageGroupData['9_to_12']!.isEmpty &&
                     ageGroupData['1_to_3_years']!.isEmpty &&
                     ageGroupData['general']!.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.child_care_outlined, 
                                 size: 50, 
                                 color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No baby care content available',
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
                                    'Baby care tips',
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
                                  'Helpful guidance for caring for your baby',
                                  style: GoogleFonts.inriaSerif(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                
                                // Birth to 3 Months
                                if (ageGroupData['birth_to_3']!.isNotEmpty)
                                  _buildAgeSection(
                                    ageGroupData['birth_to_3']!, 
                                    Colors.pink.shade100, 
                                    'From Birth to 3 Months',
                                    LinearGradient(
                                      colors: [Colors.pink.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.child_care,
                                  ),
                                  
                                  
                                // 3 to 6 Months
                                if (ageGroupData['3_to_6']!.isNotEmpty)
                                  _buildAgeSection(
                                    ageGroupData['3_to_6']!, 
                                    Colors.purple.shade100, 
                                    'From 3 Months to 6 Months',
                                    LinearGradient(
                                      colors: [Colors.purple.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.toys,
                                  ),
                                  
                                  
                                // 6 to 9 Months
                                if (ageGroupData['6_to_9']!.isNotEmpty)
                                  _buildAgeSection(
                                    ageGroupData['6_to_9']!, 
                                    Colors.blue.shade100, 
                                    'From 6 Months to 9 Months',
                                    LinearGradient(
                                      colors: [Colors.blue.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.accessibility_new,
                                  ),
                                  
                                  
                                // 9 to 12 Months
                                if (ageGroupData['9_to_12']!.isNotEmpty)
                                  _buildAgeSection(
                                    ageGroupData['9_to_12']!, 
                                    Colors.green.shade100, 
                                    'From 9 Months to 1 Year',
                                    LinearGradient(
                                      colors: [Colors.green.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.sentiment_very_satisfied,
                                  ),
                                  
                                  
                                // 1 to 3 Years
                                if (ageGroupData['1_to_3_years']!.isNotEmpty)
                                  _buildAgeSection(
                                    ageGroupData['1_to_3_years']!, 
                                    Colors.orange.shade100, 
                                    'From 1 to 3 Years',
                                    LinearGradient(
                                      colors: [Colors.orange.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.face,
                                  ),
                                  
                                const SizedBox(height: 20),
                                  
                                // General Tips
                                if (ageGroupData['general']!.isNotEmpty)
                                  _buildAgeSection(
                                    ageGroupData['general']!, 
                                    Colors.teal.shade100, 
                                    'General Child Development & Parenting Tips',
                                    LinearGradient(
                                      colors: [Colors.teal.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.lightbulb_outline,
                                  ),
                                
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
  
  Widget _buildAgeSection(
    List<Map<String, dynamic>> articles, 
    Color borderColor, 
    String sectionTitle,
    Gradient backgroundGradient,
    IconData sectionIcon
  ) {
    // Try to find a title from the articles that matches the phase
    String displayTitle = articles.any((article) => 
      article['title'].toString().toLowerCase().contains('baby') &&
      (article['title'].toString().toLowerCase().contains('month') ||
       article['title'].toString().toLowerCase().contains('birth')))
      ? articles.firstWhere((article) => 
          article['title'].toString().toLowerCase().contains('baby') &&
          (article['title'].toString().toLowerCase().contains('month') ||
           article['title'].toString().toLowerCase().contains('birth')), 
          orElse: () => {'title': sectionTitle})['title']
      : sectionTitle;
      
    // Find Firestore images for this section if available
    Map<String, dynamic>? titleArticle = null;
    for (var article in articles) {
      if (article['images'] != null && 
          article['images'].isNotEmpty && 
          article['images'][0].toString().startsWith('http')) {
        titleArticle = article;
        break;
      }
    }
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Icon
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(sectionIcon, color: borderColor.withOpacity(0.8), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayTitle,
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
          ),
          
          // Header Image (if available from Firestore)
          if (titleArticle != null && 
              titleArticle['images'] != null && 
              titleArticle['images'].isNotEmpty &&
              titleArticle['images'][0].toString().startsWith('http'))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: titleArticle['images'][0],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
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
            
          // Articles - skip the title article if we're using it as header
          ...articles.where((article) => article != titleArticle).map((article) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article title
                  if (article['title'].isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, article['content'].isEmpty ? 16 : 8),
                      child: Text(
                        article['title'],
                        style: GoogleFonts.inriaSerif(
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                
                  // Article content
                  if (article['content'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        article['content'],
                        style: GoogleFonts.inriaSerif(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                
                  // Article image (if available and from Firestore)
                  if (article['images'] != null && 
                      article['images'].isNotEmpty && 
                      article['images'][0].toString().startsWith('http')) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _buildImageSection(article['images']),
                    ),
                  ],
                
                  // Divider between articles (except the last one)
                  if (article != articles.where((a) => a != titleArticle).toList().last)
                    Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: borderColor.withOpacity(0.3)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildImageSection(List<dynamic> images) {
    final List<String> imageUrls = List<String>.from(images)
        .where((url) => url.toString().startsWith('http')).toList();
    
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      height: 140,
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
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imagePath = imageUrls[index];
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImageViewerPage(imageUrl: imagePath),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      width: 140,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                      )),
                    ),
                    errorWidget: (context, url, error) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 