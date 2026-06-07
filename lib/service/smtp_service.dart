import 'dart:developer' as developer;
import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SmtpService {
  static const String _username = '';
  static const String _password = '';
  static String? lastError;

  Future<String?> sendPasswordResetEmail(String recipientEmail) async {
    lastError = null;
    final username = _username.trim();
    final password = _password.replaceAll(' ', '');

    final smtpServer = gmail(username, password);
    final randomCode = Random().nextInt(900000) + 100000;

    final message =
        Message()
          ..from = Address(username, 'Ứng dụng UTC2')
          ..recipients.add(recipientEmail)
          ..subject = 'Yêu cầu đặt lại mật khẩu'
          ..text =
              'Xin chào,\n\n'
              'Mã xác nhận đặt lại mật khẩu của bạn là: $randomCode\n\n'
              'Vui lòng không chia sẻ mã này với bất kỳ ai.\n\n'
              'Trân trọng,\n'
              'Đội ngũ hỗ trợ';

    try {
      final sendReport = await send(message, smtpServer);
      developer.log('Message sent: $sendReport');
      return randomCode.toString();
    } catch (e, stackTrace) {
      lastError = e.toString();
      developer.log('Message not sent. Error: $e', stackTrace: stackTrace);
      return null;
    }
  }
}
