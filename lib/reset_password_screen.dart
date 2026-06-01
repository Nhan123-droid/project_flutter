import 'package:flutter/material.dart';
import 'db/UserDatabaseHelper.dart';
import 'copoment/custom_textfield.dart';
import 'copoment/custom_buttom_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      var user = await UserDatabaseHelper().getUserByEmail(widget.email);
      if (user != null) {
        user.password = _passwordController.text;
        await UserDatabaseHelper().updateUser(user);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đổi mật khẩu thành công!')));
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Về màn hình đăng nhập
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không tìm thấy người dùng')));
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải lớn hơn 6 ký tự';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomInputField(
                controller: _confirmPasswordController,
                hintText: 'Xác nhận mật khẩu',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
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
