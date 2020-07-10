import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/views/LoginView.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    LoginView loginView = LoginView();

    final _providerKey = GlobalKey();

    BuildContext context;

    await tester.pumpWidget(ChangeNotifierProvider(
      key: _providerKey
    ));
  });
}