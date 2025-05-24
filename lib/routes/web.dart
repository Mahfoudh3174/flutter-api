


import 'package:demo/services/auth_binding.dart';
import 'package:demo/services/pharmacy_binding.dart';

import 'package:demo/views/auth/login.dart';
import 'package:demo/views/auth/register.dart';

import 'package:demo/views/homepage.dart';

import 'package:get/get.dart';
import 'package:demo/middleware/auth_middleware.dart';

class RouteClass{

  static String home = "/";
  static String login = "/login";
  static String register= "/register";
 



  static String getHomeRoute() => home;
  static String getLoginRoute() => login; 
  static String getRegisterRoute() => register;



  static List<GetPage> getPages() {
    return [
      
      GetPage(name: home, page: () => HomePage(),middlewares: [SanctumAuthMiddleware()],bindings:[AuthBinding(),PharmacyBinding()] ),
      GetPage(name: login, page: () => Login(),middlewares: [SanctumAuthMiddleware()],bindings:[AuthBinding()] ),
      GetPage(name: register, page: () => Register(),bindings:[AuthBinding()] ),
      ];
  }
}