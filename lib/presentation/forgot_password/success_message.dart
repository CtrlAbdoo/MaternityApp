import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/forgot_password/status_message.dart';
import 'package:maternity_app/presentation/login/login_view.dart';

class SuccessMessage extends StatelessWidget {
  const SuccessMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: StatusMessage(
        backgroundColor: Color(0xFFFEF7FF),
        buttonBorderColor: Color(0xff22CB0F),
        buttonIconColor: Color(0xff22CB0F),
        imageAsset: 'assets/images/success.png',
        mainText: 'Success',
        mainTextColor: Color(0xff22CB0F),
        secondaryText: 'Everything is working\nnormally.',
        secondaryTextColor: Colors.black54,
        nextPage: const LoginView(),
      ),
    );
  }
}
