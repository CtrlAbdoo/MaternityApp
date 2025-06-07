import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDetailsScreen extends StatefulWidget {
  final String title;
  final String category;
  final String imagePath;

  const HomeDetailsScreen({
    Key? key,
    required this.title,
    required this.category,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> articlesData = [];

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for topic: ${widget.title}');
      print('⚠️ Category: ${widget.category}');
      
      // Get data from "article" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('article');
      print('📄 Fetching articles with category: ${widget.category}');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: widget.category)
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "${widget.category}"');
      
      List<Map<String, dynamic>> tempArticles = [];
      
      // Filter articles based on keywords in title or content if needed
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toLowerCase();
        final content = (data['content'] ?? '').toLowerCase();
        
        // For home category, filter based on topic related keywords
        if (_isRelevantToTopic(data, widget.title)) {
          tempArticles.add(_extractArticleData(doc));
          print('✅ Categorized for ${widget.title}: ${data['title']}');
        }
      }
      
      // Sort articles by createdAt
      tempArticles.sort((a, b) {
        try {
          // Handle Firestore timestamp format
          final dateA = (a['createdAt'] as String?)?.split('T')[0] ?? '';
          final dateB = (b['createdAt'] as String?)?.split('T')[0] ?? '';
          return dateA.compareTo(dateB); // Ascending order
        } catch (e) {
          print('⚠️ Error sorting dates: $e');
          return 0;
        }
      });
      
      // Log the sorted order
      print('📅 Sorted articles for ${widget.title}:');
      for (var article in tempArticles) {
        print('  - ${article['title']} (${article['createdAt']})');
      }
      
      // If we still don't have any articles, use placeholder content
      if (tempArticles.isEmpty) {
        print('⚠️ No matching articles found, adding placeholder content');
        tempArticles.add({
          'id': 'placeholder',
          'title': widget.title,
          'subtitle': 'Important information',
          'content': _getPlaceholderContent(),
          'images': <String>[],
          'publicationDate': DateTime.now().toString().substring(0, 10),
        });
      }
      
      setState(() {
        articlesData = tempArticles;
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
  
  bool _isRelevantToTopic(Map<String, dynamic> data, String topic) {
    final title = (data['title'] ?? '').toLowerCase();
    final subtitle = (data['subtitle'] ?? '').toLowerCase();
    final content = (data['content'] ?? '').toLowerCase();
    
    // Keywords for each topic
    final Map<String, List<String>> topicKeywords = {
      'Healthy nutrition': [
        'nutrition', 'food', 'diet', 'healthy', 'eating', 'meal', 'nutrient'
      ],
      'Physical activity': [
        'exercise', 'activity', 'workout', 'fitness', 'physical', 'movement', 'strength'
      ],
      'Rest and sleep': [
        'rest', 'sleep', 'nap', 'insomnia', 'fatigue', 'tired', 'relaxation'
      ],
      'Baby care tips': [
        'baby', 'care', 'newborn', 'infant', 'diaper', 'bath', 'feeding'
      ],
    };
    
    // Get keywords for the current topic
    final keywords = topicKeywords[topic] ?? [];
    
    // Check if any keyword is in the title, subtitle, or first 200 characters of content
    for (final keyword in keywords) {
      if (title.contains(keyword) || 
          subtitle.contains(keyword) || 
          content.substring(0, content.length > 200 ? 200 : content.length).contains(keyword)) {
        return true;
      }
    }
    
    return false;
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
  
  String _getPlaceholderContent() {
    switch (widget.title) {
      case 'Healthy nutrition':
        return "Proper nutrition during pregnancy and postpartum is essential for both mother and baby. A balanced diet with adequate nutrients supports healthy development and recovery.";
      case 'Physical activity':
        return "Regular, moderate physical activity during pregnancy can help reduce discomfort, improve mood, and prepare your body for childbirth. Always consult with your healthcare provider about appropriate exercises.";
      case 'Rest and sleep':
        return "Getting adequate rest and quality sleep is crucial during pregnancy and after childbirth. Good sleep habits contribute to overall health and can help manage stress and fatigue.";
      case 'Baby care tips':
        return "Caring for a newborn involves learning about feeding, diapering, bathing, and understanding your baby's cues. These fundamental skills help build confidence in your parenting journey.";
      default:
        return "This section provides important information about ${widget.title.toLowerCase()}. Check back soon for detailed articles and resources.";
    }
  }
  
  IconData _getIconForArticle(String title) {
    final titleLower = title.toLowerCase();
    
    if (widget.title == 'Healthy nutrition') {
      return Icons.restaurant;
    } else if (widget.title == 'Physical activity') {
      return Icons.fitness_center;
    } else if (widget.title == 'Rest and sleep') {
      return Icons.nightlight_round;
    } else if (widget.title == 'Baby care tips') {
      return Icons.child_care;
    } else {
      return Icons.info_outline;
    }
  }
  
  Color _getAccentColor() {
    switch (widget.title) {
      case 'Healthy nutrition':
        return Colors.green;
      case 'Physical activity':
        return Colors.blue;
      case 'Rest and sleep':
        return Colors.purple;
      case 'Baby care tips':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  MaterialColor _getAccentMaterialColor() {
    switch (widget.title) {
      case 'Healthy nutrition':
        return Colors.green;
      case 'Physical activity':
        return Colors.blue;
      case 'Rest and sleep':
        return Colors.purple;
      case 'Baby care tips':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    
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
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            style: GoogleFonts.inriaSerif(
                              textStyle: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = null;
                              });
                              fetchFirestoreData();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.inriaSerif(
                              textStyle: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Topic Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              widget.imagePath,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _getAccentMaterialColor().shade200,
                                        _getAccentMaterialColor().shade100,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    _getIconForArticle(''),
                                    size: 50,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Articles
                          ...articlesData.map((article) => _buildArticleCard(article)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    final accentColor = _getAccentColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article['subtitle'] != null && article['subtitle'].isNotEmpty) ...[
            Row(
              children: [
                Icon(_getIconForArticle(article['title']), color: accentColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    article['subtitle'],
                    style: GoogleFonts.inriaSerif(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          
          // Article Content
          Text(
            article['content'],
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          
          // Images
          if (article['images'] != null && article['images'].isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: List<String>.from(article['images']).length,
                itemBuilder: (context, index) {
                  final imageUrl = List<String>.from(article['images'])[index];
                  return Padding(
                    padding: EdgeInsets.only(right: index < List<String>.from(article['images']).length - 1 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImageViewerPage(imageUrl: imageUrl),
                          ),
                        );
                      },
                      child: Hero(
                        tag: imageUrl,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: 300,
                            placeholder: (context, url) => Container(
                              width: 300,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              print('❌ Error loading image: $error');
                              return Container(
                                width: 300,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          
          // Publication Date
          if (article['publicationDate'] != null && article['publicationDate'].isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "Published: ${article['publicationDate']}",
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 