import 'package:flutter/material.dart';
import 'package:hc_4/initial_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hc_4/data/operation.dart';
import 'package:hc_4/timer_view/time_provider/time_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OperationAdapter());

  await Hive.openBox<Operation>('operations');
  runApp(ChangeNotifierProvider(
    child: MainApp(),
    create: (context) => TimerProvider(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SFProText',
      ),
      debugShowCheckedModeBanner: false,
      home: InitialPage(),
    );
  }
}
