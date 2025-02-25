import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Month2 extends StatelessWidget {
  const Month2({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "In the second month of pregnancy, it is important for the mother to take special care of her health because it plays a major role in the development of the fetus. Here are the most important tips related to vitamins, exercises, food, and drinking water.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 13)),
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
            '''Walking :

Why? Maintains general fitness, improves blood circulation, and reduces swelling.

Duration: 20-30 minutes daily, 4-5 times a week.

Tips: Wear comfortable shoes and avoid walking on uneven surfaces.

Yoga :

Why? Improves balance, increases flexibility, and helps reduce stress.

Duration: 20-30 minutes, 3-4 times a week.

Tips: Avoid positions that put pressure on the abdomen or require lying on the back for long periods.

Stretching exercises :

Why? Reduces muscle spasms and improves body flexibility.

Duration: 10-15 minutes daily.

Tips: Do gentle movements without putting extra pressure on the joints.

Kegel Exercises :

Why? Strengthens the pelvic floor muscles, which helps with childbirth and reduces urinary incontinence.

Duration: 5 minutes daily, 3 times a day.

How to perform:

1. Sit in a comfortable position.

2. Tighten your pelvic muscles as if you are trying to stop urinating.

3. Hold for 5-10 seconds, then relax.

4. Repeat 10-15 times per session.

Swimming :

Why? Maintains general fitness and reduces stress on joints.

Duration: 30 minutes, 2-3 times a week.

Tips: Avoid hot water and vigorous swimming.''',
            style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 14)),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Image.asset('assets/images/month_1.png'),
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
        TextButton(
          onPressed: () =>
              _launchURL("https://www.youtube.com/watch?v=lhotxON97xA"),
          child: Text(
            "https://www.youtube.com/watch?v=lhotxON97xA",
            style: GoogleFonts.inriaSerif(
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 14
                )),
          ),
        ),
        TextButton(
          onPressed: () =>
              _launchURL("https://www.youtube.com/watch?v=Hlp6cBstaZs"),
          child: Text(
            "https://www.youtube.com/watch?v=Hlp6cBstaZs",
            style: GoogleFonts.inriaSerif(
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 14
                )),
          ),
        ),
        TextButton(
          onPressed: () =>
              _launchURL("https://www.youtube.com/watch?v=v1io7RUEgdY"),
          child: Text(
            "https://www.youtube.com/watch?v=v1io7RUEgdY",
            style: GoogleFonts.inriaSerif(
                fontWeight: FontWeight.bold,
                textStyle: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 14
                )),
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

If you are starting for the first time, it is recommended to start with a short duration and gradually increase it according to your comfort and ability''',
            style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 14)),
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
            '''Folic acid:

Important for the development of the fetus's nervous system and reduces the risk of birth defects. Recommended dose: 400-600 mcg daily.

Iron:

Essential for the formation of red blood cells and preventing anemia. Recommended dose: 27 mg daily.
Calcium - Promotes the growth of bones and teeth of the fetus. Recommended dose: 1000 mg daily.

Vitamin D:

Helps in the absorption of calcium and strengthens bones. Recommended dose: 600 IU daily.

Omega 3:

Important for the development of the brain and eyes. Recommended dose: 200-300 mg daily.

Tips for taking vitamins correctly:

Take vitamins with food to avoid stomach upset.
Drink plenty of water with iron supplements to prevent constipation.
Do not take calcium and iron together at the same time, as calcium reduces the absorption of iron.
Consult your doctor before taking any additional nutritional supplement.''',
            style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 14)),
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
            '''Proteins:

Helps in the growth of fetal tissues and the placenta.
Eat lean meat, chicken, eggs, fish (low-mercury varieties such as salmon), legumes, and nuts.

Vegetables and fruits:

Rich in vitamins, minerals, and fiber to reduce constipation.
Eat spinach, broccoli, carrots, peppers, apples, oranges, bananas, and strawberries.

Calcium and vitamin D:

Necessary for the growth of fetal bones.
Eat milk, yogurt, cheese, almonds, sardines, and egg yolks.

Iron and folic acid:

Reduces the risk of anemia and birth defects.
Eat lentils, liver (in moderation), spinach, whole grains, and nuts.

Healthy carbohydrates:

Provides energy and reduces nausea.
Eat oats, potatoes, brown rice, and whole-grain bread.

Healthy fats and omega-3:

Supports the development of the fetus's brain and eyes.
Eat Avocado, olive oil, fish, and walnuts.

Foods to avoid:

Undercooked foods such as raw eggs and raw meat.
Seafood high in mercury such as canned tuna.
Soft drinks and excess caffeine (do not exceed 200 mg caffeine per day).
Processed and canned foods due to preservatives.
Foods high in sugars and saturated fats such as excessive sweets and fried foods.

Additional tips:

Eat 5-6 small meals a day instead of 3 large meals to reduce nausea.

Drink 8-10 glasses of water a day to stay hydrated.
Eat ginger or lemon to relieve morning sickness.

Don't skip breakfast, try to include healthy proteins and carbohydrates.''',
            style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 14)),
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
            '''Recommended amount:

You should drink 8-12 glasses of water per day (equivalent to 2-3 liters).
The amount can be increased if you live in a hot climate or are physically active.

Benefits of drinking water for pregnant women:

Prevents dehydration and protects you from headaches and dizziness.
 Reduces morning sickness and improves digestion.
 Prevents constipation and reduces the risk of hemorrhoids.
 Maintains the level of amniotic fluid around the fetus.
 Reduces swelling (puffiness) in the feet and hands.

How to drink enough water?

Start your day with a glass of water when you wake up.
Carry a water bottle with you at all times and drink from it regularly.
Add lemon slices or mint to improve the taste if you don't like plain water.
Eat fruits and vegetables rich in water such as cucumber, watermelon, oranges, and celery.
Limit drinks that cause dehydration such as coffee, tea, and excess caffeine.

When should you drink more water?

Increase your water intake if you experience severe vomiting, constipation, or excessive sweating.
If your urine is dark in color, it means you need to drink more water.''',
            style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 14)),
            textAlign: TextAlign.start,
          ),
        ),

        const SizedBox(height: 10),


      ],
    );
  }
}
