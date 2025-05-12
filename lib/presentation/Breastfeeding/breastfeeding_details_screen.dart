import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class BreastfeedingDetailsScreen extends StatefulWidget {
  final String title;
  final String category;

  const BreastfeedingDetailsScreen({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  State<BreastfeedingDetailsScreen> createState() => _BreastfeedingDetailsScreenState();
}

class _BreastfeedingDetailsScreenState extends State<BreastfeedingDetailsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> articlesData = [];
  
  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }
  
  String _getTopicKeyword() {
    switch (widget.title) {
      case "Breastfeeding (Natural)":
        return "breastfeeding";
      case "Formula Feeding (Artificial)":
        return "formula";
      default:
        return widget.title.split(' ')[0].toLowerCase();
    }
  }
  
  bool _isRelevantToTopic(Map<String, dynamic> data, String topic) {
    final title = (data['title'] ?? '').toLowerCase();
    final subtitle = (data['subtitle'] ?? '').toLowerCase();
    final content = (data['content'] ?? '').toLowerCase();
    
    // Keywords for each topic
    final Map<String, List<String>> topicKeywords = {
      "Breastfeeding (Natural)": [
        "breastfeeding", "breast milk", "lactation", "nursing", "breast", "milk supply", "latch"
      ],
      "Formula Feeding (Artificial)": [
        "formula", "bottle feeding", "artificial", "prepared milk", "powdered milk", "bottle"
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
  
  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for topic: ${widget.title}');
      print('⚠️ Category: ${widget.category}');
      
      // Get data from "articles" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      print('📄 Fetching articles with category: ${widget.category}');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: widget.category)
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "${widget.category}"');
      
      List<Map<String, dynamic>> tempArticles = [];
      
      // Categorize articles to ensure they go to the right topic
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        
        if (doc.id.toLowerCase().contains(_getTopicKeyword().toLowerCase())) {
          // Direct ID match
          tempArticles.add(_extractArticleData(doc));
          print('✅ Categorized by ID for ${widget.title}: ${data['title']}');
        } else if (_isRelevantToTopic(data, widget.title)) {
          // Content-based match
          tempArticles.add(_extractArticleData(doc));
          print('✅ Categorized by content for ${widget.title}: ${data['title']}');
        }
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
      case "Breastfeeding (Natural)":
        return "Breastfeeding provides optimal nutrition for your baby and offers numerous health benefits for both mother and child. It helps build the baby's immune system, promotes bonding, and can reduce the risk of certain health conditions. Proper positioning and latch are key to successful breastfeeding.";
      case "Formula Feeding (Artificial)":
        return "Formula feeding is a safe and nutritious alternative to breastfeeding. It allows other family members to participate in feeding and provides a consistent feeding schedule. Proper preparation, storage, and feeding techniques are important for your baby's health and safety.";
      default:
        return "This section provides important information about ${widget.title.toLowerCase()}. Check back soon for detailed articles and resources.";
    }
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
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                  ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.title,
                            style: GoogleFonts.inriaSerif(
                              textStyle: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              article['title'],
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Article subtitle
          if (article['subtitle'] != null && article['subtitle'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article['subtitle'],
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          
          // Article content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              article['content'],
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
          
          // Images
          if (article['images'] != null && article['images'].isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: article['images'].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewerPage(
                            imageUrl: article['images'][index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(left: 16, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(article['images'][index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Publication date
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Published: ${article['publicationDate']}',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 