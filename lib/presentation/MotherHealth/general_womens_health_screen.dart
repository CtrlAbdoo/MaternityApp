import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralWomensHealthScreen extends StatefulWidget {
  const GeneralWomensHealthScreen({super.key});

  @override
  State<GeneralWomensHealthScreen> createState() => _GeneralWomensHealthScreenState();
}

class _GeneralWomensHealthScreenState extends State<GeneralWomensHealthScreen> {
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
      print('⚠️ Fetching data for topic: General Women\'s Health');
      
      final articlesRef = FirebaseFirestore.instance
          .collection('article')
          .doc('Mothers health')
          .collection('general-women-s-health');
      
      print('📄 Fetching general women\'s health articles');
      
      final querySnapshot = await articlesRef.get();
      
      print('📄 Found ${querySnapshot.docs.length} general women\'s health articles');
      
      List<Map<String, dynamic>> tempArticles = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        print('📝 Processing article: ${doc.id}');
        print('  - Title: ${data['title']}');
        print('  - Subtitle: ${data['subtitle']}');
        print('  - Content: ${data['content']}');
        
        tempArticles.add({
          'id': doc.id,
          'title': data['title'] ?? 'No Title',
          'subtitle': data['subtitle'] ?? '',
          'content': data['content'] ?? 'No content available',
          'images': data['images'] ?? <String>[],
          'publicationDate': data['publicationDate'] ?? '',
          'createdAt': data['createdAt'] ?? '',
        });
      }
      
      print('📊 Processed ${tempArticles.length} articles');
      
      tempArticles.sort((a, b) {
        try {
          final dateA = (a['createdAt'] as String?)?.split('T')[0] ?? '';
          final dateB = (b['createdAt'] as String?)?.split('T')[0] ?? '';
          return dateA.compareTo(dateB);
        } catch (e) {
          print('⚠️ Error sorting dates: $e');
          return 0;
        }
      });
      
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  IconData _getIconForArticle(String title) {
    final titleLower = title.toLowerCase();
    
    if (titleLower.contains('checkup') || titleLower.contains('medical')) {
      return Icons.medical_services;
    } else if (titleLower.contains('nutrition') || titleLower.contains('diet')) {
      return Icons.restaurant;
    } else if (titleLower.contains('exercise') || titleLower.contains('activity')) {
      return Icons.fitness_center;
    } else if (titleLower.contains('mental') || titleLower.contains('emotional')) {
      return Icons.psychology;
    } else if (titleLower.contains('cancer') || titleLower.contains('disease')) {
      return Icons.health_and_safety;
    } else {
      return Icons.info_outline;
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
                            'General Women\'s Health',
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
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade200,
                                    Colors.orange.shade100,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                Icons.female,
                                size: 50,
                                color: Colors.white.withOpacity(0.7),
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
        border: const Border(
          left: BorderSide(color: Colors.orangeAccent, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article['subtitle'] != null && article['subtitle'].isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  _getIconForArticle(article['title']), 
                  color: Colors.orangeAccent, 
                  size: 24
                ),
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
            ...List<String>.from(article['images']).map((imageUrl) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    height: 220,
                    width: double.infinity,
                    placeholder: (context, url) => 
                      const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => 
                      const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            )),
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