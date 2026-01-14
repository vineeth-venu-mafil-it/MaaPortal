import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'features/login/controller/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
      ],
      child: MyApp(),
    ),
  );
}
