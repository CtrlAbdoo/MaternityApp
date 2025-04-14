import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Month8 extends StatefulWidget {
  const Month8({super.key});

  @override
  State<Month8> createState() => _Month8State();
}

class _Month8State extends State<Month8> {
  Map<String, List<String>> sectionImages = {
    'exercise': [],
    'nutrition': [],
    'proteins': [],
    'vitamins': [],
  };

  Map<String, List<String>> sectionLinks = {
    'exercise': [],
  };

  Map<String, String> firestoreTexts = {};

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    final imageSnapshot = await FirebaseFirestore.instance
        .collection('months')
        .doc('eighth')
        .collection('image')
        .get();

    final linkSnapshot = await FirebaseFirestore.instance
        .collection('months')
        .doc('eighth')
        .collection('link')
        .get();

    final textSnapshot = await FirebaseFirestore.instance
        .collection('months')
        .doc('eighth')
        .collection('text')
        .get();

    for (var doc in imageSnapshot.docs) {
      final data = doc.data();
      final url = data['image'] as String?;
      final section = doc.id.toLowerCase();

      if (url != null) {
        if (section.contains('exercise')) {
          sectionImages['exercise']!.add(url);
        } else if (section.contains('nutrition')) {
          sectionImages['nutrition']!.add(url);
        } else if (section.contains('protein')) {
          sectionImages['proteins']!.add(url);
        } else if (section.contains('vitamin')) {
          sectionImages['vitamins']!.add(url);
        }
      }
    }

    for (var doc in linkSnapshot.docs) {
      final data = doc.data();
      final url = data['url'] as String?;
      final section = doc.id.toLowerCase();

      if (url != null && section.contains('exercise')) {
        sectionLinks['exercise']!.add(url);
      }
    }

    for (var doc in textSnapshot.docs) {
      final data = doc.data();
      firestoreTexts[doc.id.trim()] = data['text'] ?? '';
    }

    setState(() {});
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
    return sectionImages.values.every((list) => list.isEmpty) &&
        sectionLinks.values.every((list) => list.isEmpty) &&
        firestoreTexts.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle("1. Exercise"),
          buildText(firestoreTexts["1. Exercise"]),
          buildSubtitle("Exercise Images"),
          ...buildImageWidgets(sectionImages['exercise']),
          buildSubtitle("Exercise Links"),
          ...buildLinks(sectionLinks['exercise']),

          sectionDivider(),
          buildTitle("2. Proper Nutrition:"),
          buildText(firestoreTexts["2. Proper Nutrition:"]),
          buildSubtitle("Nutrition Images"),
          ...buildImageWidgets(sectionImages['nutrition']),

          sectionDivider(),
          buildTitle("3. Proteins"),
          buildText(firestoreTexts["3. Proteins"]),
          buildSubtitle("Protein Images"),
          ...buildImageWidgets(sectionImages['proteins']),

          sectionDivider(),
          buildTitle("4. Important Vitamins and Minerals:"),
          buildText(firestoreTexts["4. Important Vitamins and Minerals:"]),
          // buildSubtitle("Vitamin Images"),
          // ...buildImageWidgets(sectionImages['vitamins']),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.inriaSerif(
          textStyle: const TextStyle(fontSize: 20),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget buildSubtitle(String text) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.inriaSerif(
          textStyle: const TextStyle(
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget buildText(String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        content ?? "Loading...",
        style: GoogleFonts.inriaSerif(
          textStyle: const TextStyle(fontSize: 14),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  List<Widget> buildImageWidgets(List<String>? imageList) {
    if (imageList == null || imageList.isEmpty) return [];
    return imageList.map((url) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: GestureDetector(
          onTap: () => _launchURL(url),
          child: Image.network(url),
        ),
      );
    }).toList();
  }

  List<Widget> buildLinks(List<String>? urls) {
    if (urls == null || urls.isEmpty) return [];
    return urls.map((link) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextButton(
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
        ),
      );
    }).toList();
  }

  Widget sectionDivider() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(
          color: Color(0x50000000),
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
