import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';

class RestAndSleepScreen extends StatefulWidget {
  const RestAndSleepScreen({Key? key}) : super(key: key);

  @override
  State<RestAndSleepScreen> createState() => _RestAndSleepScreenState();
}

class _RestAndSleepScreenState extends State<RestAndSleepScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, List<Map<String, dynamic>>> sleepPhaseData = {
    'early': [],
    'middle': [],
    'late': [],
  };

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for Rest and Sleep');
      
      // Get data from "articles" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      print('📄 Fetching articles with category: Home');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: 'Home')
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "Home"');
      
      // Filter for sleep-related articles and categorize by pregnancy phase
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toLowerCase();
        final content = (data['content'] ?? '').toLowerCase();
        final subtitle = (data['subtitle'] ?? '').toLowerCase();
        
        if (content.contains('sleep') || 
            content.contains('rest') || 
            content.contains('fatigue') || 
            content.contains('tired') ||
            title.contains('sleep') ||
            title.contains('rest') ||
            subtitle.contains('sleep') ||
            subtitle.contains('rest')) {
          
          final articleData = _extractArticleData(doc);
          
          // Categorize by pregnancy phase
          if (title.contains('months 1') || title.contains('first trimester') || 
              content.contains('first trimester') || content.contains('early pregnancy')) {
            sleepPhaseData['early']!.add(articleData);
          } else if (title.contains('months 4') || title.contains('second trimester') || 
                    content.contains('second trimester') || content.contains('middle pregnancy')) {
            sleepPhaseData['middle']!.add(articleData);
          } else if (title.contains('months 7') || title.contains('third trimester') || 
                    content.contains('third trimester') || content.contains('late pregnancy')) {
            sleepPhaseData['late']!.add(articleData);
          } else {
            // If we can't determine the phase, put it in the early phase
            sleepPhaseData['early']!.add(articleData);
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
                          'Loading sleep tips...',
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
                  : (sleepPhaseData['early']!.isEmpty && 
                     sleepPhaseData['middle']!.isEmpty && 
                     sleepPhaseData['late']!.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.nightlight_outlined, 
                                 size: 50, 
                                 color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No rest and sleep content available',
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
                                    'Rest and sleep',
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
                                  'Tips to help you get better sleep during pregnancy',
                                  style: GoogleFonts.inriaSerif(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Early phase (Months 1-3)
                                if (sleepPhaseData['early']!.isNotEmpty)
                                  _buildPhaseSection(
                                    sleepPhaseData['early']!, 
                                    Colors.purple.shade100, 
                                    'Sleep During Early Pregnancy (Months 1-3)',
                                    LinearGradient(
                                      colors: [Colors.purple.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.nightlight_round,
                                  ),
                                  
                                const SizedBox(height: 24),
                                  
                                // Middle phase (Months 4-6)
                                if (sleepPhaseData['middle']!.isNotEmpty)
                                  _buildPhaseSection(
                                    sleepPhaseData['middle']!, 
                                    Colors.pink.shade100, 
                                    'Sleep During Mid-Pregnancy (Months 4-6)',
                                    LinearGradient(
                                      colors: [Colors.pink.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.nights_stay,
                                  ),
                                  
                                const SizedBox(height: 24),
                                  
                                // Late phase (Months 7-9)
                                if (sleepPhaseData['late']!.isNotEmpty)
                                  _buildPhaseSection(
                                    sleepPhaseData['late']!, 
                                    Colors.indigo.shade100, 
                                    'Sleep During Late Pregnancy (Months 7-9)',
                                    LinearGradient(
                                      colors: [Colors.indigo.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.bedtime,
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
  
  Widget _buildPhaseSection(
    List<Map<String, dynamic>> articles, 
    Color borderColor, 
    String sectionTitle,
    Gradient backgroundGradient,
    IconData sectionIcon
  ) {
    // Try to find a title from the articles that matches the phase
    String displayTitle = articles.any((article) => 
      article['title'].toString().toLowerCase().contains('sleep') && 
      (article['title'].toString().toLowerCase().contains('month') || 
       article['title'].toString().toLowerCase().contains('trimester')))
      ? articles.firstWhere((article) => 
          article['title'].toString().toLowerCase().contains('sleep') && 
          (article['title'].toString().toLowerCase().contains('month') || 
           article['title'].toString().toLowerCase().contains('trimester')), 
          orElse: () => {'title': sectionTitle})['title']
      : sectionTitle;
      
    // Try to find a Firestore image for the section from the articles
    String? firestoreHeaderImage = null;
    for (var article in articles) {
      if (article['images'] != null && 
          article['images'].isNotEmpty && 
          article['images'][0].toString().startsWith('http')) {
        firestoreHeaderImage = article['images'][0];
        break;
      }
    }
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
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
          
          // Header Image
          if (firestoreHeaderImage != null) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: firestoreHeaderImage,
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
            ),
          
          // Articles
          ...articles.map((article) {
            // Skip displaying the title article again
            if (article['title'] == displayTitle) {
              return const SizedBox.shrink();
            }
            
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, article['title'] == sectionTitle ? 16 : 0, 16, 16),
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
                  
                  // Article image (if available)
                  if (article['images'] != null && 
                      article['images'].isNotEmpty && 
                      article['images'][0].toString().startsWith('http')) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _buildImageSection(article['images']),
                    ),
                  ],
                  
                  // Divider between articles (except the last one)
                  if (article != articles.last)
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
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImageViewerPage(imageUrl: imageUrls[index]),
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
                    imageUrl: imageUrls[index],
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