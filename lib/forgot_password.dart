import 'package:final_exam_flutter/copoment/custom_header_widget.dart';
import 'package:final_exam_flutter/copoment/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'db/user_database_helper.dart';
import 'otp_verification_screen.dart';
import 'service/smtp_service.dart';
import 'utils/form_validators.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomHeaderWidget(
                  imagePath: 'asset/img.png',
                  logoPath: 'asset/img.png',
                  title: 'Quên mật khẩu',
                  subtitle: 'Đừng lo lắng, chúng tôi sẽ giúp bạn',
                ),
                SizedBox(height: 30),
                Introduce(),
                SizedBox(height: 30),
                ForgotPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Introduce extends StatelessWidget {
  const Introduce({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 340,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border(left: BorderSide(color: Colors.indigo, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.indigo),
                    SizedBox(width: 10),
                    Text(
                      'Hướng dẫn',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Nhập địa chỉ email đã đăng ký để nhận mã xác thực đặt lại mật khẩu.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final user = await UserDatabaseHelper().getUserByEmail(email);
    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email chưa được đăng ký')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final otp = await SmtpService().sendPasswordResetEmail(email);
    if (!mounted) return;

    Navigator.pop(context);

    if (otp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi email khôi phục thành công!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(email: email, otp: otp),
        ),
      );
    } else {
      final error = SmtpService.lastError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error == null
                ? 'Lỗi khi gửi email, vui lòng thử lại sau.'
                : 'Lỗi gửi email: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 340,
            child: CustomInputField(
              controller: _emailController,
              hintText: 'Địa chỉ email',
              prefixIcon: Icons.email,
              validator: FormValidators.email,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 340,
            child: ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.mail, color: Colors.white),
              label: const Text(
                'Gửi mã đặt lại',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 190,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại đăng nhập'),
            ),
          ),
          const SizedBox(height: 10),
          const Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('Vẫn gặp vấn đề? '),
              Text(
                'Liên hệ hỗ trợ',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
