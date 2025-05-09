import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class Month4 extends StatefulWidget {
  const Month4({super.key});

  @override
  State<Month4> createState() => _Month4State();
}

class _Month4State extends State<Month4> {
  Map<String, List<String>> sectionImages = {
    'exercise': [],
    'diet': [], // Changed from 'nutrition' to 'diet'
    'proteins': [],
  };

  Map<String, List<String>> sectionLinks = {
    'exercise': [],
  };

  Map<String, String> firestoreTexts = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      final imageSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('fourth')
          .collection('image')
          .get();

      final linkSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('fourth')
          .collection('link')
          .get();

      final textSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('fourth')
          .collection('text')
          .get();

      for (var doc in imageSnapshot.docs) {
        final data = doc.data();
        final url = data['image'] as String?;
        final section = doc.id.toLowerCase();
        print('Image URL for $section: $url');
        if (url != null) {
          if (section.contains('exercise')) {
            sectionImages['exercise']!.add(url);
          } else if (section.contains('nutrition')) {
            sectionImages['diet']!.add(url);
          } else if (section.contains('proteins')) {
            sectionImages['proteins']!.add(url);
          }
        }
      }

      for (var doc in linkSnapshot.docs) {
        final data = doc.data();
        final url = data['url'] as String?;
        final section = doc.id.toLowerCase();
        if (url != null) {
          if (section.contains('exercise')) {
            sectionLinks['exercise']!.add(url);
          }
        }
      }

      setState(() {
        firestoreTexts = {
          for (var doc in textSnapshot.docs)
            doc.id.trim(): doc.data()['text'] as String? ?? ''
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Firestore data: $e');
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: GoogleFonts.inriaSerif(
            textStyle: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
            ),
            child: Text(
              "In the fourth month of pregnancy, the mother may experience increased energy, making it a good time to focus on nutrition and light exercise.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          buildSection(
            icon: Icons.directions_run,
            title: "1. Exercise:",
            content: firestoreTexts["1. Exercise:"],
            images: sectionImages['exercise'],
            links: sectionLinks['exercise'],
            subtitle: "Exercise Images",
            linkTitle: "Exercise Links",
          ),

          buildSection(
            icon: Icons.food_bank,
            title: "2. Proper Nutrition:",
            content: firestoreTexts["2. Proper Nutrition:"],
            images: sectionImages['diet'],
            links: [],
            subtitle: "Diet Images",
          ),

          buildSection(
            icon: Icons.medical_services,
            title: "3. Proteins:",
            content: firestoreTexts["3. Proteins:"],
            images: sectionImages['proteins'],
            links: [],
            subtitle: "Protein Images",
          ),

          buildSection(
            icon: Icons.lightbulb_outline,
            title: "4. Additional Tips:",
            content: firestoreTexts["4. Additional tips:"],
            images: [],
            links: [],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildSection({
    required IconData icon,
    required String title,
    required String? content,
    required List<String>? images,
    required List<String>? links,
    String? subtitle,
    String? linkTitle,
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
              Icon(icon, color: Colors.pinkAccent, size: 24),
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
          const SizedBox(height: 10),
          buildText(content),
          if (images != null && images.isNotEmpty) ...[
            const SizedBox(height: 10),
            buildSubtitle(subtitle ?? "Images:"),
            ...buildImageWidgets(images),
          ],
          if (links != null && links.isNotEmpty) ...[
            const SizedBox(height: 10),
            buildSubtitle(linkTitle ?? "Links:"),
            ...buildLinkWidgets(links),
          ],
        ],
      ),
    );
  }

  Widget buildText(String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        content ?? "Loading...",
        style: GoogleFonts.inriaSerif(
          textStyle: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget buildSubtitle(String text) {
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

  List<Widget> buildImageWidgets(List<String>? imageList) {
    if (imageList == null || imageList.isEmpty) {
      return [
        const Center(
          child: Text(
            'No images available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ];
    }
    return imageList.map((url) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageViewer(url: url),
              ),
            );
          },
          child: Hero(
            tag: url,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              height: 400,
              width: double.infinity,
              memCacheHeight: 1080,
              memCacheWidth: 1920,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildLinkWidgets(List<String>? links) {
    if (links == null || links.isEmpty) return [];
    return links.map((link) {
      return TextButton(
        onPressed: () => _launchURL(link),
        child: Text(
          link,
          style: GoogleFonts.inriaSerif(
            fontWeight: FontWeight.bold,
            textStyle: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList();
  }
}