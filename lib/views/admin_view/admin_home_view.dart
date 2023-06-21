import 'package:donite/views/admin_view/responsive/desktop_body.dart';
import 'package:donite/views/admin_view/responsive/mobile_body.dart';
import 'package:donite/views/admin_view/responsive/responsive_layout.dart';
import 'package:donite/views/admin_view/responsive/tablet_body.dart';
import 'package:flutter/material.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Colors.green),
      home: ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      ),
    );
  }
}
