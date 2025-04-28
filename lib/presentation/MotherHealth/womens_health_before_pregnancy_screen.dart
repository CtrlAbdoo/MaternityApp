import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class WomensHealthBeforePregnancyScreen extends StatefulWidget {
  const WomensHealthBeforePregnancyScreen({super.key});

  @override
  State<WomensHealthBeforePregnancyScreen> createState() => _WomensHealthBeforePregnancyScreenState();
}

class _WomensHealthBeforePregnancyScreenState extends State<WomensHealthBeforePregnancyScreen> {
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
          .doc('women\'s health before pregnancy')
          .get();

      if (docSnapshot.exists) {
        _greetingMessage = docSnapshot.data()?['welcome, super mama!'] ?? '';
      }

      List<String> subCollections = [
        '1. essential medical tests',
        '2. nutrition & supplements',
        '3. fertility & cycle awareness',
        '4. healthy lifestyle',
        '5. doctor consultation',
        '6. mental readiness',
      ];

      for (var section in subCollections) {
        final subCollection = await FirebaseFirestore.instance
            .collection('mothers health')
            .doc('women\'s health before pregnancy')
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
          .doc('women\'s health before pregnancy')
          .set({'welcome, super mama!': 'welcome, super mama!'});

      Map<String, Map<String, dynamic>> sampleData = {
        '1. essential medical tests': {
          'content':
          'Get these tests before planning pregnancy.\n• Blood tests for anemia and infections\n• Screen for STDs\n• Check thyroid function',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '1. Essential Medical Tests',
          'originalTitle': 'Women\'s Health Before Pregnancy',
          'publicationDate': '2025-04-24',
        },
        '2. nutrition & supplements': {
          'content':
          'Prepare your body with proper nutrition.\n• Start taking folic acid supplements (400-800 mcg daily)\n• Eat a balanced diet rich in iron and calcium\n• Avoid processed foods',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '2. Nutrition & Supplements',
          'originalTitle': 'Women\'s Health Before Pregnancy',
          'publicationDate': '2025-04-24',
        },
        '3. fertility & cycle awareness': {
          'content':
          'Understand your fertility window.\n• Track your menstrual cycle using an app\n• Note ovulation signs like basal body temperature\n• Plan intercourse during fertile days',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '3. Fertility & Cycle Awareness',
          'originalTitle': 'Women\'s Health Before Pregnancy',
          'publicationDate': '2025-04-24',
        },
        '4. healthy lifestyle': {
          'content':
          'Adopt a healthy lifestyle for conception.\n• Exercise regularly but avoid overexertion\n• Quit smoking and limit caffeine\n• Maintain a healthy weight',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '4. Healthy Lifestyle',
          'originalTitle': 'Women\'s Health Before Pregnancy',
          'publicationDate': '2025-04-24',
        },
        '5. doctor consultation': {
          'content':
          'Consult your doctor before trying to conceive.\n• Discuss any existing medical conditions\n• Review medications for safety\n• Get vaccinated if needed',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '5. Doctor Consultation',
          'originalTitle': 'Women\'s Health Before Pregnancy',
          'publicationDate': '2025-04-24',
        },
        '6. mental readiness': {
          'content':
          'Prepare mentally for pregnancy.\n• Reduce stress through mindfulness practices\n• Discuss expectations with your partner\n• Build a support network',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '6. Mental Readiness',
          'originalTitle': 'Women\'s Health Before Pregnancy',
          'publicationDate': '2025-04-24',
        },
      };

      for (var section in sampleData.keys) {
        await FirebaseFirestore.instance
            .collection('mothers health')
            .doc('women\'s health before pregnancy')
            .collection(section)
            .doc('content')
            .set(sampleData[section]!);
      }

      print('Sample data added to Firestore for Women\'s Health Before Pregnancy');
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
                      'Women’s Health Before Pregnancy',
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
                      title: '1. Essential Medical Tests',
                      content: sectionData['1. essential medical tests']?['content'],
                      images: sectionData['1. essential medical tests']?['images'],
                      links: sectionData['1. essential medical tests']?['links'],
                    ),
                    buildSection(
                      title: '2. Nutrition & Supplements',
                      content: sectionData['2. nutrition & supplements']?['content'],
                      images: sectionData['2. nutrition & supplements']?['images'],
                      links: sectionData['2. nutrition & supplements']?['links'],
                    ),
                    buildSection(
                      title: '3. Fertility & Cycle Awareness',
                      content: sectionData['3. fertility & cycle awareness']?['content'],
                      images: sectionData['3. fertility & cycle awareness']?['images'],
                      links: sectionData['3. fertility & cycle awareness']?['links'],
                    ),
                    buildSection(
                      title: '4. Healthy Lifestyle',
                      content: sectionData['4. healthy lifestyle']?['content'],
                      images: sectionData['4. healthy lifestyle']?['images'],
                      links: sectionData['4. healthy lifestyle']?['links'],
                    ),
                    buildSection(
                      title: '5. Doctor Consultation',
                      content: sectionData['5. doctor consultation']?['content'],
                      images: sectionData['5. doctor consultation']?['images'],
                      links: sectionData['5. doctor consultation']?['links'],
                    ),
                    buildSection(
                      title: '6. Mental Readiness',
                      content: sectionData['6. mental readiness']?['content'],
                      images: sectionData['6. mental readiness']?['images'],
                      links: sectionData['6. mental readiness']?['links'],
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