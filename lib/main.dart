import 'package:final_exam_flutter/forgot_password.dart';
import 'package:final_exam_flutter/registor_account.dart';
import 'package:flutter/material.dart';

import 'copoment/custom_buttom_widget.dart';
import 'copoment/custom_header_widget.dart';
import 'copoment/custom_textfield.dart';
import 'db/UserDatabaseHelper.dart';
import 'profile_screen.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/forgot' : (context) => forgotPassword(),
        '/registor': (context) => Registor_Screen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CustomHeaderWidget(
              imagePath: 'asset/img.png',   // Đường dẫn ảnh nền
              logoPath: 'asset/img.png',   // Đường dẫn logo
              title: 'Chào mừng!',           // Tiêu đề
              subtitle: 'Đăng nhập vào tài khoản của bạn', // Phụ đề
            ),
            SizedBox(height: 40),
            LoginFormWidget(),
            SizedBox(height: 20),
            ActionButtonsWidget(),
          ],
        ),
      ),
    );
  }
}




// LoginForm sử dụng CustomInputField cho email và password
class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var user = await UserDatabaseHelper().login(_emailController.text, _passwordController.text);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng nhập thành công, xin chào ${user.name}')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sai email hoặc mật khẩu')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng kiểm tra lại dữ liệu')));
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email không được để trống';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          SizedBox(width: 340,
           child: CustomInputField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              endIcon: Icons.remove_red_eye,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu không được để trống';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: 340,
            child: CustomElevatedButton(
                onPressed: _submitForm,  // Chuyển hướng tới hàm _submitForm
                label: 'Đăng nhập',       // Text hiển thị trên nút
                icon: Icons.login,        // Icon của nút
                color: Colors.orange,     // Màu nền của nút
              ),
          )
        ],
      ),
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 150,
          child:  TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.key, color: Colors.deepPurpleAccent),
                    Text('Quên mật khẩu?', style: TextStyle(color: Colors.indigo)),
                  ],
                )
            ),
          ),

        DividerWithText(text: 'Hoặc'),
        SizedBox(height: 20),
        Text("Chưa có tài khoản"),
        SizedBox(height: 10),
        SizedBox(
          width: 220,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/registor');
            },
            icon: Icon(Icons.child_friendly, color: Colors.indigo),
            label: Text('Đăng ký ngay', style: TextStyle(color: Colors.indigo)),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.indigo, width: 2),
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
