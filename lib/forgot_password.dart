

import 'package:final_exam_flutter/copoment/custom_header_widget.dart';
import 'package:final_exam_flutter/copoment/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'service/smtp_service.dart';
import 'otp_verification_screen.dart';

class forgotPassword extends StatelessWidget {
  const forgotPassword({super.key});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16),

          child: Column(
            children: [
              CustomHeaderWidget(imagePath: 'asset/img.png', logoPath: 'asset/img.png', title: 'Quên mật khẩu', subtitle: 'Đừng lo lắng, chúng tôi sẽ giúp bạn'),
              SizedBox(height: 30,),
              Introduce(),
              SizedBox(height: 30,),
              _ForgotPasswordFromWidgetState(),
            ],

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
      child: Container(
        width: 340,
        height: 100,
        color: Colors.white70,
        child: Row(
          children: [
            Container(
              width: 4,
              color: Colors.indigo,
            ),
            SizedBox(width: 20,),
          Expanded(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.indigo, ),
                  SizedBox(width: 10,),
                  Text("Hướng dẫn ", style: TextStyle(color : Colors.indigo, fontWeight: FontWeight.bold), )
                ],
              ),
              SizedBox(height: 10),
              Text("Nhập địa chỉ email đã đăng ký để nhận liên kết "),
              Text("đặt lại mật khẩu. Kiểm tra cả họp thư rác "),
              Text("nếu không thấy email ")
            ],
          ))
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordFromWidgetState extends StatefulWidget {
  const _ForgotPasswordFromWidgetState({super.key});

  @override
  State<_ForgotPasswordFromWidgetState> createState() => _ForgotPasswordFromWidgetStateState();
}

class _ForgotPasswordFromWidgetStateState extends State<_ForgotPasswordFromWidgetState> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailControler = TextEditingController();
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );
      
      String? otp = await SmtpService().sendPasswordResetEmail(_emailControler.text);
      
      Navigator.pop(context); // Đóng loading dialog
      
      if (otp != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã gửi email khôi phục thành công!')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpVerificationScreen(email: _emailControler.text, otp: otp)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi gửi email, vui lòng thử lại sau.')));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 340,
              height: 60,
              child: CustomInputField(controller: _emailControler , hintText: 'Địa chỉ email', prefixIcon: Icons.email, validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Email can not empty';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Email không hợp lệ';
                }
                return null;
              }, ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 340,
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.airline_stops, color: Colors.white),
                label: Text(
                  'Gửi liên kết đặt lại',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                ),
              ),
            ),
           SizedBox(
             height: 20,
           ),
           SizedBox(
             width: 170,
             child:  TextButton(
                 onPressed: () {
                   Navigator.pop(context);
                 },
                 child: Row(
                     children: [
                       Icon(Icons.arrow_back),
                       Text("Quay lại đăng nhập")
                     ]

                 ))
             ,
           ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: Row(
                  children: [
                    Text("Vẫn gặp vấn đề? "),
                    Text("Liên hệ hỗ trợ", style: TextStyle(color: Colors.deepPurpleAccent),)
                  ]
                  )
            ),

          ],
        )
    );
  }
}
