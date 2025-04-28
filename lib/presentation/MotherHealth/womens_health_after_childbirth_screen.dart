import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/Full-ScreenImageViewerPage.dart';
import 'package:url_launcher/url_launcher.dart';

class WomensHealthAfterChildbirthScreen extends StatefulWidget {
  const WomensHealthAfterChildbirthScreen({super.key});

  @override
  State<WomensHealthAfterChildbirthScreen> createState() => _WomensHealthAfterChildbirthScreenState();
}

class _WomensHealthAfterChildbirthScreenState extends State<WomensHealthAfterChildbirthScreen> {
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
          .doc('women\'s health after childbirth')
          .get();

      if (docSnapshot.exists) {
        _greetingMessage = docSnapshot.data()?['welcome, super mama!'] ?? '';
      }

      List<String> subCollections = [
        '1. key points:',
        '2. women\'s mental health',
        '3. menstrual health',
        '4. birth control methods',
        '5. menopause (end of menstruation)',
        '6. chronic conditions in women',
        '7. breast & cervical cancer',
      ];

      for (var section in subCollections) {
        final subCollection = await FirebaseFirestore.instance
            .collection('mothers health')
            .doc('women\'s health after childbirth')
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
          .doc('women\'s health after childbirth')
          .set({'welcome, super mama!': 'welcome, super mama!'});

      Map<String, Map<String, dynamic>> sampleData = {
        '1. key points:': {
          'content':
          'Key points to focus on after childbirth:\n• Prioritize rest and recovery\n• Monitor for postpartum symptoms\n• Stay hydrated and eat nutritious foods',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '1. Key Points',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
        '2. women\'s mental health': {
          'content':
          'Postpartum mental health is critical.\n• Watch for signs of postpartum depression\n• Seek support from family or professionals\n• Practice self-care and relaxation techniques',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '2. Women\'s Mental Health',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
        '3. menstrual health': {
          'content':
          'Menstrual cycles may change after childbirth.\n• Expect irregular periods initially\n• Track your cycle to understand your new normal\n• Consult a doctor if bleeding is heavy',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '3. Menstrual Health',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
        '4. birth control methods': {
          'content':
          'Consider birth control options post-childbirth.\n• Discuss with your doctor about safe methods\n• Options include IUDs, pills, or breastfeeding as contraception\n• Be aware of fertility returning soon after birth',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '4. Birth Control Methods',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
        '5. menopause (end of menstruation)': {
          'content':
          'Menopause may still be years away, but it’s good to understand.\n• Menopause typically occurs between 45-55 years\n• Symptoms include hot flashes and mood changes\n• Prepare for this transition with healthy habits now',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '5. Menopause (End of Menstruation)',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
        '6. chronic conditions in women': {
          'content':
          'Monitor for chronic conditions post-childbirth.\n• Watch for signs of diabetes or hypertension\n• Maintain regular checkups\n• Manage stress to reduce risk',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '6. Chronic Conditions in Women',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
        '7. breast & cervical cancer': {
          'content':
          'Stay vigilant about cancer risks.\n• Perform regular breast self-exams\n• Schedule mammograms as recommended\n• Get regular Pap smears to screen for cervical cancer',
          'images': [],
          'links': [],
          'createdAt': '2025-04-25T18:29:45.042Z',
          'originalCategory': 'Mothers Health',
          'originalSubtitle': '7. Breast & Cervical Cancer',
          'originalTitle': 'Women\'s Health After Childbirth',
          'publicationDate': '2025-04-24',
        },
      };

      for (var section in sampleData.keys) {
        await FirebaseFirestore.instance
            .collection('mothers health')
            .doc('women\'s health after childbirth')
            .collection(section)
            .doc('content')
            .set(sampleData[section]!);
      }

      print('Sample data added to Firestore for Women\'s Health After Childbirth');
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
                      'Women’s Health After Childbirth',
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
                      title: '1. Key Points',
                      content: sectionData['1. key points:']?['content'],
                      images: sectionData['1. key points:']?['images'],
                      links: sectionData['1. key points:']?['links'],
                    ),
                    buildSection(
                      title: '2. Women’s Mental Health',
                      content: sectionData['2. women\'s mental health']?['content'],
                      images: sectionData['2. women\'s mental health']?['images'],
                      links: sectionData['2. women\'s mental health']?['links'],
                    ),
                    buildSection(
                      title: '3. Menstrual Health',
                      content: sectionData['3. menstrual health']?['content'],
                      images: sectionData['3. menstrual health']?['images'],
                      links: sectionData['3. menstrual health']?['links'],
                    ),
                    buildSection(
                      title: '4. Birth Control Methods',
                      content: sectionData['4. birth control methods']?['content'],
                      images: sectionData['4. birth control methods']?['images'],
                      links: sectionData['4. birth control methods']?['links'],
                    ),
                    buildSection(
                      title: '5. Menopause (End of Menstruation)',
                      content: sectionData['5. menopause (end of menstruation)']?['content'],
                      images: sectionData['5. menopause (end of menstruation)']?['images'],
                      links: sectionData['5. menopause (end of menstruation)']?['links'],
                    ),
                    buildSection(
                      title: '6. Chronic Conditions in Women',
                      content: sectionData['6. chronic conditions in women']?['content'],
                      images: sectionData['6. chronic conditions in women']?['images'],
                      links: sectionData['6. chronic conditions in women']?['links'],
                    ),
                    buildSection(
                      title: '7. Breast & Cervical Cancer',
                      content: sectionData['7. breast & cervical cancer']?['content'],
                      images: sectionData['7. breast & cervical cancer']?['images'],
                      links: sectionData['7. breast & cervical cancer']?['links'],
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