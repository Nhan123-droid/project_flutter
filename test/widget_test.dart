import 'package:final_exam_flutter/main.dart';
import 'package:final_exam_flutter/copoment/custom_buttom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login screen shows authentication form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(
      find.widgetWithText(CustomElevatedButton, 'Đăng nhập'),
      findsOneWidget,
    );
    expect(find.text('Quên mật khẩu?'), findsOneWidget);
    expect(find.text('Đăng ký ngay'), findsOneWidget);
  });
}
