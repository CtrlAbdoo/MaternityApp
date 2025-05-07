import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class MonthProblemsScreen extends StatefulWidget {
  final int month;
  final String title;

  const MonthProblemsScreen({
    Key? key,
    required this.month,
    required this.title,
  }) : super(key: key);

  @override
  State<MonthProblemsScreen> createState() => _MonthProblemsScreenState();
}

class _MonthProblemsScreenState extends State<MonthProblemsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  
  Map<String, Map<String, dynamic>> sectionData = {};
  Map<String, String> firestoreTexts = {};
  
  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }
  
  String getMonthName() {
    switch (widget.month) {
      case 1: return 'first';
      case 2: return 'second';
      case 3: return 'third';
      case 4: return 'fourth';
      case 5: return 'fifth';
      case 6: return 'sixth';
      case 7: return 'seventh';
      case 8: return 'eighth';
      case 9: return 'ninth';
      default: return 'first';
    }
  }
  
  Future<void> fetchFirestoreData() async {
    final monthName = getMonthName();
    
    try {
      print('⚠️ Fetching data for month: $monthName');
      
      // Initialize temporary data structures
      Map<String, Map<String, dynamic>> tempSectionData = {};
      
      // Try to get data from "Months of Pregnancy" collection
      print('🔍 Trying collection "Months of Pregnancy"');
      
      final docRef = FirebaseFirestore.instance
          .collection('Months of Pregnancy')
          .doc(monthName);
          
      final docSnapshot = await docRef.get();
      
      if (!docSnapshot.exists) {
        print('❌ Document not found at: Months of Pregnancy/$monthName');
        setState(() {
          _errorMessage = 'No data found for ${widget.title}';
          _isLoading = false;
        });
        return;
      }
      
      print('✅ Found document at: Months of Pregnancy/$monthName');
      
      // Get text subcollection
      final textCollection = await docRef.collection('text').get();
      print('📄 Found ${textCollection.docs.length} documents in text collection');
      
      if (textCollection.docs.isNotEmpty) {
        // Process all documents in the text subcollection
        for (var doc in textCollection.docs) {
          final sectionId = doc.id;
          print('📝 Processing text document: $sectionId');
          
          // Get the text field from the document
          String? content;
          if (doc.exists && doc.data().containsKey('text')) {
            content = doc.data()['text'];
            print('✅ Found text content for section: $sectionId');
            
            tempSectionData[sectionId] = {
              'content': content,
              'images': <String>[],
              'links': <String>[],
            };
          }
        }
        
        // Get image subcollection
        final imageCollection = await docRef.collection('image').get();
        print('🖼️ Found ${imageCollection.docs.length} images');
        
        // Process images
        for (var imageDoc in imageCollection.docs) {
          final sectionId = imageDoc.id;
          final imageData = imageDoc.data();
          print('🖼️ Processing image document: $sectionId');
          
          if (imageData.containsKey('image')) {
            final imageUrl = imageData['image'];
            
            // Add image to the corresponding section
            if (tempSectionData.containsKey(sectionId)) {
              (tempSectionData[sectionId]!['images'] as List<String>).add(imageUrl);
              print('✅ Added image to section: $sectionId');
            }
          }
        }
        
        // Get link subcollection
        final linkCollection = await docRef.collection('link').get();
        print('🔗 Found ${linkCollection.docs.length} links');
        
        // Process links
        for (var linkDoc in linkCollection.docs) {
          final sectionId = linkDoc.id;
          final linkData = linkDoc.data();
          print('🔗 Processing link document: $sectionId');
          
          if (linkData.containsKey('url')) {
            final linkUrl = linkData['url'];
            
            // Add link to the corresponding section
            if (tempSectionData.containsKey(sectionId)) {
              (tempSectionData[sectionId]!['links'] as List<String>).add(linkUrl);
              print('✅ Added link to section: $sectionId');
            }
          }
        }
      }
      
      // Create placeholder data if needed
      if (tempSectionData.isEmpty) {
        print('⚠️ No data found, adding placeholder content');
        tempSectionData['pregnancy problems from beginning to end'] = {
          'content': _getMonthIntroduction(widget.month),
          'images': <String>[],
          'links': <String>[],
        };
      }
      
      setState(() {
        sectionData = tempSectionData;
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
  
  IconData _getIconForSection(String sectionId) {
    final id = sectionId.toLowerCase();
    
    if (id.contains('exercise')) {
      return Icons.directions_run;
    } else if (id.contains('common problem')) {
      return Icons.medical_services;
    } else if (id.contains('deal with it') || id.contains('how to')) {
      return Icons.healing;
    } else if (id.contains('food')) {
      return Icons.restaurant_menu;
    } else if (id.contains('drink')) {
      return Icons.local_drink;
    } else if (id.contains('doctor')) {
      return Icons.local_hospital;
    } else if (id.contains('beginning to end')) {
      return Icons.timeline;
    } else {
      return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'assets/images/pregnancy/${_getMonthImageName(widget.month)}.png';

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
                          // Page Title with Month
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
                          
                          // Month Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _buildMonthImage(widget.month, imagePath),
                          ),
                          const SizedBox(height: 20),
                          
                          // Check if we have any real content
                          if (sectionData.isEmpty) 
                            _buildPlaceholderSection()
                          else ...[
                            // Dynamic Content Sections - one for each document in the collection
                            ...getSortedSectionEntries().map((entry) {
                              final sectionId = entry.key;
                              final content = entry.value['content'] as String?;
                              final images = entry.value['images'] as List<String>?;
                              final links = entry.value['links'] as List<String>?;
                              
                              // Skip empty sections
                              if (content == null || content.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              
                              return _buildSection(
                                title: sectionId,
                                content: content,
                                images: images,
                                links: links,
                              );
                            }).toList(),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIntroductionCard(String introText) {
    return Container(
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
          Text(
            "Overview",
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            introText,
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required String content,
    List<String>? images,
    List<String>? links,
  }) {
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
          Row(
            children: [
              Icon(
                _getIconForSection(title), 
                color: Colors.pinkAccent, 
                size: 24
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inriaSerif(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFormattedContent(content),
          if (images != null && images.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSubtitle("Images:"),
            ...images.map((imageUrl) => Padding(
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
          if (links != null && links.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSubtitle("Links:"),
            ...links.map((url) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextButton(
                onPressed: () => _launchURL(url),
                child: Text(
                  url,
                  style: GoogleFonts.inriaSerif(
                    fontWeight: FontWeight.bold,
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }
  
  String _formatSectionTitle(String rawTitle) {
    // Capitalize first letter of each word and remove trailing colon if present
    if (rawTitle.isEmpty) return '';
    
    // Remove trailing colon if present
    String title = rawTitle;
    if (title.endsWith(':')) {
      title = title.substring(0, title.length - 1);
    }
    
    List<String> words = title.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    
    return words.join(' ');
  }

  String _getMonthIntroduction(int month) {
    switch (month) {
      case 1:
        return "In the first month of pregnancy, your body is undergoing significant changes. It's common to experience various symptoms as your body adapts to the pregnancy. Here are the most common issues you might face:";
      case 2:
        return "During the second month of pregnancy, hormonal changes continue to affect your body. These are normal changes, but they can sometimes cause discomfort. Here are common issues during this month:";
      case 3:
        return "The third month marks the end of your first trimester. Some symptoms may improve while others may appear. Here are common problems during this period:";
      case 4:
        return "Welcome to your second trimester! The fourth month often brings relief from some early pregnancy symptoms, but new challenges may arise. Here's what you might experience:";
      case 5:
        return "In the fifth month, you're likely noticing more obvious physical changes as your baby grows. Here are common issues during this month:";
      case 6:
        return "During the sixth month, your baby continues to grow rapidly, and your body adapts to these changes. Here are common concerns during this period:";
      case 7:
        return "In the seventh month, you're entering the third trimester. Your body is preparing for delivery, which can bring new challenges. Here's what you might experience:";
      case 8:
        return "In the eighth month, your baby is putting on weight and your body is preparing for delivery. These changes can bring several discomforts:";
      case 9:
        return "You're in the final stretch! The ninth month brings its own unique challenges as your body prepares for labor and delivery. Here are common issues you might face:";
      default:
        return "During pregnancy, your body undergoes many changes to support your growing baby. These changes can sometimes cause discomfort or concerns. Here are some common issues you might experience:";
    }
  }

  Widget _buildMonthImage(int month, String imagePath) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColorsForMonth(month),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Try to load the image
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // If image fails to load, show an icon
              return Center(
                child: _getIconForMonth(month),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormattedContent(String content) {
    // Split text by newlines to identify list items
    List<String> contentLines = content.split('\n');
    List<Widget> contentWidgets = [];

    for (var line in contentLines) {
      // Trim whitespace
      final trimmedLine = line.trim();
      
      // Skip empty lines
      if (trimmedLine.isEmpty) continue;
      
      // Check if line is a list item (starting with - or •)
      if (trimmedLine.startsWith('-') || trimmedLine.startsWith('•')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•', 
                  style: GoogleFonts.inriaSerif(
                    textStyle: const TextStyle(
                      fontSize: 16, 
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trimmedLine.substring(1).trim(),
                    style: GoogleFonts.inriaSerif(
                      textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } 
      // Check if line is a header (ending with :)
      else if (trimmedLine.endsWith(':')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              trimmedLine,
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      } 
      // Regular paragraph
      else {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Text(
              trimmedLine,
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.inriaSerif(
          textStyle: const TextStyle(
            fontSize: 16,
            decoration: TextDecoration.underline,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  String _getMonthImageName(int month) {
    switch (month) {
      case 1: return 'first_month';
      case 2: return 'second_month';
      case 3: return 'third_month';
      case 4: return 'fourth_month';
      case 5: return 'fifth_month';
      case 6: return 'sixth_month';
      case 7: return 'seventh_month';
      case 8: return 'eighth_month';
      case 9: return 'ninth_month';
      default: return 'placeholder';
    }
  }

  List<Color> _getGradientColorsForMonth(int month) {
    switch (month) {
      case 1:
        return [Colors.pink.shade100, Colors.pink.shade50];
      case 2:
        return [Colors.purple.shade100, Colors.purple.shade50];
      case 3:
        return [Colors.indigo.shade100, Colors.indigo.shade50];
      case 4:
        return [Colors.blue.shade100, Colors.blue.shade50];
      case 5:
        return [Colors.cyan.shade100, Colors.cyan.shade50];
      case 6:
        return [Colors.teal.shade100, Colors.teal.shade50];
      case 7:
        return [Colors.green.shade100, Colors.green.shade50];
      case 8:
        return [Colors.amber.shade100, Colors.amber.shade50];
      case 9:
        return [Colors.orange.shade100, Colors.orange.shade50];
      default:
        return [Colors.grey.shade100, Colors.grey.shade50];
    }
  }

  Widget _getIconForMonth(int month) {
    IconData icon;
    double size = 40;
    
    if (month <= 3) {
      icon = Icons.pregnant_woman;
    } else if (month <= 6) {
      icon = Icons.child_friendly;
    } else {
      icon = Icons.baby_changing_station;
    }
    
    return Icon(
      icon,
      size: size,
      color: Colors.white.withOpacity(0.7),
    );
  }

  List<MapEntry<String, Map<String, dynamic>>> getSortedSectionEntries() {
    final entries = sectionData.entries.toList();
    
    // Define the custom order for sections
    final customOrder = [
      'pregnancy problems',  // Changed to match partial text
      'common problems',     // Removed colon and made case insensitive
      'how to deal with it', // Removed colon
      'healthy foods',       // Removed colon
      'suggested drinks',    // Removed colon
      'appropriate exercises',  // Removed colon
      'when should you see a doctor', // Removed colon
    ];
    
    // Sort based on the custom order
    entries.sort((a, b) {
      final aKey = a.key.toLowerCase().trim();
      final bKey = b.key.toLowerCase().trim();
      
      // Find the position in custom order using partial matching
      int aIndex = -1;
      int bIndex = -1;
      
      for (int i = 0; i < customOrder.length; i++) {
        if (aKey.contains(customOrder[i].toLowerCase())) {
          aIndex = i;
        }
        if (bKey.contains(customOrder[i].toLowerCase())) {
          bIndex = i;
        }
      }
      
      // If both sections are in our predefined list, sort by their position in the list
      if (aIndex != -1 && bIndex != -1) {
        return aIndex.compareTo(bIndex);
      }
      
      // If only one section is in our list, prioritize it
      if (aIndex != -1) return -1;
      if (bIndex != -1) return 1;
      
      // For any sections not in our predefined list, sort alphabetically
      return aKey.compareTo(bKey);
    });
    
    return entries;
  }

  Widget _buildPlaceholderSection() {
    return _buildIntroductionCard(_getMonthIntroduction(widget.month));
  }
} 