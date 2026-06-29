import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/pin_service.dart';
import 'app/services/child_progress_service.dart';

import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthService());
  await Get.putAsync(() => PinService().init());
  Get.put(ChildProgressService(), permanent: true);
  Get.put(HomeController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "LingoLeap",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
