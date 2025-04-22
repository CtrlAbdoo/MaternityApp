import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class Month2 extends StatefulWidget {
  const Month2({super.key});

  @override
  State<Month2> createState() => _Month2State();
}

class _Month2State extends State<Month2> {
  Map<String, List<String>> sectionImages = {
    'exercise': [],
    'diet': [],
    'essential': [],
  };

  Map<String, List<String>> sectionLinks = {
    'exercise': [],
    'essential': [],
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
          .doc('second')
          .collection('image')
          .get();

      final linkSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('second')
          .collection('link')
          .get();

      final textSnapshot = await FirebaseFirestore.instance
          .collection('months')
          .doc('second')
          .collection('text')
          .get();

      for (var doc in imageSnapshot.docs) {
        final data = doc.data();
        final url = data['image'] as String?;
        final section = doc.id.trim().toLowerCase();
        print('Image URL for $section: $url');
        if (url != null) {
          if (section.contains('exercise')) {
            sectionImages['exercise']!.add(url);
          } else if (section.contains('diet')) {
            sectionImages['diet']!.add(url);
          } else if (section.contains('essential')) {
            sectionImages['essential']!.add(url);
          }
        }
      }

      for (var doc in linkSnapshot.docs) {
        final data = doc.data();
        final url = data['url'] as String?;
        final section = doc.id.trim().toLowerCase();
        if (url != null) {
          if (section.contains('exercise')) {
            sectionLinks['exercise']!.add(url);
          } else if (section.contains('essential')) {
            sectionLinks['essential']!.add(url);
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
              "In the second month of pregnancy, the mother should focus on maintaining a healthy lifestyle to support the early stages of fetal development.",
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
            content: firestoreTexts["1. Exercise :"],
            images: sectionImages['exercise'],
            links: sectionLinks['exercise'],
            subtitle: "Exercise Images",
            linkTitle: "Exercise Videos",
          ),

          // Diet Section
          buildSection(
            icon: Icons.food_bank,
            title: "2. Diet:",
            content: firestoreTexts["2. Diet :"],
            images: sectionImages['diet'],
            links: [],
            subtitle: "Diet Images",
          ),

          // Essential Vitamins Section
          buildSection(
            icon: Icons.medical_services,
            title: "3. Essential Vitamins and Minerals:",
            content: firestoreTexts["3. Essential Vitamins and Minerals:"],
            images: sectionImages['essential'],
            links: sectionLinks['essential'],
            subtitle: "Images",
            linkTitle: "Videos",
          ),

          // Tips Section
          buildSection(
            icon: Icons.lightbulb_outline,
            title: "4. Additional Tips:",
            content: firestoreTexts["4.Additional Tips:"],
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
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
            child: Image.network(
              url,
              fit: BoxFit.contain,
              height: 300,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image $url: $error');
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load image: $error',
                          style: GoogleFonts.inriaSerif(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
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