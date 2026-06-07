import 'package:intl/intl.dart';

class FormValidators {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _phonePattern = RegExp(r'^(0[35789])[0-9]{8}$');
  static final RegExp _namePattern = RegExp(r"^[\p{L}\s'.-]+$", unicode: true);

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email không được để trống';
    if (!_emailPattern.hasMatch(text)) return 'Email không hợp lệ';
    return null;
  }

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Họ và tên không được để trống';
    if (text.length < 2) return 'Họ và tên phải có ít nhất 2 ký tự';
    if (!_namePattern.hasMatch(text)) return 'Họ và tên không hợp lệ';
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Số điện thoại không được để trống';
    if (!_phonePattern.hasMatch(text)) return 'Số điện thoại không hợp lệ';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Mật khẩu không được để trống';
    if (text.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final text = value ?? '';
    if (text.isEmpty) return 'Mật khẩu xác nhận không được để trống';
    if (text.length < 6) return 'Mật khẩu xác nhận phải có ít nhất 6 ký tự';
    if (text != password) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  static String? dateOfBirth(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ngày sinh không được để trống';
    try {
      DateFormat('MM/dd/yyyy').parseStrict(text);
      return null;
    } catch (_) {
      return 'Ngày sinh không hợp lệ (mm/dd/yyyy)';
    }
  }

  static String? otp(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập mã OTP';
    if (!RegExp(r'^\d{6}$').hasMatch(text)) return 'Mã OTP phải gồm 6 số';
    return null;
  }
}
