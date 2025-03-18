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
  List<String> imageUrls = [];
  List<String> links = [];

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    final imagesSnapshot = await FirebaseFirestore.instance
        .collection('months')
        .doc('first')
        .collection('images')
        .get();

    final linksSnapshot = await FirebaseFirestore.instance
        .collection('months')
        .doc('first')
        .collection('links')
        .get();

    setState(() {
      imageUrls =
          imagesSnapshot.docs.map((doc) => doc['url'] as String).toList();
      links = linksSnapshot.docs.map((doc) => doc['url'] as String).toList();
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
    return imageUrls.isEmpty && links.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "In the first month of pregnancy, it is important for the mother to take special care of her health because it plays a major role in the development of the fetus. Here are the most important tips related to vitamins, exercises, food, and drinking water.",
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 15),
              Text(
                "1.Sports exercises:",
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''Light exercise is permissible provided that the mother is in good health and does not suffer from complications.

Recommended types of exercise:

Walking for 20-30 minutes daily.

You can do light exercises such as yoga for pregnant women. These activities help improve blood circulation and reduce stress.
Light stretching exercises to relieve stress and improve blood circulation.
Deep breathing and relaxation exercises.

Avoid the following sports:

Sports that require jumping or physical contact.

Avoid strenuous exercise or heavy lifting at this stage.

You can start deep breathing and relaxation exercises to relieve anxiety and improve mood.
''',
                  style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(fontSize: 14)),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Here are some yoga exercises:",
                  style: GoogleFonts.inriaSerif(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // عرض الصور من Firestore
              for (var imageUrl in imageUrls)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: Image.network(imageUrl),
                ),

              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Watch some yoga videos:",
                  style: GoogleFonts.inriaSerif(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              // عرض الروابط من Firestore
              for (var link in links)
                TextButton(
                  onPressed: () => _launchURL(link),
                  child: Text(
                    link,
                    style: GoogleFonts.inriaSerif(
                      fontWeight: FontWeight.bold,
                      textStyle: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''The duration of yoga sessions depends on your goal and fitness level. In general:

1. Beginners:

The duration can be from 15 to 30 minutes.

These sessions focus on basic movements and breathing exercises.

2. Intemediate level:

From 30 to 60 minutes.

The sessions include more challenging exercises with a focus on flexibility and strength.

3. Advanced level:

Sessions reach 60-90 minutes.

The focus is on complex movements and increasing mental and physical awareness.

4. Short sessions for meditation or relaxation:

These can be from 5 to 15 minutes, ideal during the day to relieve stress.

If you are starting for the first time, it is recommended to start with a short duration and gradually increase it according to your comfort and ability
''',
                  style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(fontSize: 14)),
                  textAlign: TextAlign.start,
                ),
              ),

              Divider(
                color: Color(0x50000000),
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              const SizedBox(height: 10),

              Text(
                "2. Vitamins and Supplements:",
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''Omega 3:

 Improves fetal brain development.

Folic acid:

It is considered the most important in the first month because it reduces the risk of neural tube defects. 

It is found in dark leafy greens, and fortified cereals.

Vitamin D:

Helps in the absorption of calcium and maintains healthy bones. 

Source: Exposure to the sun or eating fatty fish.

Iron:

Necessary for transporting oxygen and forming additional blood for the fetus. 

Sources: Red meat, spinach, and legumes.

Calcium:

Necessary for the development of bones and teeth. 

Sources: Milk, dairy products, and almonds.

It is preferable to consult a doctor to determine the 
type of nutritional supplements and doses.
''',
                  style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(fontSize: 14)),
                  textAlign: TextAlign.start,
                ),
              ),

              Divider(
                color: Color(0x50000000),
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              const SizedBox(height: 10),

              Text(
                "3.Foods rich in folic acid:",
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''Such as spinach, broccoli, lentils, and citrus fruits, because folic acid is essential for the development of the fetus's nervous system.

Recommended foods:

Fresh vegetables and fruits.

Proteins (chicken, well-cooked fish, eggs).

Whole grains (oats, brown rice).

Healthy fats (avocado, nuts).

Foods to avoid:

Raw or undercooked foods (such as sushi and uncooked meats).

Foods high in caffeine.

Processed and packaged foods.''',
                  style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(fontSize: 14)),
                  textAlign: TextAlign.start,
                ),
              ),

              const SizedBox(height: 10),

              Divider(
                color: Color(0x50000000),
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              const SizedBox(height: 10),

              Text(
                "4.Drink plenty of water:",
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''To maintain hydration and support fetal growth.

It is recommended to drink 8-10 glasses a day (about 2-2.5 liters).

Water helps to:

Prevent dehydration.

Support amniotic fluid formation.

Improves blood circulation.

Reduce or avoid caffeine intake if possible.''',
                  style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(fontSize: 14)),
                  textAlign: TextAlign.start,
                ),
              ),

              const SizedBox(height: 10),

              Divider(
                color: Color(0x50000000),
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              const SizedBox(height: 10),

              Text(
                "5.Additional tips:",
                style: GoogleFonts.inriaSerif(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                textAlign: TextAlign.start,
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''If you suspect pregnancy, it is important to start by visiting a doctor to confirm the pregnancy and monitor its development.

Avoid smoking or drinking alcohol, as they negatively affect the development of the fetus.

Important Notes:

Always consult your doctor before starting any type of exercise or supplement.

If you feel any abnormal fatigue during exercise, stop immediately.''',
                  style: GoogleFonts.inriaSerif(
                      textStyle: TextStyle(fontSize: 14)),
                  textAlign: TextAlign.start,
                ),
              ),

              const SizedBox(height: 10),
            ],
          );
  }
}
