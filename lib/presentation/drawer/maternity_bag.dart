import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaternityBagScreen extends StatefulWidget {
  @override
  _MaternityBagScreenState createState() => _MaternityBagScreenState();
}



class _MaternityBagScreenState extends State<MaternityBagScreen> {
  bool isForBaby = true;

  final List<String> babyItems = [
    "Three sets of underwear",
    "2 full jumpsuits",
    "A light blanket in the summer and a heavy one in the winter.",
    "Light cotton socks and hat in summer and wool in winter.",
    "2 bib vest",
    "Liquid soap, shampoo and a special sponge for the little one",
    "Creams for the diaper area",
    "Milk bottle",
    "Car seat"
  ];

  final List<String> motherItems = [
    "Pregnancy follow-up card",
    "Identity card for both spouses",
    "Clothes for 3 days",
    "Towels",
    "Bathroom slippers",
    "Big diapers",
    "Moisturizing lip balm",
    "Anti-dryness ointment",
    "Body softening soap",
    "Two or more nightgowns with an opening at the chest for breastfeeding",
    "4 sets of underwear",
    "Nursing bras",
    "Breast pads",
    "Sanitary napkins",
    "Breast crack cream",
    "Silicone nipples",
    "Comfortable slippers",
    "Shampoo",
    "Face wash",
    "Moisturizing cream",
    "Toothpaste and brush",
    "Deodorant",
    "Mobile charger",
    "Pillow case",
    "Book or tablet for entertainment"
  ];

  Map<String, bool> checkedItems = {};

  @override
  void initState() {
    super.initState();
    _loadCheckedItems();
  }

  Future<void> _loadCheckedItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var item in babyItems + motherItems) {
        checkedItems[item] = prefs.getBool('checked_$item') ?? false;
      }
    });
  }

  Future<void> _saveCheckedItem(String item, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checked_$item', value);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<String> displayedItems = isForBaby ? babyItems : motherItems;

    return Scaffold(
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) => CustomAppBarWithLogo(),
              ),
              const SizedBox(height: 10),
              Text(
                "Maternity bag",
                style: GoogleFonts.inriaSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Color(0xFFCBF3FF), Color(0xFFFFB7F8)],
                    ),
                    border: Border.all(
                      color: Color(0xFFFFB7F8),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isForBaby = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isForBaby ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text("for my baby",
                                style: GoogleFonts.inriaSerif(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isForBaby = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isForBaby ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text("for me",
                                style: GoogleFonts.inriaSerif(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: displayedItems.length,
                  itemBuilder: (context, index) {
                    String item = displayedItems[index];
                    bool isChecked = checkedItems[item] ?? false;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFCBF3FF),
                                      Color(0xFFFFB7F8)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isChecked
                                      ? Color(0xFFFFB7F8)
                                      : Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: isChecked
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                          title: Text(
                            item,
                            style: GoogleFonts.inriaSerif(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              checkedItems[item] = !isChecked;
                              _saveCheckedItem(item, !isChecked);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
