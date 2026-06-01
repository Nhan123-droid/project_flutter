import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

class SmtpService {
  // TODO: Thay đổi email và mật khẩu ứng dụng thật của bạn ở đây
  // Lưu ý: Đối với Gmail, bạn cần tạo "Mật khẩu ứng dụng" (App Password)
  final String username = 'dummytester9999@gmail.com'; 
  final String password = 'dummy_app_password';

  Future<String?> sendPasswordResetEmail(String recipientEmail) async {
    final smtpServer = gmail(username, password);
    
    // Tạo mã xác nhận ngẫu nhiên (chỉ để demo)
    final randomCode = Random().nextInt(900000) + 100000; 

    final message = Message()
      ..from = Address(username, 'Ứng dụng UTC2')
      ..recipients.add(recipientEmail)
      ..subject = 'Yêu cầu đặt lại mật khẩu'
      ..text = 'Xin chào,\n\nMã xác nhận đặt lại mật khẩu của bạn là: $randomCode\n\nVui lòng không chia sẻ mã này với bất kỳ ai.\n\nTrân trọng,\nĐội ngũ hỗ trợ';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return randomCode.toString();
    } catch (e) {
      print('Message not sent. Error: $e');
      return null;
    }
  }
}
