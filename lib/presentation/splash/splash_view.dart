import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/home/navi_bar.dart';
import 'package:maternity_app/presentation/login/login_view.dart';
import 'package:maternity_app/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Navigate to appropriate screen after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _checkAuthState();
    });
  }

  void _checkAuthState() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    if (authViewModel.state == AuthState.authenticated) {
      _navigateToMainScreen();
    } else if (authViewModel.state == AuthState.unauthenticated) {
      _navigateToLoginScreen();
    } else if (authViewModel.state == AuthState.error) {
      _navigateToLoginScreen();
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => CustomNavigationBar()),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/baby_bg4.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 150),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
              const SizedBox(height: 20),
              const Text(
                'Maternity App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}