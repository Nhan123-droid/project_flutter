import 'package:final_exam_flutter/forgot_password.dart';
import 'package:final_exam_flutter/registor_account.dart';
import 'package:flutter/material.dart';

import 'copoment/custom_buttom_widget.dart';
import 'copoment/custom_header_widget.dart';
import 'copoment/custom_textfield.dart';
import 'db/user_database_helper.dart';
import 'profile_screen.dart';
import 'utils/form_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/forgot': (context) => const ForgotPassword(),
        '/registor': (context) => const RegistorScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CustomHeaderWidget(
                  imagePath: 'asset/img.png',
                  logoPath: 'asset/img.png',
                  title: 'Chào mừng!',
                  subtitle: 'Đăng nhập vào tài khoản của bạn',
                ),
                SizedBox(height: 36),
                LoginFormWidget(),
                SizedBox(height: 20),
                ActionButtonsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại dữ liệu')),
      );
      return;
    }

    final user = await UserDatabaseHelper().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thành công, xin chào ${user.name}')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sai email hoặc mật khẩu')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 340,
            child: CustomInputField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email,
              endIcon: null,
              validator: FormValidators.email,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 340,
            child: CustomInputField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              endIcon: Icons.remove_red_eye,
              obscureText: true,
              validator: FormValidators.password,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 340,
            child: CustomElevatedButton(
              onPressed: _submitForm,
              label: 'Đăng nhập',
              icon: Icons.login,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 170,
          child: TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/forgot');
            },
            icon: const Icon(Icons.key, color: Colors.deepPurpleAccent),
            label: const Text(
              'Quên mật khẩu?',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ),
        const DividerWithText(text: 'Hoặc'),
        const SizedBox(height: 20),
        const Text('Chưa có tài khoản'),
        const SizedBox(height: 10),
        SizedBox(
          width: 220,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/registor');
            },
            icon: const Icon(Icons.child_friendly, color: Colors.indigo),
            label: const Text(
              'Đăng ký ngay',
              style: TextStyle(color: Colors.indigo),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.indigo, width: 2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
