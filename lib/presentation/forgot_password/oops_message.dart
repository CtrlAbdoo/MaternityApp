import 'package:flutter/material.dart';
import 'package:maternity_app/presentation/forgot_password/reset_password_view.dart';
import 'package:maternity_app/presentation/forgot_password/status_message.dart';

class OopsMessage extends StatelessWidget {
  const OopsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: StatusMessage(
        backgroundColor: Color(0xFFFEF7FF),
        buttonBorderColor: Color(0xffFE0404),
        buttonIconColor: Color(0xffFE0404),
        imageAsset: 'assets/images/fail.png',
        mainText: 'Oops!',
        mainTextColor: Color(0xffFE0404),
        secondaryText: 'Something went wrong!\nPlease try again.',
        secondaryTextColor: Colors.black54,
        nextPage: const ResetPasswordView(),
      ),
    );
  }
}
