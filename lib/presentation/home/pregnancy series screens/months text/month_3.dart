import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Month3 extends StatelessWidget {
  const Month3({super.key});

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
          "In the third month of pregnancy, it is important for the mother to take special care of her health because it plays a major role in the development of the fetus. Here are the most important tips related to vitamins, exercises, food, and drinking water.",
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
            '''Brisk walking:

(20-30 minutes daily)
Improves cardiovascular fitness and reduces swelling.
Do it in comfortable places and avoid slippery places.

Stretching exercises:

Helps relieve back pain and reduce stress on joints.
Example: Gently stretching legs and arms, neck rotation exercises.

Yoga exercises:

Reduces stress and helps with proper breathing.
Avoid positions that require abdominal pressure or difficult balance.

Kegel exercises:

Strengthens pelvic muscles and helps control bladder.
Tighten pelvic muscles for 5-10 seconds then relax, repeat 10-15 times daily.

Light weight exercises:

Use light weights (1-2 kg) to exercise arms and shoulders.
Ensure slow and balanced movements.

Swimming:
Reduces stress on joints and back.
Avoid diving or violent movements in water.

Tips for safe exercise:

Start slowly and gradually increase the duration of your exercises.
 Drink water before and after exercising to avoid dehydration.
 Wear comfortable clothes and suitable sports shoes.
 Stop immediately if you feel tired, dizzy, or short of breath.
 Avoid exercises that require lying on your back for a long time after the first trimester of pregnancy.

When should you stop exercising?

If you feel abdominal pain or bleeding.
If you experience dizziness or a rapid heartbeat.
If you feel contractions or pressure in the pelvic area.''',
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

400-600 mcg daily
Prevents neural tube defects.
Found in leafy greens, oranges, and legumes.

Iron:
27 mg daily
Helps in the formation of red blood cells and prevents anemia.
Found in liver (in moderation), red meat, lentils, and spinach.

Calcium:

 1000 mg daily
Supports the growth of bones and teeth of the fetus.
Found in milk, cheese, yogurt, and almonds.

Vitamin D:

600 IU daily
Helps absorb calcium and strengthen bones.
Found in sunlight, fatty fish, and eggs.

Omega 3:

200-300 mg daily
Promotes the growth of the brain and eyes of the fetus.
Found in salmon, walnuts, and flax seeds.

Vitamin B6 – 1.9 mg daily

Reduces morning sickness and promotes a healthy nervous system.
Found in bananas, chicken, potatoes, and walnuts.

Magnesium: 

350-400 mg daily
Reduces muscle cramps and helps regulate blood pressure.
Found in nuts, whole grains, leafy greens.

Tips for taking vitamins correctly:

Take vitamins with food to avoid nausea.
Do not combine iron with calcium because calcium prevents iron absorption.
Drink plenty of water when taking supplements.
Consult your doctor before taking any additional nutritional supplements.

When should you consult a doctor?

If you suffer from severe constipation due to iron.
If you notice sensitivity or stomach upset after taking supplements.''',
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

Helps build fetal and placental tissues.
Eat lean meat, chicken, eggs, fish (salmon, sardines), legumes, nuts.

Vegetables and fruits:

Rich in vitamins and minerals and reduce constipation.
Eat spinach, broccoli, carrots, tomatoes, oranges, bananas, apples, berries.

Calcium and vitamin D:

Support the growth of bones and teeth of the fetus.
Eat milk, yogurt, cheese, almonds, eggs, sardines.

Iron and folic acid:

Prevent anemia and birth defects.
Eat liver (in moderation), spinach, lentils, chickpeas, whole grains.

Healthy carbohydrates:

Give you energy and improve digestion.
Eat oats, potatoes, brown rice, whole grain bread.

Healthy fats and omega-3:

Essential for fetal brain development.
Eat avocado, olive oil, walnuts, flax seeds.

Foods to avoid:

Raw or undercooked foods such as raw eggs and undercooked meats.
Seafood high in mercury such as canned tuna.
Soft drinks and excess caffeine (do not exceed 200 mg of caffeine per day).
Processed and canned foods due to preservatives.
Foods high in sugars and saturated fats such as sweets and fried foods.

Additional tips:

Eat 5-6 small meals a day instead of 3 large meals to reduce nausea.
Drink 8-10 glasses of water a day to stay hydrated.
Eat ginger or lemon to relieve morning sickness.
Don't skip breakfast, try to include proteins and healthy carbohydrates.

When should you see a doctor?

If you have severe loss of appetite or excessive vomiting.
If you notice severe weight loss or excessive weight gain.''',
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
            '''The amount of water required daily:

Drink 8-12 cups of water daily (equivalent to 2-3 liters).
The amount can be increased if you live in a hot climate or are physically active.
If the urine color is dark, this means that you need to drink more water.

The best drinks for pregnant women in the third month :

Water - the most important drink to maintain hydration.
Milk - rich in calcium and proteins necessary for the growth of the fetus.
Natural fruit juices - such as orange, pomegranate, apple (without added sugar).
Safe herbal drinks - such as ginger, mint, cumin (help reduce nausea).
Coconut water - a great source of natural electrolytes that prevent dehydration.
Soup - such as lentil or vegetable soup, it provides you with fluids and nutrients.

Drinks to avoid:

Soft drinks - cause bloating and increase blood sugar.
Excess caffeine – do not exceed 200 mg per day (about one cup of coffee).
Sugary and canned drinks – increase the risk of diabetes and unhealthy weight gain.
Green tea in large quantities – can affect iron absorption.
Tips to ensure you drink enough fluids:
Always carry a water bottle with you and drink from it regularly.
Start your day with a cup of warm water with lemon.
Eat foods rich in water such as watermelon, cucumber, orange.
You can add lemon slices or mint to your water to improve the taste.
Divide your water intake throughout the day, and do not drink a large amount at once.

When should you consult a doctor?

If you feel dry mouth or persistent dizziness.
If you suffer from severe constipation or decreased urine output.''',
            style: GoogleFonts.inriaSerif(textStyle: TextStyle(fontSize: 14)),
            textAlign: TextAlign.start,
          ),
        ),

        const SizedBox(height: 10),


      ],
    );
  }
}
