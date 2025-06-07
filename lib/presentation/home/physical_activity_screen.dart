import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';

class PhysicalActivityScreen extends StatefulWidget {
  const PhysicalActivityScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> activitiesData = [];

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      print('⚠️ Fetching data for Physical Activities');
      
      final articlesRef = FirebaseFirestore.instance
          .collection('article')
          .doc('Home')
          .collection('physical-activity');
      
      print('📄 Fetching physical activity articles');
      
      final querySnapshot = await articlesRef.get();
      
      print('📄 Found ${querySnapshot.docs.length} physical activity articles');
      
      List<Map<String, dynamic>> tempActivities = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        print('📝 Processing activity article: ${doc.id}');
        print('  - Title: ${data['title']}');
        print('  - Subtitle: ${data['subtitle']}');
        print('  - Content: ${data['content']}');
        
        tempActivities.add({
          'id': doc.id,
          'title': data['title'] ?? 'No Title',
          'subtitle': data['subtitle'] ?? '',
          'content': data['content'] ?? 'No content available',
          'images': data['images'] ?? <String>[],
          'publicationDate': data['publicationDate'] ?? '',
          'createdAt': data['createdAt'] ?? '',
        });
      }
      
      print('📊 Processed ${tempActivities.length} activity articles');
      
      tempActivities.sort((a, b) {
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
        activitiesData = tempActivities;
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
                  : activitiesData.isEmpty 
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
                                    'Physical Activities',
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
                                  'Safe exercises for expecting mothers',
                                  style: GoogleFonts.inriaSerif(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                ...activitiesData.map((activity) => _buildActivityCard(activity)),
                                
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
  
  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final List<dynamic> imagesData = activity['images'] ?? [];
    final List<String> images = imagesData
        .where((img) => img != null && img.toString().isNotEmpty)
        .map((img) => img.toString())
        .toList();
    
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: Icon(
                      Icons.fitness_center,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    activity['subtitle'] ?? 'No Activity Available',
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
          
          Padding(
            padding: EdgeInsets.fromLTRB(56, 0, 16, images.isEmpty ? 16 : 8),
            child: Text(
              activity['content'],
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          
          if (images.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: index < images.length - 1 ? 8 : 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImageViewerPage(imageUrl: images[index]),
                              ),
                            );
                          },
                          child: Container(
                            width: 200,
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
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                print('❌ Error loading image: $error');
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
