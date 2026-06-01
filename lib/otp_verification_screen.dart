import 'package:flutter/material.dart';
import 'reset_password_screen.dart';
import 'copoment/custom_textfield.dart';
import 'copoment/custom_buttom_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String otp;

  OtpVerificationScreen({required this.email, required this.otp});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      if (_otpController.text == widget.otp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mã OTP không chính xác')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Xác thực OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nhập mã 6 số vừa được gửi tới email ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              CustomInputField(
                controller: _otpController,
                hintText: 'Mã OTP',
                prefixIcon: Icons.security,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _verifyOtp,
                  label: 'Xác thực',
                  icon: Icons.check_circle,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
