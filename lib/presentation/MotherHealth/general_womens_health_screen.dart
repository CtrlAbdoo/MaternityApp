import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
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
  Map<String, Map<String, dynamic>> sectionData = {};
  bool _isLoading = true;
  String? _errorMessage;
  String? _greetingMessage;

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
      // Fetch the document to get the greeting message
      final docSnapshot = await FirebaseFirestore.instance
          .collection('mothers health')
          .doc('general women\'s health')
          .get();

      if (docSnapshot.exists) {
        _greetingMessage = docSnapshot.data()?['welcome, super mama!'] ?? '';
      }

      List<String> subCollections = [
        '1. regular checkups',
        '2. daily nutrition',
        '3. healthy lifestyle habits',
        '4. mental health',
        '5. personal hygiene',
      ];

      for (var section in subCollections) {
        final subCollection = await FirebaseFirestore.instance
            .collection('mothers health')
            .doc('general women\'s health')
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

  Future<void> addSampleDataToFirestore() async {
    try {
      // Add greeting message to the document
      await FirebaseFirestore.instance
          .collection('mothers health')
          .doc('general women\'s health')
          .set({'welcome, super mama!': 'welcome, super mama!'});

      Map<String, Map<String, dynamic>> sampleData = {
        '1. regular checkups': {
          'content':
          'Regular checkups are essential for maintaining good health.\n• Annual physical exams\n• Blood pressure and cholesterol screening\n• Pap smears and mammograms as recommended',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '1. Regular Checkups',
          'originalTitle': 'General Women\'s Health',
          'publicationDate': '2025-04-24',
        },
        '2. daily nutrition': {
          'content':
          'A balanced diet supports overall well-being.\n• Eat plenty of fruits and vegetables\n• Include whole grains and lean proteins\n• Stay hydrated with water',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '2. Daily Nutrition',
          'originalTitle': 'General Women\'s Health',
          'publicationDate': '2025-04-24',
        },
        '3. healthy lifestyle habits': {
          'content':
          'Adopt habits that promote long-term health.\n• Exercise regularly (at least 30 minutes most days)\n• Get 7-8 hours of sleep per night\n• Avoid smoking and limit alcohol',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '3. Healthy Lifestyle Habits',
          'originalTitle': 'General Women\'s Health',
          'publicationDate': '2025-04-24',
        },
        '4. mental health': {
          'content':
          'Mental health is just as important as physical health.\n• Practice stress management techniques like meditation\n• Stay connected with loved ones\n• Seek professional help if needed',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '4. Mental Health',
          'originalTitle': 'General Women\'s Health',
          'publicationDate': '2025-04-24',
        },
        '5. personal hygiene': {
          'content':
          'Good hygiene prevents infections and promotes confidence.\n• Shower daily and maintain oral hygiene\n• Keep nails clean and trimmed\n• Use deodorant and change clothes regularly',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '5. Personal Hygiene',
          'originalTitle': 'General Women\'s Health',
          'publicationDate': '2025-04-24',
        },
      };

      for (var section in sampleData.keys) {
        await FirebaseFirestore.instance
            .collection('mothers health')
            .doc('general women\'s health')
            .collection(section)
            .doc('content')
            .set(sampleData[section]!);
      }

      print('Sample data added to Firestore for General Women\'s Health');
    } catch (e) {
      print('Error adding sample data: $e');
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
                      'General Women’s Health',
                      style: GoogleFonts.inriaSerif(
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_greetingMessage != null && _greetingMessage!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        _greetingMessage!,
                        style: GoogleFonts.inriaSerif(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    buildSection(
                      title: '1. Regular Checkups',
                      content: sectionData['1. regular checkups']?['content'],
                      images: sectionData['1. regular checkups']?['images'],
                      links: sectionData['1. regular checkups']?['links'],
                    ),
                    buildSection(
                      title: '2. Daily Nutrition',
                      content: sectionData['2. daily nutrition']?['content'],
                      images: sectionData['2. daily nutrition']?['images'],
                      links: sectionData['2. daily nutrition']?['links'],
                    ),
                    buildSection(
                      title: '3. Healthy Lifestyle Habits',
                      content: sectionData['3. healthy lifestyle habits']?['content'],
                      images: sectionData['3. healthy lifestyle habits']?['images'],
                      links: sectionData['3. healthy lifestyle habits']?['links'],
                    ),
                    buildSection(
                      title: '4. Mental Health',
                      content: sectionData['4. mental health']?['content'],
                      images: sectionData['4. mental health']?['images'],
                      links: sectionData['4. mental health']?['links'],
                    ),
                    buildSection(
                      title: '5. Personal Hygiene',
                      content: sectionData['5. personal hygiene']?['content'],
                      images: sectionData['5. personal hygiene']?['images'],
                      links: sectionData['5. personal hygiene']?['links'],
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