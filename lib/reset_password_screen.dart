import 'package:flutter/material.dart';
import 'db/user_database_helper.dart';
import 'copoment/custom_textfield.dart';
import 'copoment/custom_buttom_widget.dart';
import 'utils/form_validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      var user = await UserDatabaseHelper().getUserByEmail(widget.email);
      if (user != null) {
        user.password = _passwordController.text;
        await UserDatabaseHelper().updateUser(user);
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đổi mật khẩu thành công!')));
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        ); // Về màn hình đăng nhập
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không tìm thấy người dùng')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đặt lại mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInputField(
                controller: _passwordController,
                hintText: 'Mật khẩu mới',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: FormValidators.password,
              ),
              SizedBox(height: 20),
              CustomInputField(
                controller: _confirmPasswordController,
                hintText: 'Xác nhận mật khẩu',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator:
                    (value) => FormValidators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _resetPassword,
                  label: 'Cập nhật mật khẩu',
                  icon: Icons.save,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
