import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class FormulaFeedingArtificialScreen extends StatefulWidget {
  const FormulaFeedingArtificialScreen({super.key});

  @override
  State<FormulaFeedingArtificialScreen> createState() => _FormulaFeedingArtificialScreenState();
}

class _FormulaFeedingArtificialScreenState extends State<FormulaFeedingArtificialScreen> {
  Map<String, Map<String, dynamic>> sectionData = {};
  bool _isLoading = true;
  String? _errorMessage;

  get logo => null;

  @override
  void initState() {
    super.initState();
    // Uncomment the line below to add sample data to Firestore for testing, then comment it out after running once
    // addSampleDataToFirestore().then((_) {
    //   fetchFirestoreData();
    // });
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    try {
      List<String> subCollections = [
        '1. common problems and solutions',
        '2. constipation',
        '3. nutrition and fluids with formula feeding',
        '4. correct bottle feeding technique',
        '5. weaning from formula feeding',
      ];

      for (var section in subCollections) {
        final subCollection = await FirebaseFirestore.instance
            .collection('breastfeeding')
            .doc('formula feeding (artificial)')
            .collection(section)
            .doc('content')
            .get();

        print('Fetching data for section: $section');
        print('Document exists: ${subCollection.exists}');

        if (subCollection.exists) {
          final subData = subCollection.data()!;
          sectionData[section] = {
            'content': subData['content'] ?? '',
            'images': List<String>.from(subData['images'] ?? []),
            'links': List<String>.from(subData['links'] ?? []),
          };
          print('Data for $section: ${sectionData[section]}');
        } else {
          print('No data found for $section');
        }
      }

      print('Final sectionData: $sectionData');

      setState(() {
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

  // Future<void> addSampleDataToFirestore() async {
  //   try {
  //     Map<String, Map<String, dynamic>> sampleData = {
  //       '1. common problems and solutions': {
  //         'content':
  //         '• Gas and Fussiness\nCause: Air swallowed during feeding.\nSolution:\nBurp the baby halfway through and after feeding.\nHold the bottle at an angle to reduce air intake.\nConsider anti-colic bottles.',
  //         'images': [],
  //         'links': [],
  //         'createdAt': '2025-04-25T18:29:45.042Z',
  //         'originalCategory': 'Breastfeeding',
  //         'originalSubtitle': '1. Common Problems and Solutions',
  //         'originalTitle': 'Formula Feeding (Artificial)',
  //         'publicationDate': '2025-04-24',
  //       },
  //       '2. constipation': {
  //         'content':
  //         'Cause: Formula may be harder to digest than breast milk.\nSolution:\nEnsure proper formula mixing (follow instructions exactly).\nOffer small amounts of water between feeds (if baby is over 6 months).\nGently massage the baby’s tummy.',
  //         'images': [],
  //         'links': [],
  //         'createdAt': '2025-04-25T18:29:45.042Z',
  //         'originalCategory': 'Breastfeeding',
  //         'originalSubtitle': '2. Constipation',
  //         'originalTitle': 'Formula Feeding (Artificial)',
  //         'publicationDate': '2025-04-24',
  //       },
  //       '3. nutrition and fluids with formula feeding': {
  //         'content':
  //         'Nutrition:\nFormula provides balanced nutrients for growth.\nChoose iron-fortified formula.\nAvoid cow’s milk until 12 months.\nFluids:\nFormula-fed babies may need extra water in hot weather.\nAvoid sugary drinks.\nConsult a pediatrician for additional supplements.',
  //         'images': [],
  //         'links': [],
  //         'createdAt': '2025-04-25T18:29:45.042Z',
  //         'originalCategory': 'Breastfeeding',
  //         'originalSubtitle': '3. Nutrition and Fluids with Formula Feeding',
  //         'originalTitle': 'Formula Feeding (Artificial)',
  //         'publicationDate': '2025-04-24',
  //       },
  //       '4. correct bottle feeding technique': {
  //         'content':
  //         'Hold the baby in a semi-upright position.\nTilt the bottle so the nipple is always filled with formula.\nLet the baby take breaks to avoid overfeeding.\nNever prop the bottle—it can cause choking.\nhttps://www.youtube.com/watch?v=example4',
  //         'images': [],
  //         'links': ['https://www.youtube.com/watch?v=example4'],
  //         'createdAt': '2025-04-25T18:29:45.042Z',
  //         'originalCategory': 'Breastfeeding',
  //         'originalSubtitle': '4. Correct Bottle Feeding Technique',
  //         'originalTitle': 'Formula Feeding (Artificial)',
  //         'publicationDate': '2025-04-24',
  //       },
  //       '5. weaning from formula feeding': {
  //         'content':
  //         'Recommended Age:\nStart transitioning to cow’s milk at 12 months.\nHow to Wean:\nGradually mix formula with cow’s milk over a few weeks.\nIntroduce a sippy cup early to ease the transition.\nMonitor for any allergic reactions to cow’s milk.',
  //         'images': [],
  //         'links': [],
  //         'createdAt': '2025-04-25T18:29:45.042Z',
  //         'originalCategory': 'Breastfeeding',
  //         'originalSubtitle': '5. Weaning from Formula Feeding',
  //         'originalTitle': 'Formula Feeding (Artificial)',
  //         'publicationDate': '2025-04-24',
  //       },
  //     };
  //
  //     for (var section in sampleData.keys) {
  //       await FirebaseFirestore.instance
  //           .collection('breastfeeding')
  //           .doc('formula feeding (artificial)')
  //           .collection(section)
  //           .doc('content')
  //           .set(sampleData[section]!);
  //     }
  //
  //     print('Sample data added to Firestore for Formula Feeding (Artificial)');
  //   } catch (e) {
  //     print('Error adding sample data: $e');
  //   }
  // }

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
      );
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBarWithLogo(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formula Feeding (Artificial)',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildSection(
                      title: '1. Common Problems and Solutions',
                      content: sectionData['1. common problems and solutions']?['content'],
                      images: sectionData['1. common problems and solutions']?['images'],
                      links: sectionData['1. common problems and solutions']?['links'],
                    ),
                    buildSection(
                      title: '2. Constipation',
                      content: sectionData['2. constipation']?['content'],
                      images: sectionData['2. constipation']?['images'],
                      links: sectionData['2. constipation']?['links'],
                    ),
                    buildSection(
                      title: '3. Nutrition and Fluids with Formula Feeding',
                      content: sectionData['3. nutrition and fluids with formula feeding']?['content'],
                      images: sectionData['3. nutrition and fluids with formula feeding']?['images'],
                      links: sectionData['3. nutrition and fluids with formula feeding']?['links'],
                    ),
                    buildSection(
                      title: '4. Correct Bottle Feeding Technique',
                      content: sectionData['4. correct bottle feeding technique']?['content'],
                      images: sectionData['4. correct bottle feeding technique']?['images'],
                      links: sectionData['4. correct bottle feeding technique']?['links'],
                    ),
                    buildSection(
                      title: '5. Weaning from Formula Feeding',
                      content: sectionData['5. weaning from formula feeding']?['content'],
                      images: sectionData['5. weaning from formula feeding']?['images'],
                      links: sectionData['5. weaning from formula feeding']?['links'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required String? content,
    required List<String>? images,
    required List<String>? links,
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
          Text(
            title,
            style: GoogleFonts.inriaSerif(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (content != null && content.isNotEmpty)
            buildFormattedContent(content)
          else
            Text(
              'No content available for this section.',
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          if (images != null && images.isNotEmpty) ...[
            const SizedBox(height: 10),
            buildSubtitle("Images:"),
            ...buildImageWidgets(images),
          ],
          if (links != null && links.isNotEmpty) ...[
            const SizedBox(height: 10),
            buildSubtitle("Links:"),
            ...buildLinkWidgets(links),
          ],
        ],
      ),
    );
  }

  Widget buildFormattedContent(String content) {
    List<String> lines = content.split('\n');
    List<Widget> contentWidgets = [];
    List<String> currentGroup = [];

    void addGroupToWidgets() {
      if (currentGroup.isEmpty) return;

      bool isBulletList = currentGroup.every((line) => line.trim().startsWith('•'));
      bool isLink = currentGroup.length == 1 && currentGroup[0].trim().startsWith('https://');

      if (isLink) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              text: TextSpan(
                text: currentGroup[0].trim(),
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _launchURL(currentGroup[0].trim()),
              ),
            ),
          ),
        );
      } else if (isBulletList) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: currentGroup.map((line) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        line.replaceFirst('•', '').trim(),
                        style: GoogleFonts.inriaSerif(
                          textStyle: const TextStyle(fontSize: 16, height: 1.3),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      } else {
        String paragraph = currentGroup.join('\n');
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              paragraph.trim(),
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.3,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        );
      }
      currentGroup.clear();
    }

    for (var line in lines) {
      if (line.trim().endsWith(':')) {
        addGroupToWidgets();
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Text(
              line.trim(),
              style: GoogleFonts.inriaSerif(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
          ),
        );
      } else if (line.trim().startsWith('https://')) {
        addGroupToWidgets();
        currentGroup.add(line);
        addGroupToWidgets();
      } else if (line.trim().startsWith('•') && !currentGroup.every((l) => l.trim().startsWith('•'))) {
        addGroupToWidgets();
        currentGroup.add(line);
      } else if (!line.trim().startsWith('•') && currentGroup.any((l) => l.trim().startsWith('•'))) {
        addGroupToWidgets();
        currentGroup.add(line);
      } else {
        currentGroup.add(line);
      }
    }

    addGroupToWidgets();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
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

  List<Widget> buildImageWidgets(List<String> imageList) {
    if (imageList.isEmpty) {
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

  List<Widget> buildLinkWidgets(List<String> links) {
    if (links.isEmpty) return [];
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