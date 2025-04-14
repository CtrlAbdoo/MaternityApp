import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
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
      final docId = doc.id.toLowerCase(); // e.g., "1. exercise:"
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
    });
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
          Text(
            "In the first month of pregnancy, it is important for the mother to take special care of her health because it plays a major role in the development of the fetus. Here are the most important tips related to vitamins, exercises, food, and drinking water.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 15),

          buildTitle("1. Exercise:"),
          buildText(firestoreTexts["1. Exercise:"]),
          const SizedBox(height: 10),
          buildSubtitle("Here are some yoga exercises:"),
          ...buildImageWidgets(sectionImages['exercise']),
          const SizedBox(height: 10),
          buildSubtitle("Watch some Exercises videos:"),
          ...buildLinkWidgets(sectionLinks['exercise']),

          sectionDivider(),
          buildTitle("2. Diet:"),
          buildText(firestoreTexts["2.diet"]),
          ...buildImageWidgets(sectionImages['diet']),
          ...buildLinkWidgets(sectionLinks['diet']),

          sectionDivider(),
          buildTitle("3. Essential Vitamins and Minerals:"),
          buildText(firestoreTexts["3. Essential Vitamins and Minerals:"]),
          ...buildImageWidgets(sectionImages['essential']),
          ...buildLinkWidgets(sectionLinks['essential']),

          sectionDivider(),
          buildTitle("4. Drink Water:"),
          buildText(firestoreTexts["4. Drink Water:"]),
          ...buildImageWidgets(sectionImages['water']),
          ...buildLinkWidgets(sectionLinks['water']),

          sectionDivider(),
          buildTitle("5. Additional Tips:"),
          buildText(firestoreTexts["5.tips"]),

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
            fontSize: 20,
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
