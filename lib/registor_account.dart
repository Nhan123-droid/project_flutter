

import 'dart:io';
import 'package:final_exam_flutter/copoment/custom_buttom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'copoment/custom_header_widget.dart';
import 'copoment/custom_textfield.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'db/UserDatabaseHelper.dart';
import 'model/User.dart';
class Registor_Screen extends StatelessWidget {
  const Registor_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
              children: [
                CustomHeaderWidget(
                    imagePath: 'asset/img.png',
                    logoPath: 'asset/img.png',
                    title: 'Tạo tài khoản mới',
                    subtitle: 'Gia nhập cộng đồng UTC2 hôm nay'
                ),
                 SizedBox(height: 5,),
                RegistorForm(),
                SizedBox(height: 30,),
                DividerWithText(text: 'Hoặc'),
                SizedBox(height: 20,),
                Container(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.child_friendly, color: Colors.indigo),
                    label: Text('Đăng nhập ngay', style: TextStyle(color: Colors.indigo)),
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
          )
          ),
    );
  }
}
class RegistorForm extends StatefulWidget {
  const RegistorForm({super.key});

  @override
  State<RegistorForm> createState() => _RegistorFormState();
}

class _RegistorFormState extends State<RegistorForm> {
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PhoneControleer = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _ConfirmPasswordController = TextEditingController();
  final TextEditingController _DatetimeController = TextEditingController();
  // Biến lưu giá trị giới tính
  String? _selectedGender;
  File? _avatarFile;

  // Danh sách các lựa chọn giới tính
  final List<String> _genders = ['Nam', 'Nữ'];
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng chọn giới tính')));
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      try {
        DateTime dob = DateFormat('MM/dd/yyyy').parseStrict(_DatetimeController.text);
        User newUser = User(
          name: _NameController.text,
          email: _EmailController.text,
          phone: _PhoneControleer.text,
          genDer: _selectedGender!,
          dateOfBirth: dob,
          password: _PasswordController.text,
          avatarPath: _avatarFile?.path,
        );
        
        await UserDatabaseHelper().insertUser(newUser);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng kiểm tra lại dữ liệu')));
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    ) ?? currentDate;

    // Cập nhật TextField với ngày đã chọn theo định dạng mm/dd/yyyy
    if (pickedDate != null) {
      setState(() {
        _DatetimeController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }
  int _strength = 0;
  bool isAgree = false;
  void _checkPasswordStrength(String password) {
    int strength = 0;

    // Kiểm tra độ dài mật khẩu
    if (password.length >= 8) {
      strength += 1;
    }

    // Kiểm tra có chứa chữ hoa không
    if (password.contains(RegExp(r'[A-Z]'))) {
      strength += 1;
    }

    // Kiểm tra có chứa chữ thường không
    if (password.contains(RegExp(r'[a-z]'))) {
      strength += 1;
    }

    // Kiểm tra có chứa số không
    if (password.contains(RegExp(r'[0-9]'))) {
      strength += 1;
    }

    // Kiểm tra có chứa ký tự đặc biệt không
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength += 1;
    }

    // Đảm bảo mức độ bảo mật không vượt quá 5 (có 5 tiêu chí)
    setState(() {
      _strength = strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          height: 950,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
                      child: _avatarFile == null ? Icon(Icons.person, size: 50, color: Colors.grey) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.indigo),
                          onPressed: _pickImage,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              CustomInputField(
                  controller: _NameController,
                hintText: 'Họ và tên',
                prefixIcon: Icons.person,
                endIcon: null,
                validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Họ và tên không thể trống';
                    }
                    if(!RegExp(r"^[a-zA-Z]+$").hasMatch(value)){
                      return 'Họ và tên không hợp lệ';
                    }
                    return null;
                },

              ),
              // Email
              CustomInputField(controller: _EmailController, hintText: 'Email', prefixIcon: Icons.email, validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Email không thể trống';
                }
                if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)){
                  return 'Email không hợp lệ';
                }
                return null;

              }),
              CustomInputField(controller: _PhoneControleer, hintText: 'Số điện thoại', prefixIcon: Icons.phone, validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Số điện thoại không thể trống';
                }
                if(!RegExp(r"^(0[3|5|7|8|9])[0-9]{8}$").hasMatch(value)){
                  return 'Số điện thoại không hợp lệ';
                }
                return null;

              }),

              // Ngày sinh
              TextFormField(
                controller: _DatetimeController,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ngày sinh không thể trống';
                  }
                  try {
                    DateFormat('MM/dd/yyyy').parseStrict(value);
                  } catch (e) {
                    return 'Ngày sinh không hợp lệ (mm/dd/yyyy)';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'mm/dd/yyyy',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context), // Gọi DatePicker khi nhấn vào icon
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  // Định dạng mm/dd/yyyy
                  FilteringTextInputFormatter.allow(RegExp(r'\d+/(\d{0,2})/(\d{0,4})')),
                ],


              ),
              // Giới tính
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Giới tính:', style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _genders.map((gender) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: gender,
                              groupValue: _selectedGender,
                              activeColor: Colors.indigo,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Text(gender, style: TextStyle(fontSize: 16)),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              CustomInputField(controller: _PasswordController, hintText: 'Mật khẩu', prefixIcon: Icons.password, validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Mật khẩu không thể trống';
                }
                if(value.length < 6){
                  return 'Mật khẩu phải hơn 6 kí tự';
                }
                return null;

              }, onChanged:  _checkPasswordStrength),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Password Strength'),
                  LinearProgressIndicator(
                    value: _strength / 5, // Mức độ bảo mật tối đa là 5
                    backgroundColor: Colors.grey.shade300,
                    color: _strength == 5
                        ? Colors.green
                        : _strength >= 3
                        ? Colors.orange
                        : Colors.red,
                  ),
                ],
              ),

              CustomInputField(controller: _ConfirmPasswordController, hintText: 'Mật khẩu xác nhận ', prefixIcon: Icons.password, validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Mật khẩu xác nhận  không thể trống';
                }
                if(value.length < 6){
                  return 'Mật khẩu xác nhận phải hơn 6 kí tự';
                }
                if(value != _PasswordController.text){
                  return 'Mật khẩu xác nhận phải giống với mật khẩu';
                }
                return null;

              }),

              SizedBox(
                height: 75,

                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(value: isAgree, onChanged: (value){
                         setState(() {
                           isAgree = !isAgree;
                         });
                        }),

                        Text("Tôi đồng ý với "),
                        Text("Điều khoản sử dụng", style: TextStyle(color: Colors.deepPurpleAccent),),
                        Text(" và "),
                        Text("Chính sách", style: TextStyle(color: Colors.deepPurpleAccent),),

                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 50,),
                        Text(" bảo mật ", style: TextStyle(color: Colors.deepPurpleAccent),),
                        Text("của UTC2"),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  width: 370,
                  child: CustomElevatedButton(onPressed: _submitForm, label: 'Đăng ký tài khoản', icon: Icons.person, color: Colors.orange)),

            ],

          ),
        ),

    );
  }
}

