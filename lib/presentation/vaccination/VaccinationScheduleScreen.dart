import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maternity_app/presentation/vaccination/VaccinationCard.dart';
import 'package:maternity_app/presentation/common/CustomDrawer.dart';
import 'package:maternity_app/presentation/common/CustomAppBar2.dart';

class VaccinationScheduleScreen extends StatelessWidget {
  const VaccinationScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Builder(
                builder: (context) => const CustomAppBarWithLogo(),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vaccination Schedule',
                  style: GoogleFonts.inriaSerif(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Vaccinations')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
      
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No data found.'));
                    }
      
                    final docs = snapshot.data!.docs;
      
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
      
                        return VaccinationCard(
                          date: data['createdAt'] != null
                              ? (data['createdAt'] as Timestamp).toDate().toString().split(' ')[0]
                              : 'Unknown',
                          age: data['age'] ?? '',
                          name: docs[index].id,
                          description: data['disease'] ?? '',
                          status: data['isDeleted'] == 'true' ? 'optional' : 'compulsory',
                          howToGive: data['method'] ?? '',
                          doseSize: data['doseSize'] ?? 'Not specified',
                          sideEffects: 'Not specified',
                          availability: 'Available in health units affiliated with the Ministry of Health',
                        );
      
                      },
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
