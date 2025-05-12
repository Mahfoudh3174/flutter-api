
import 'package:demo/controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:demo/routes/web.dart';
import 'package:get/get.dart';
import 'package:demo/services/stored_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and register the StorageService
  await Get.putAsync(() => StorageService().init());
   Get.put(Clientscontroller());
  
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
   MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo Getx',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: RouteClass.getHomeRoute(),
      getPages: 
        RouteClass.getPages(),
    );
  }
}
