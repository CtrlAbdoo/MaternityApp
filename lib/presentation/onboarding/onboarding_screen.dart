import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/onboarding/onboarding_view.dart';
import 'package:maternity_app/presentation/register/register_view.dart';
import 'package:maternity_app/presentation/resources/color_manager.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ColorManager.BG_Gradient,
        ),
        child: PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            OnboardingPage(
              title: 'Welcome to\nMamativity',
              description:
              'The perfect app to support your\njourney through motherhood,\nfrom pregnancy to\nparenting.',
              imagePath: 'assets/images/mother_with_baby1.png',
              buttonText: 'Continue',
              currentIndex: 0,
              totalPages: 3,
              onButtonPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            OnboardingPage(
              title: 'Everything you\nneed in one\nplace',
              description:
              '“Pregnancy monitoring week by week”\n“Daily tips for child care”',
              imagePath: 'assets/images/family.png',
              buttonText: 'Continue',
              currentIndex: 1,
              totalPages: 3,
              onButtonPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            OnboardingPage(
              title: 'Get started now\nwith Mamativity',
              description:
              'Create your account and enjoy an\nexperience completely customized\nto your needs.',
              imagePath: 'assets/images/mother_with_child.png',
              buttonText: 'Start now',
              currentIndex: 2,
              totalPages: 3,
              onButtonPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
