import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/user.dart';
import 'db/user_database_helper.dart';
import 'copoment/custom_textfield.dart';
import 'copoment/custom_buttom_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/form_validators.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dateController;
  String? _selectedGender;
  File? _avatarFile;

  final List<String> _genders = ['Nam', 'Nữ'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(widget.user.dateOfBirth),
    );
    _selectedGender = widget.user.genDer;
    if (widget.user.avatarPath != null) {
      _avatarFile = File(widget.user.avatarPath!);
    }
  }

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

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        DateTime dob = DateFormat(
          'MM/dd/yyyy',
        ).parseStrict(_dateController.text);
        widget.user.name = _nameController.text.trim();
        widget.user.phone = _phoneController.text.trim();
        widget.user.dateOfBirth = dob;
        widget.user.genDer = _selectedGender!;
        widget.user.avatarPath = _avatarFile?.path;

        await UserDatabaseHelper().updateUser(widget.user);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cập nhật thành công')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  void _deleteUser() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Xác nhận xóa'),
            content: Text('Bạn có chắc chắn muốn xóa tài khoản này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  await UserDatabaseHelper().deleteUser(widget.user.id!);
                  if (!context.mounted) return;
                  Navigator.pop(context); // Đóng dialog
                  Navigator.pushReplacementNamed(
                    context,
                    '/',
                  ); // Quay lại màn hình chính
                },
                child: Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ cá nhân'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner dùng Image.network
            Image.network(
              'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?auto=format&fit=crop&w=800&q=80',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder:
                  (context, error, stackTrace) => SizedBox(
                    height: 150,
                    child: Center(child: Icon(Icons.error)),
                  ),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Text(
              widget.user.email,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      controller: _nameController,
                      hintText: 'Họ và tên',
                      prefixIcon: Icons.person,
                      validator: FormValidators.fullName,
                    ),
                    SizedBox(height: 15),
                    CustomInputField(
                      controller: _phoneController,
                      hintText: 'Số điện thoại',
                      prefixIcon: Icons.phone,
                      validator: FormValidators.phone,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _dateController,
                      validator: FormValidators.dateOfBirth,
                      decoration: InputDecoration(
                        hintText: 'mm/dd/yyyy',
                        prefixIcon: Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGender,
                      items:
                          _genders
                              .map(
                                (g) =>
                                    DropdownMenuItem(value: g, child: Text(g)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _selectedGender = val),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Vui lòng chọn giới tính'
                                  : null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.transgender),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: _updateUser,
                        label: 'Cập nhật',
                        icon: Icons.save,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: _deleteUser,
                        label: 'Xóa tài khoản',
                        icon: Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
