import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class Month1 extends StatefulWidget {
  const Month1({super.key});

  @override
  State<Month1> createState() => _Month1State();
}

class _Month1State extends State<Month1> {
  Map<String, List<String>> sectionImages = {
    'exercise': [],
    'diet': [],
    'essential': [],
    'water': [],
  };

  Map<String, List<String>> sectionLinks = {
    'exercise': [],
    'diet': [],
    'essential': [],
    'water': [],
  };

  Map<String, String> firestoreTexts = {};
  bool _isLoading = true; // Add loading state
  String? _errorMessage; // Add error message state

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      final imagesSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('first')
          .collection('image')
          .get();

      final linksSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('first')
          .collection('link')
          .get();

      final textSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('first')
          .collection('text')
          .get();

      for (var doc in imagesSnapshot.docs) {
        final url = doc['image'] as String?;
        final docId = doc.id.toLowerCase();
        print('Image URL for $docId: $url'); // Debug print
        if (url != null) {
          if (docId.contains('exercise')) {
            sectionImages['exercise']!.add(url);
          } else if (docId.contains('diet')) {
            sectionImages['diet']!.add(url);
          } else if (docId.contains('essential')) {
            sectionImages['essential']!.add(url);
          } else if (docId.contains('water')) {
            sectionImages['water']!.add(url);
          }
        }
      }

      for (var doc in linksSnapshot.docs) {
        final url = doc['url'] as String?;
        final docId = doc.id.toLowerCase();
        if (url != null) {
          if (docId.contains('exercise')) {
            sectionLinks['exercise']!.add(url);
          } else if (docId.contains('diet')) {
            sectionLinks['diet']!.add(url);
          } else if (docId.contains('essential')) {
            sectionLinks['essential']!.add(url);
          } else if (docId.contains('water')) {
            sectionLinks['water']!.add(url);
          }
        }
      }

      setState(() {
        firestoreTexts = {
          for (var doc in textSnapshot.docs) doc.id: doc['text'] as String,
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
          // Intro Section
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
              "In the first month of pregnancy, it is important for the mother to take special care of her health because it plays a major role in the development of the fetus.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Exercise Section
          buildSection(
            icon: Icons.directions_run,
            title: "1. Exercise:",
            content: firestoreTexts["1. Exercise:"],
            images: sectionImages['exercise'],
            links: sectionLinks['exercise'],
            subtitle: "Images:",
            linkTitle: "Links:",
          ),

          // Diet Section
          buildSection(
            icon: Icons.food_bank,
            title: "2. Diet:",
            content: firestoreTexts["2.diet"],
            images: sectionImages['diet'],
            links: sectionLinks['diet'],
            subtitle: "Images:",
            linkTitle: "Links:",
          ),

          // Essential Vitamins Section
          buildSection(
            icon: Icons.medical_services,
            title: "3. Essential Vitamins and Minerals:",
            content: firestoreTexts["3. Essential Vitamins and Minerals:"],
            images: sectionImages['essential'],
            links: sectionLinks['essential'],
            subtitle: "Images:",
            linkTitle: "Links:",
          ),

          // Drink Water Section
          buildSection(
            icon: Icons.local_drink,
            title: "4. Drink Water:",
            content: firestoreTexts["4. Drink Water:"],
            images: sectionImages['water'],
            links: sectionLinks['water'],
            subtitle: "Images:",
            linkTitle: "Links:",
          ),

          // Tips Section
          buildSection(
            icon: Icons.lightbulb_outline,
            title: "5. Tips:",
            content: firestoreTexts["5.tips"],
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
          textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
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