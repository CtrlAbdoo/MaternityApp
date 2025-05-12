import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class PhysicalActivityScreen extends StatefulWidget {
  const PhysicalActivityScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, List<Map<String, dynamic>>> activityData = {
    'intro': [],
    'benefits': [],
    'exercises': [],
    'tips': [],
  };

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for Physical Activity');
      
      // Get data from "articles" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      print('📄 Fetching articles with category: Home');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: 'Home')
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "Home"');
      
      // Direct query for specific IDs we know contain relevant content
      final List<String> knownActivityArticleIds = [
        'Fe1UF7coYl1LLR8Mt0mc', // Physical activity with Helpful Tips
        // Add more known IDs here if available
      ];
      
      // Try to fetch the specific articles first
      for (String articleId in knownActivityArticleIds) {
        try {
          final docSnapshot = await FirebaseFirestore.instance.collection('articles').doc(articleId).get();
          if (docSnapshot.exists) {
            final articleData = _extractArticleData(docSnapshot);
            activityData['tips']!.add(articleData);
            print('✅ Added known article: ${articleData['title']}');
          }
        } catch (e) {
          print('⚠️ Error fetching specific article $articleId: $e');
        }
      }
      
      // Filter for physical activity related articles
      for (var doc in querySnapshot.docs) {
        // Skip articles we've already added by ID
        if (knownActivityArticleIds.contains(doc.id)) continue;
        
        final data = doc.data();
        final title = (data['title'] ?? '').toLowerCase();
        final content = (data['content'] ?? '').toLowerCase();
        final subtitle = (data['subtitle'] ?? '').toLowerCase();
        
        if (content.contains('physical activity') || 
            content.contains('exercise') || 
            title.contains('physical') ||
            title.contains('exercise') ||
            subtitle.contains('exercise') ||
            subtitle.contains('activity') ||
            subtitle.contains('helpful tips')) {
          
          final articleData = _extractArticleData(doc);
          
          // Categorize by content type
          if (title.contains('introduction') || title.contains('overview') || 
              title.contains('about') || content.contains('introduction') ||
              title.contains('pregnancy') && title.contains('exercise')) {
            activityData['intro']!.add(articleData);
          } else if (title.contains('benefit') || subtitle.contains('benefit') || 
                     content.contains('benefit')) {
            activityData['benefits']!.add(articleData);
          } else if (title.contains('exercise') || subtitle.contains('exercise') || 
                     content.contains('workout')) {
            activityData['exercises']!.add(articleData);
          } else if (title.contains('tip') || subtitle.contains('tip') || 
                     content.contains('recommendation') || content.contains('advice') ||
                     subtitle.toLowerCase() == 'helpful tips:' ||
                     content.contains('drink plenty of water') ||
                     content.contains('get enough sleep')) {
            activityData['tips']!.add(articleData);
          } else {
            // Check content for specific tips first
            if (content.contains('water') || content.contains('breastfeeding') || 
                content.contains('rest') || content.contains('sleep')) {
              activityData['tips']!.add(articleData);
            } else {
              // Default to exercises if no specific category matches
              activityData['exercises']!.add(articleData);
            }
          }
        }
      }
      
      // For empty sections, try to find more general matches from other categories
      if (activityData['intro']!.isEmpty || 
          activityData['benefits']!.isEmpty || 
          activityData['exercises']!.isEmpty || 
          activityData['tips']!.isEmpty) {
        
        try {
          final generalArticles = await FirebaseFirestore.instance
              .collection('articles')
              .where('category', isNotEqualTo: 'Home')
              .get();
              
          for (var doc in generalArticles.docs) {
            final data = doc.data();
            final title = (data['title'] ?? '').toLowerCase();
            final content = (data['content'] ?? '').toLowerCase();
            
            if ((content.contains('physical activity') || 
                content.contains('exercise') || 
                title.contains('physical') ||
                title.contains('exercise'))) {
              
              final articleData = _extractArticleData(doc);
              
              // Fill in missing sections
              if (activityData['intro']!.isEmpty && 
                  (title.contains('introduction') || title.contains('overview'))) {
                activityData['intro']!.add(articleData);
              } else if (activityData['benefits']!.isEmpty && 
                       (title.contains('benefit') || content.contains('benefit'))) {
                activityData['benefits']!.add(articleData);
              } else if (activityData['exercises']!.isEmpty && 
                       (title.contains('exercise') || content.contains('workout'))) {
                activityData['exercises']!.add(articleData);
              } else if (activityData['tips']!.isEmpty && 
                       (title.contains('tip') || content.contains('advice'))) {
                activityData['tips']!.add(articleData);
              }
            }
          }
        } catch (e) {
          print('⚠️ Error fetching general articles: $e');
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
            const CustomAppBarWithLogo(),
            
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
                          'Loading physical activity information...',
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
                  : (activityData['intro']!.isEmpty && 
                     activityData['benefits']!.isEmpty && 
                     activityData['exercises']!.isEmpty &&
                     activityData['tips']!.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center, 
                                 size: 50, 
                                 color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No physical activity content available',
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
                                    'Physical activity',
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
                                  'Safe exercises during and after pregnancy',
                                  style: GoogleFonts.inriaSerif(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Introduction section
                                if (activityData['intro']!.isNotEmpty)
                                  _buildActivitySection(
                                    activityData['intro']!, 
                                    Colors.pink.shade100, 
                                    'About Physical Activity During Pregnancy',
                                    LinearGradient(
                                      colors: [Colors.pink.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.fitness_center,
                                  ),
                                  
                                const SizedBox(height: 20),
                                  
                                // Benefits section
                                if (activityData['benefits']!.isNotEmpty)
                                  _buildActivitySection(
                                    activityData['benefits']!, 
                                    Colors.purple.shade100, 
                                    'Benefits of Regular Exercise',
                                    LinearGradient(
                                      colors: [Colors.purple.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.favorite_outline,
                                  ),
                                  
                                const SizedBox(height: 20),
                                  
                                // Exercises section
                                if (activityData['exercises']!.isNotEmpty)
                                  _buildActivitySection(
                                    activityData['exercises']!, 
                                    Colors.blue.shade100, 
                                    'Recommended Exercises',
                                    LinearGradient(
                                      colors: [Colors.blue.shade50, Colors.white],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    Icons.directions_run,
                                  ),
                                  
                                const SizedBox(height: 20),
                                  
                                // Tips section
                                if (activityData['tips']!.isNotEmpty)
                                  _buildActivitySection(
                                    activityData['tips']!, 
                                    Colors.teal.shade100, 
                                    'Safety Tips & Guidelines',
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
  
  Widget _buildActivitySection(
    List<Map<String, dynamic>> articles, 
    Color borderColor, 
    String sectionTitle,
    Gradient backgroundGradient,
    IconData sectionIcon
  ) {
    // Try to find a title from the articles that matches the section
    String displayTitle = articles.any((article) => 
      article['title'].toString().toLowerCase().contains('exercise') ||
      article['title'].toString().toLowerCase().contains('physical activity'))
      ? articles.firstWhere((article) => 
          article['title'].toString().toLowerCase().contains('exercise') ||
          article['title'].toString().toLowerCase().contains('physical activity'), 
          orElse: () => {'title': sectionTitle})['title']
      : sectionTitle;
      
    // Special case for tips section if there's a specific helpful tips article
    if (sectionTitle.contains('Tips') && 
        articles.any((article) => article['subtitle'].toString().toLowerCase().contains('helpful tips'))) {
      displayTitle = 'Helpful Tips';
    }

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
            // Format tips in a special way if they contain bullet-like content
            final bool isTip = article['subtitle'].toString().toLowerCase().contains('tip') ||
                              sectionTitle.contains('Tips');
            final content = article['content'] ?? '';
            final List<String> contentItems = _extractContentItems(content);
            
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
                
                  // Subtitle if present
                  if (article['subtitle'] != null && article['subtitle'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        article['subtitle'],
                        style: GoogleFonts.inriaSerif(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                
                  // Display as bullet points if tips and multiple items detected
                  if (isTip && contentItems.length > 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contentItems.map((item) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_outline, 
                                     size: 18, 
                                     color: Colors.pink.shade300),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.trim(),
                                    style: GoogleFonts.inriaSerif(
                                      textStyle: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  // Otherwise display as regular text
                  else if (article['content'].isNotEmpty)
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

  // Helper method to extract bullet-like content items
  List<String> _extractContentItems(String content) {
    if (content.isEmpty) return [];
    
    // Check if the content has natural sentence breaks
    if (content.contains('. ')) {
      return content.split('. ')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.endsWith('.') ? s : '$s.')
        .toList();
    }
    
    // Check for other bullet-like formats
    if (content.contains('- ')) {
      return content.split('- ')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    }
    
    // If it has commas and is relatively short, it might be a list
    if (content.contains(', ') && content.length < 150) {
      return content.split(', ')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    }
    
    // Return the full content as a single item if no patterns match
    return [content];
  }
} 