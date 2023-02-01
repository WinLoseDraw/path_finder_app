import 'package:flutter/material.dart';
import 'package:path_finder_app/controllers/control_panel_controller.dart';
import 'package:path_finder_app/pages/path_finder_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ChangeNotifierProvider(
        create: (_) => ControlPanelController(),
        child: PathFinderPage(),
      ),
    );
  }
}
