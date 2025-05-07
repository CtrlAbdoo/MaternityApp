import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicDetailsScreen extends StatefulWidget {
  final String title;
  final String category;

  const TopicDetailsScreen({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  State<TopicDetailsScreen> createState() => _TopicDetailsScreenState();
}

class _TopicDetailsScreenState extends State<TopicDetailsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> articlesData = [];
  
  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }
  
  String _getTopicCollectionName() {
    // Convert the title to a collection name format
    switch (widget.title) {
      case "Child Growth Stages":
        return "child_growth_stages";
      case "Complementary Feeding (Introducing Solid Foods)":
        return "complementary_feeding";
      case "Daily Baby Care":
        return "daily_baby_care";
      case "Baby Health and Common Illnesses":
        return "baby_health";
      case "Sensory and Motor Skills Development":
        return "sensory_motor_development";
      default:
        return widget.title.toLowerCase().replaceAll(' ', '_');
    }
  }
  
  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for topic: ${widget.title}');
      print('⚠️ Category: ${widget.category}');
      
      // First approach: Try to get data from "articles" collection filtered by category
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      print('📄 Fetching articles with category: ${widget.category}');
      
      final querySnapshot = await articlesRef
          .where('category', isEqualTo: widget.category)
          .get();
      
      print('📄 Found ${querySnapshot.docs.length} articles with category "${widget.category}"');
      
      // List all document IDs for debugging
      print('📋 All documents:');
      for (var doc in querySnapshot.docs) {
        print('  - ID: ${doc.id}');
        print('    Title: ${doc.data()['title'] ?? 'No title'}');
        print('    Subtitle: ${doc.data()['subtitle'] ?? 'No subtitle'}');
      }
      
      List<Map<String, dynamic>> tempArticles = [];
      
      // First, categorize articles to ensure they go to the right topic
      Map<String, List<Map<String, dynamic>>> categorizedArticles = {
        "Child Growth Stages": [],
        "Complementary Feeding (Introducing Solid Foods)": [],
        "Daily Baby Care": [],
        "Baby Health and Common Illnesses": [],
        "Sensory and Motor Skills Development": [],
      };
      
      // Pre-categorize all articles first
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toLowerCase();
        
        // Check specific keywords to pre-categorize
        if ((title.contains('4 to 6 month') || 
             title.contains('7 to 9 month') || 
             title.contains('stimulating activities') ||
             title.contains('sensory play') ||
             title.contains('motor development') ||
             title.contains('tummy time') ||
             title.contains('activities for'))) {
          // These should always go to Sensory and Motor Skills
          if (widget.title == "Sensory and Motor Skills Development") {
            categorizedArticles["Sensory and Motor Skills Development"]!.add(_extractArticleData(doc));
            print('✅ Pre-categorized for Sensory: ${data['title']}');
          }
        } else if (doc.id.toLowerCase().contains(_getTopicKeyword().toLowerCase())) {
          // Direct ID match
          categorizedArticles[widget.title]!.add(_extractArticleData(doc));
          print('✅ Pre-categorized by ID for ${widget.title}: ${data['title']}');
        } else if (_isRelevantToTopic(data, widget.title)) {
          // Content-based match
          categorizedArticles[widget.title]!.add(_extractArticleData(doc));
          print('✅ Pre-categorized by content for ${widget.title}: ${data['title']}');
        }
      }
      
      // Get articles for the current topic
      tempArticles = categorizedArticles[widget.title] ?? [];
      
      // Double check the Child Growth Stages to make sure there's no overlap
      if (widget.title == "Child Growth Stages") {
        print('🧹 Extra filtering for Child Growth Stages');
        
        // Extended list of excluded patterns for Child Growth Stages
        final List<String> excludedTitles = [
          '4 to 6 months',
          '7 to 9 months', 
          '10 to 12 months',
          'stimulating activities',
          'sensory play',
          'motor development',
          'tummy time',
          'activities for',
          'crawling',
          'walking',
          'fine motor',
          'gross motor'
        ];
        
        tempArticles = tempArticles.where((article) {
          final String title = (article['title'] ?? '').toLowerCase();
          final String subtitle = (article['subtitle'] ?? '').toLowerCase();
          final String content = (article['content'] ?? '').toLowerCase();
          
          // Check if any excluded title is contained in this article
          for (final excludedTitle in excludedTitles) {
            if (title.contains(excludedTitle) || subtitle.contains(excludedTitle)) {
              print('❌ Filtering out article from Child Growth Stages: ${article['title']}');
              return false; // Remove this article
            }
          }
          
          // Also check for motor and sensory keywords in content if they're prominent
          if ((content.contains('motor skill') || content.contains('sensory development')) && 
              (content.indexOf('motor skill') < 100 || content.indexOf('sensory development') < 100)) {
            print('❌ Filtering out article from Child Growth Stages based on content focus: ${article['title']}');
            return false;
          }
          
          return true; // Keep this article
        }).toList();
      }
      
      // Make sure sensory articles are in the right place
      if (widget.title == "Sensory and Motor Skills Development") {
        print('✅ Ensuring all sensory articles are included');
        
        // Include these specific topics in Sensory and Motor Skills Development
        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          final title = (data['title'] ?? '').toLowerCase();
          final articleData = _extractArticleData(doc);
          
          bool alreadyIncluded = tempArticles.any((a) => a['id'] == articleData['id']);
          
          if (!alreadyIncluded && 
              (title.contains('4 to 6 month') || 
               title.contains('7 to 9 month') || 
               title.contains('stimulating activities') ||
               title.contains('sensory play') ||
               title.contains('motor development') ||
               title.contains('tummy time') ||
               title.contains('activities for'))) {
            tempArticles.add(articleData);
            print('✅ Added special sensory article: ${articleData['title']}');
          }
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
      
      // Print final results to debug
      print('📝 Final articles for ${widget.title}:');
      for (var article in tempArticles) {
        print('  - ${article['title']}');
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
  
  String _getTopicKeyword() {
    switch (widget.title) {
      case "Child Growth Stages":
        return "growth";
      case "Complementary Feeding (Introducing Solid Foods)":
        return "feeding";
      case "Daily Baby Care":
        return "care";
      case "Baby Health and Common Illnesses":
        return "health";
      case "Sensory and Motor Skills Development":
        return "sensory";
      default:
        return widget.title.split(' ')[0].toLowerCase();
    }
  }
  
  bool _isRelevantToTopic(Map<String, dynamic> articleData, String topic) {
    // First, check if the article title directly matches the topic
    final String articleTitle = (articleData['title'] ?? '').toLowerCase();
    final String topicLower = topic.toLowerCase();
    
    // Handle specific categorization for Daily Baby Care
    if (topic == "Daily Baby Care") {
      // Explicitly include specific articles that should only be in this section
      if (articleTitle.contains("diaper") || 
          articleTitle.contains("changing") || 
          articleTitle.contains("skin care") ||
          articleTitle.contains("baby bath") ||
          articleTitle.contains("bathing")) {
        return true;
      }
    }
    
    // Ensure diaper and skin care articles don't appear in Health section
    if (topic == "Baby Health and Common Illnesses") {
      if (articleTitle.contains("diaper") || 
          articleTitle.contains("changing") || 
          articleTitle.contains("skin care") ||
          articleTitle.contains("bathing")) {
        return false;
      }
    }
    
    // Handle specific categorization for Sensory and Motor Skills
    if (topic == "Sensory and Motor Skills Development") {
      // Explicitly include specific articles that should only be in this section
      if (articleTitle.contains("4 to 6 months") || 
          articleTitle.contains("7 to 9 months") || 
          articleTitle.contains("10 to 12 months") ||
          articleTitle.contains("stimulating activities") ||
          articleTitle.contains("sensory play") ||
          articleTitle.contains("motor development") ||
          articleTitle.contains("tummy time") ||
          articleTitle.contains("activities for")) {
        return true;
      }
    }
    
    // For Child Growth Stages, more strictly filter out motor content
    if (topic == "Child Growth Stages") {
      // Explicitly exclude specific articles that should only be in Sensory/Motor Skills
      if (articleTitle.contains("4 to 6 months") || 
          articleTitle.contains("7 to 9 months") || 
          articleTitle.contains("10 to 12 months") ||
          articleTitle.contains("stimulating activities") ||
          articleTitle.contains("sensory play") ||
          articleTitle.contains("motor development") ||
          articleTitle.contains("tummy time") ||
          articleTitle.contains("activities for") ||
          articleTitle.contains("crawling") ||
          articleTitle.contains("walking") ||
          articleTitle.contains("fine motor") ||
          articleTitle.contains("gross motor")) {
        return false;
      }
    }
    
    // If we have a clear topic-specific article, give it priority
    if (topic == "Child Growth Stages" && 
        (articleTitle.contains("growth") || 
         articleTitle.contains("development") || 
         articleTitle.contains("milestone"))) {
      // Make sure it's not about motor/sensory specifically
      if (!articleTitle.contains("motor") && !articleTitle.contains("sensory")) {
        return true;
      }
    }
    
    if (topic == "Complementary Feeding (Introducing Solid Foods)" && 
        (articleTitle.contains("feeding") || 
         articleTitle.contains("food") ||
         articleTitle.contains("nutrition"))) {
      return true;
    }
    
    if (topic == "Daily Baby Care" && 
        (articleTitle.contains("care") || 
         articleTitle.contains("diaper") ||
         articleTitle.contains("bath") ||
         articleTitle.contains("skin care") ||
         articleTitle.contains("changing"))) {
      return true;
    }
    
    if (topic == "Baby Health and Common Illnesses" && 
        (articleTitle.contains("health") || 
         articleTitle.contains("illness") ||
         articleTitle.contains("sick") ||
         articleTitle.contains("disease"))) {
      // Make sure it's not about diaper or skin care specifically
      if (!articleTitle.contains("diaper") && 
          !articleTitle.contains("changing") && 
          !articleTitle.contains("skin care")) {
        return true;
      }
    }
    
    if (topic == "Sensory and Motor Skills Development" && 
        (articleTitle.contains("sensory") || 
         articleTitle.contains("motor") ||
         articleTitle.contains("skill") ||
         articleTitle.contains("development"))) {
      return true;
    }
    
    // If article doesn't have a clear topic in title, use more specific matching logic
    return _isRelevantByKeywords(articleData, topic);
  }
  
  bool _isRelevantByKeywords(Map<String, dynamic> articleData, String topic) {
    final String titleLower = (articleData['title'] ?? '').toLowerCase();
    final String subtitleLower = (articleData['subtitle'] ?? '').toLowerCase();
    final String contentLower = (articleData['content'] ?? '').toLowerCase();
    
    switch (topic) {
      case "Baby Health and Common Illnesses":
        // First exclude care-related articles that should be in Daily Baby Care
        if (titleLower.contains("diaper") || 
            titleLower.contains("changing") || 
            titleLower.contains("skin care") ||
            subtitleLower.contains("diaper") || 
            subtitleLower.contains("changing") || 
            subtitleLower.contains("skin care")) {
          return false;
        }
        
        // Then check for health-related keywords
        final healthKeywords = [
          'health', 'illness', 'disease', 'fever', 'infection', 'rash',
          'vaccine', 'vaccination', 'medication', 'doctor', 'pediatrician',
          'symptoms', 'cold', 'flu', 'ear infection', 'teething'
        ];
        
        for (var keyword in healthKeywords) {
          if (titleLower.contains(keyword) || subtitleLower.contains(keyword) || 
              contentLower.contains(keyword)) {
            // Extra check to make sure we're not including diaper/skin care articles
            if (!(titleLower.contains("diaper") || contentLower.startsWith("diaper changing:") || 
                  titleLower.contains("skin care") || contentLower.startsWith("skin care:"))) {
              return true;
            }
          }
        }
        return false;
      
      case "Daily Baby Care":
        // Explicitly include diaper and skin care articles in this section
        if (titleLower.contains("diaper") || 
            titleLower.contains("changing") || 
            titleLower.contains("skin care") ||
            subtitleLower.contains("diaper") || 
            subtitleLower.contains("changing") || 
            subtitleLower.contains("skin care") ||
            contentLower.startsWith("diaper changing:") ||
            contentLower.startsWith("skin care:")) {
          return true;
        }
        
        final careKeywords = [
          'daily care', 'diapering', 'bathing', 'baby bath', 'sleep routine',
          'baby hygiene', 'cord care', 'skin care', 'nail care', 'clothing'
        ];
        
        for (var keyword in careKeywords) {
          if (titleLower.contains(keyword) || subtitleLower.contains(keyword) || 
              contentLower.contains(keyword)) {
            return true;
          }
        }
        return false;
        
      case "Child Growth Stages":
        // Explicitly exclude more specific articles that should be in Sensory/Motor Skills
        if (titleLower.contains("4 to 6 months") || 
            titleLower.contains("7 to 9 months") || 
            titleLower.contains("10 to 12 months") ||
            titleLower.contains("stimulating activities") ||
            titleLower.contains("sensory play") ||
            titleLower.contains("motor development") ||
            titleLower.contains("tummy time") ||
            titleLower.contains("activities for") ||
            titleLower.contains("crawling") ||
            titleLower.contains("walking") ||
            titleLower.contains("fine motor") ||
            titleLower.contains("gross motor")) {
          return false;
        }
        
        // Also exclude any title containing "month" and "activities" together
        if (titleLower.contains("month") && titleLower.contains("activities")) {
          return false;
        }
        
        // Only match general growth/development if not specific to motor skills
        if ((titleLower.contains('growth') || contentLower.contains('growth stages')) &&
            !titleLower.contains('motor') && !subtitleLower.contains('motor') && 
            !titleLower.contains('sensory') && !subtitleLower.contains('sensory')) {
          return true;
        }
        
        // Physical, cognitive, social development (but not motor/sensory specifically)
        final growthKeywords = [
          'physical development', 'cognitive development', 'social development',
          'emotional development', 'developmental milestone', 'growth spurt',
          'height', 'weight', 'brain development'
        ];
        
        for (var keyword in growthKeywords) {
          if (titleLower.contains(keyword) || subtitleLower.contains(keyword) || 
              contentLower.contains(keyword)) {
            // Make sure it's not primarily about motor/sensory development
            if (!titleLower.contains('motor') && !subtitleLower.contains('motor') && 
                !titleLower.contains('sensory') && !subtitleLower.contains('sensory') &&
                !titleLower.contains('activit')) {
              return true;
            }
          }
        }
        return false;
        
      case "Sensory and Motor Skills Development":
        // Specifically include these articles that should only be in this section
        if (titleLower.contains("4 to 6 months") || 
            titleLower.contains("7 to 9 months") || 
            titleLower.contains("10 to 12 months") ||
            titleLower.contains("stimulating activities") ||
            titleLower.contains("sensory play") ||
            titleLower.contains("motor development") ||
            titleLower.contains("tummy time") ||
            titleLower.contains("activities for")) {
          return true;
        }
        
        // Also include any title containing "month" and "activities" together
        if (titleLower.contains("month") && titleLower.contains("activities")) {
          return true;
        }
        
        // This should specifically be about motor skills/sensory development
        if (titleLower.contains('motor') || titleLower.contains('sensory') ||
            subtitleLower.contains('motor') || subtitleLower.contains('sensory')) {
          return true;
        }
        
        final motorKeywords = [
          'fine motor', 'gross motor', 'motor skill', 'hand-eye coordination',
          'crawling', 'walking', 'grasping', 'reaching', 'rolling over',
          'sitting up', 'sensory play', 'sensory stimulation', 'tummy time'
        ];
        
        for (var keyword in motorKeywords) {
          if (titleLower.contains(keyword) || subtitleLower.contains(keyword) || 
              contentLower.contains(keyword)) {
            return true;
          }
        }
        return false;
        
      case "Complementary Feeding (Introducing Solid Foods)":
        final feedingKeywords = [
          'feeding', 'solid food', 'baby food', 'puree', 'weaning', 'infant nutrition',
          'introducing food', 'formula', 'breastfeeding', 'breast milk'
        ];
        
        for (var keyword in feedingKeywords) {
          if (titleLower.contains(keyword) || subtitleLower.contains(keyword) || 
              contentLower.contains(keyword)) {
            return true;
          }
        }
        return false;
        
      default:
        return false;
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
  
  String _getPlaceholderContent() {
    switch (widget.title) {
      case "Child Growth Stages":
        return "Child growth and development encompasses the physical, cognitive, emotional, and social changes that occur from birth through adolescence. Key stages include:\n\n- Newborn (0-3 months): Rapid growth, developing reflexes, beginning to recognize parents.\n- Infant (3-12 months): Learning to sit, crawl, stand, and possibly walk; first words may emerge.\n- Toddler (1-3 years): Walking, talking, increasing independence, and social interaction.\n- Preschool (3-5 years): Refined motor skills, expanded vocabulary, imaginative play.\n- School-age (6-12 years): Reading, writing, logical thinking, peer relationships become important.\n\nEach child develops at their own pace, but significant delays should be discussed with a healthcare provider.";
      
      case "Complementary Feeding (Introducing Solid Foods)":
        return "Complementary feeding is the process of introducing solid foods to a baby's diet in addition to breast milk or formula. Key guidelines include:\n\n- Start around 6 months, when baby shows readiness signs (sitting up, head control, interest in food).\n- Begin with single-ingredient foods like iron-fortified cereals, pureed vegetables, or fruits.\n- Introduce new foods one at a time, waiting 3-5 days between new foods to watch for allergic reactions.\n- Gradually increase texture from pureed to mashed to soft pieces as baby develops.\n- By 12 months, baby should be eating a variety of family foods.\n\nAlways supervise baby during feeding and avoid foods that pose choking hazards.";
      
      case "Daily Baby Care":
        return "Daily baby care involves several essential routines to keep your baby healthy and comfortable:\n\n- Bathing: 2-3 times per week for newborns, using gentle cleansers specifically for babies.\n- Diapering: Change diapers frequently (every 2-3 hours) to prevent rash and discomfort.\n- Sleep: Newborns sleep 14-17 hours per day in short periods; always place baby on back to sleep.\n- Feeding: Whether breastfeeding or formula-feeding, feed on demand, usually 8-12 times per day for newborns.\n- Umbilical cord care: Keep the area clean and dry until it falls off naturally.\n- Nail care: Trim nails while baby sleeps using special baby nail clippers.\n\nEstablishing consistent routines can help make baby care more manageable.";
      
      case "Baby Health and Common Illnesses":
        return "Babies are susceptible to various health issues as their immune systems develop:\n\n- Fever: Temperature above 100.4°F (38°C) requires medical attention for babies under 3 months.\n- Colds: Runny nose, congestion, mild cough; usually resolve within 7-10 days.\n- Ear infections: Signs include tugging at ears, irritability, difficulty sleeping.\n- Diaper rash: Red, irritated skin in the diaper area; prevent with frequent changes and barrier creams.\n- Thrush: White patches in the mouth caused by a yeast infection.\n- Colic: Extended periods of crying in an otherwise healthy baby.\n\nVaccinations are crucial for preventing serious childhood diseases. Follow the recommended immunization schedule from your pediatrician.";
      
      case "Sensory and Motor Skills Development":
        return "Sensory and motor development involves how babies learn to move and respond to sensory input:\n\n- Fine motor skills: Using small muscles for precise movements like grasping objects and eventually using utensils.\n- Gross motor skills: Using large muscles for sitting, crawling, standing, and walking.\n- Sensory processing: How babies take in and respond to information through their senses (sight, sound, touch, taste, smell).\n\nActivities to support development:\n- Tummy time to strengthen neck and shoulder muscles\n- Providing different textures to touch and explore\n- Talking, singing, and reading to stimulate language and hearing\n- Age-appropriate toys that encourage reaching, grasping, and manipulation\n\nDevelopmental milestones vary, but consistent delays should be discussed with a healthcare provider.";
      
      default:
        return "Information about this topic will be available soon. Please check back later for updates on ${widget.title}.";
    }
  }

  IconData _getIconForArticle(String title) {
    final titleLower = title.toLowerCase();
    
    if (titleLower.contains('growth') || titleLower.contains('development')) {
      return Icons.child_care;
    } else if (titleLower.contains('feed') || titleLower.contains('food') || titleLower.contains('nutrition')) {
      return Icons.restaurant;
    } else if (titleLower.contains('care') || titleLower.contains('diaper') || titleLower.contains('hygiene')) {
      return Icons.baby_changing_station;
    } else if (titleLower.contains('health') || titleLower.contains('illness') || titleLower.contains('disease')) {
      return Icons.healing;
    } else if (titleLower.contains('sensory') || titleLower.contains('motor') || titleLower.contains('skill')) {
      return Icons.sports_gymnastics;
    } else {
      return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort articles if needed based on the topic
    if (articlesData.isNotEmpty && !_isLoading && _errorMessage == null) {
      _sortArticlesByDevelopmentStage();
    }
    
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar with Logo
            const CustomAppBarWithLogo(),

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
                          // Page Title
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
                            child: _buildTopicImage(widget.title),
                          ),
                          const SizedBox(height: 20),
                          
                          // Articles
                          ...articlesData.map((article) => _buildArticleCard(article)).toList(),
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
          left: BorderSide(color: Colors.pinkAccent, width: 4),
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
                  color: Colors.pinkAccent, 
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
            )).toList(),
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
  
  Widget _buildTopicImage(String topic) {
    IconData icon;
    MaterialColor colorSwatch;
    String? imagePath;
    
    // Determine icon and color based on topic
    if (topic.contains('Growth')) {
      icon = Icons.child_care;
      colorSwatch = Colors.pink;
      imagePath = 'assets/images/baby_icon.png';
    } else if (topic.contains('Feeding')) {
      icon = Icons.restaurant;
      colorSwatch = Colors.purple;
    } else if (topic.contains('Care')) {
      icon = Icons.baby_changing_station;
      colorSwatch = Colors.blue;
    } else if (topic.contains('Health')) {
      icon = Icons.healing;
      colorSwatch = Colors.teal;
    } else if (topic.contains('Motor') || topic.contains('Sensory')) {
      icon = Icons.sports_gymnastics;
      colorSwatch = Colors.amber;
    } else {
      icon = Icons.info_outline;
      colorSwatch = Colors.grey;
    }
    
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorSwatch.shade200,
            colorSwatch.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: imagePath != null
          ? Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  icon,
                  size: 50,
                  color: Colors.white.withOpacity(0.7),
                );
              },
            )
          : Icon(
              icon,
              size: 50,
              color: Colors.white.withOpacity(0.7),
            ),
    );
  }
  
  void _sortArticlesByDevelopmentStage() {
    if (widget.title == "Child Growth Stages" || widget.title == "Sensory and Motor Skills Development") {
      print('🔄 Sorting articles for topic: ${widget.title}');
      
      articlesData.sort((a, b) {
        // Get age/stage indicators from titles and subtitles
        final aAgeIndicator = _extractAgeIndicator(a['title'], a['subtitle'], a['content']);
        final bAgeIndicator = _extractAgeIndicator(b['title'], b['subtitle'], b['content']);
        
        print('🔄 Comparing: ${a['title']} (Age rank: $aAgeIndicator) vs ${b['title']} (Age rank: $bAgeIndicator)');
        
        return aAgeIndicator.compareTo(bAgeIndicator);
      });
      
      print('✅ Sorted articles for ${widget.title}:');
      for (var article in articlesData) {
        final ageIndicator = _extractAgeIndicator(article['title'], article['subtitle'], article['content']);
        print('  - ${article['title']} (Age rank: $ageIndicator)');
      }
    }
  }
  
  int _extractAgeIndicator(String title, String subtitle, String content) {
    final titleLower = title.toLowerCase();
    final subtitleLower = subtitle.toLowerCase();
    final contentLower = content.toLowerCase();
    
    // Check for specific age ranges in the title or subtitle
    if (_containsAgePattern(titleLower, 'newborn') || _containsAgePattern(subtitleLower, 'newborn') || 
        _containsAgePattern(titleLower, '0-3 month') || _containsAgePattern(subtitleLower, '0-3 month')) {
      return 1;
    }
    
    if (_containsAgePattern(titleLower, 'infant') || _containsAgePattern(subtitleLower, 'infant') ||
        _containsAgePattern(titleLower, '3-6 month') || _containsAgePattern(subtitleLower, '3-6 month')) {
      return 2;
    }
    
    if (_containsAgePattern(titleLower, '6-9 month') || _containsAgePattern(subtitleLower, '6-9 month') ||
        _containsAgePattern(titleLower, '6 month') || _containsAgePattern(subtitleLower, '6 month')) {
      return 3;
    }
    
    if (_containsAgePattern(titleLower, '9-12 month') || _containsAgePattern(subtitleLower, '9-12 month') ||
        _containsAgePattern(titleLower, '9 month') || _containsAgePattern(subtitleLower, '9 month')) {
      return 4;
    }
    
    if (_containsAgePattern(titleLower, '1 year') || _containsAgePattern(subtitleLower, '1 year') ||
        _containsAgePattern(titleLower, '12-18 month') || _containsAgePattern(subtitleLower, '12-18 month') ||
        _containsAgePattern(titleLower, 'toddler')) {
      return 5;
    }
    
    if (_containsAgePattern(titleLower, '2 year') || _containsAgePattern(subtitleLower, '2 year') ||
        _containsAgePattern(titleLower, '18-24 month') || _containsAgePattern(subtitleLower, '18-24 month')) {
      return 6;
    }
    
    if (_containsAgePattern(titleLower, '3 year') || _containsAgePattern(subtitleLower, '3 year') ||
        _containsAgePattern(titleLower, 'preschool')) {
      return 7;
    }
    
    if (_containsAgePattern(titleLower, '4-5 year') || _containsAgePattern(subtitleLower, '4-5 year')) {
      return 8;
    }
    
    if (_containsAgePattern(titleLower, 'school-age') || _containsAgePattern(subtitleLower, 'school-age') ||
        _containsAgePattern(titleLower, '6-12 year')) {
      return 9;
    }
    
    // If we can't find an explicit age indicator in the title or subtitle, look in the content
    if (_containsAgePattern(contentLower, 'newborn')) return 1;
    if (_containsAgePattern(contentLower, 'infant') || _containsAgePattern(contentLower, '3-6 month')) return 2;
    if (_containsAgePattern(contentLower, '6-9 month') || _containsAgePattern(contentLower, '6 month')) return 3;
    if (_containsAgePattern(contentLower, '9-12 month')) return 4;
    if (_containsAgePattern(contentLower, '1 year') || _containsAgePattern(contentLower, 'toddler')) return 5;
    if (_containsAgePattern(contentLower, '2 year')) return 6;
    if (_containsAgePattern(contentLower, '3 year') || _containsAgePattern(contentLower, 'preschool')) return 7;
    if (_containsAgePattern(contentLower, '4-5 year')) return 8;
    if (_containsAgePattern(contentLower, 'school-age') || _containsAgePattern(contentLower, '6-12 year')) return 9;
    
    // For development milestones, try to identify by specific keywords
    if (widget.title == "Sensory and Motor Skills Development") {
      if (titleLower.contains('tummy time') || contentLower.contains('tummy time')) return 1;
      if (titleLower.contains('grasp') || contentLower.contains('grasp reflex')) return 2;
      if (titleLower.contains('sitting') || contentLower.contains('sitting up')) return 3;
      if (titleLower.contains('crawl') || contentLower.contains('crawling')) return 4;
      if (titleLower.contains('stand') || contentLower.contains('standing')) return 5;
      if (titleLower.contains('walk') || contentLower.contains('walking')) return 6;
      if (titleLower.contains('run') || contentLower.contains('running')) return 7;
      if (titleLower.contains('fine motor') || contentLower.contains('drawing')) return 8;
    }
    
    // Default value for items without a clear age indicator
    return 99;
  }
  
  bool _containsAgePattern(String text, String pattern) {
    return text.contains(pattern);
  }
} 