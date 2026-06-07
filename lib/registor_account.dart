import 'dart:io';
import 'package:final_exam_flutter/copoment/custom_buttom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'copoment/custom_header_widget.dart';
import 'copoment/custom_textfield.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'db/user_database_helper.dart';
import 'model/user.dart';
import 'utils/form_validators.dart';

class RegistorScreen extends StatelessWidget {
  const RegistorScreen({super.key});

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
              subtitle: 'Gia nhập cộng đồng UTC2 hôm nay',
            ),
            SizedBox(height: 5),
            RegistorForm(),
            SizedBox(height: 30),
            DividerWithText(text: 'Hoặc'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.child_friendly, color: Colors.indigo),
              label: Text(
                'Đăng nhập ngay',
                style: TextStyle(color: Colors.indigo),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.indigo, width: 2),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioButtonFormField extends FormField<String> {
  RadioButtonFormField({
    super.key,
    required String label,
    required List<String> options,
    required super.initialValue,
    required ValueChanged<String?> onChanged,
    super.validator,
  }) : super(
         builder: (field) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(
                 width: 380,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(15),
                   border: Border.all(
                     color: field.hasError ? Colors.red : Colors.grey.shade300,
                   ),
                 ),
                 padding: EdgeInsets.symmetric(vertical: 8),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Text(
                         label,
                         style: TextStyle(
                           color: Colors.grey.shade700,
                           fontSize: 16,
                         ),
                       ),
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children:
                           options.map((option) {
                             return Row(
                               children: [
                                 Radio<String>(
                                   value: option,
                                   // ignore: deprecated_member_use
                                   groupValue: field.value,
                                   activeColor: Colors.indigo,
                                   // ignore: deprecated_member_use
                                   onChanged: (value) {
                                     field.didChange(value);
                                     onChanged(value);
                                   },
                                 ),
                                 Text(option, style: TextStyle(fontSize: 16)),
                               ],
                             );
                           }).toList(),
                     ),
                   ],
                 ),
               ),
               if (field.hasError)
                 Padding(
                   padding: const EdgeInsets.only(left: 12, top: 6),
                   child: Text(
                     field.errorText!,
                     style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}

class RegistorForm extends StatefulWidget {
  const RegistorForm({super.key});

  @override
  State<RegistorForm> createState() => _RegistorFormState();
}

class _RegistorFormState extends State<RegistorForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _datetimeController = TextEditingController();
  // Biến lưu giá trị giới tính
  String? _selectedGender;
  File? _avatarFile;

  // Danh sách các lựa chọn giới tính
  final List<String> _genders = ['Nam', 'Nữ'];
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng kiểm tra lại dữ liệu')));
      return;
    }

    if (!isAgree) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đồng ý điều khoản sử dụng')),
      );
      return;
    }

    try {
      final email = _emailController.text.trim();
      final existingUser = await UserDatabaseHelper().getUserByEmail(email);
      if (!mounted) return;
      if (existingUser != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email đã được đăng ký')));
        return;
      }

      DateTime dob = DateFormat(
        'MM/dd/yyyy',
      ).parseStrict(_datetimeController.text);
      User newUser = User(
        name: _nameController.text.trim(),
        email: email,
        phone: _phoneController.text.trim(),
        genDer: _selectedGender!,
        dateOfBirth: dob,
        password: _passwordController.text,
        avatarPath: _avatarFile?.path,
      );

      await UserDatabaseHelper().insertUser(newUser);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate == null) return;
    setState(() {
      _datetimeController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
    });
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
      child: SizedBox(
        height: 950,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child:
                          _avatarFile != null
                              ? Image.file(_avatarFile!, fit: BoxFit.cover)
                              : Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                    ),
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
                  ),
                ],
              ),
            ),
            CustomInputField(
              controller: _nameController,
              hintText: 'Họ và tên',
              prefixIcon: Icons.person,
              endIcon: null,
              validator: FormValidators.fullName,
            ),
            // Email
            CustomInputField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email,
              validator: FormValidators.email,
            ),
            CustomInputField(
              controller: _phoneController,
              hintText: 'Số điện thoại',
              prefixIcon: Icons.phone,
              validator: FormValidators.phone,
            ),

            // Ngày sinh
            TextFormField(
              controller: _datetimeController,
              obscureText: false,
              validator: FormValidators.dateOfBirth,
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed:
                      () => _selectDate(
                        context,
                      ), // Gọi DatePicker khi nhấn vào icon
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
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
                FilteringTextInputFormatter.allow(
                  RegExp(r'\d+/(\d{0,2})/(\d{0,4})'),
                ),
              ],
            ),
            // Giới tính
            RadioButtonFormField(
              label: 'Giới tính:',
              options: _genders,
              initialValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn giới tính';
                }
                return null;
              },
            ),

            CustomInputField(
              controller: _passwordController,
              hintText: 'Mật khẩu',
              prefixIcon: Icons.password,
              validator: FormValidators.password,
              onChanged: _checkPasswordStrength,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('Password Strength'),
                LinearProgressIndicator(
                  value: _strength / 5, // Mức độ bảo mật tối đa là 5
                  backgroundColor: Colors.grey.shade300,
                  color:
                      _strength == 5
                          ? Colors.green
                          : _strength >= 3
                          ? Colors.orange
                          : Colors.red,
                ),
              ],
            ),

            CustomInputField(
              controller: _confirmPasswordController,
              hintText: 'Mật khẩu xác nhận ',
              prefixIcon: Icons.password,
              validator:
                  (value) => FormValidators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
            ),

            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgree,
                    onChanged: (value) {
                      setState(() {
                        isAgree = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        children: [
                          Text("Tôi đồng ý với "),
                          Text(
                            "Điều khoản sử dụng",
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          ),
                          Text(" và "),
                          Text(
                            "Chính sách bảo mật",
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          ),
                          Text(" của UTC2"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 370,
              child: CustomElevatedButton(
                onPressed: _submitForm,
                label: 'Đăng ký tài khoản',
                icon: Icons.person,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
