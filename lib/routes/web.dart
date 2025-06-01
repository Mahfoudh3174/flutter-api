


import 'package:demo/views/medication/card.dart';
import 'package:demo/services/auth_binding.dart';
import 'package:demo/services/pharmacy_binding.dart';

import 'package:demo/views/auth/login.dart';
import 'package:demo/views/auth/register.dart';

import 'package:demo/views/homepage.dart';
import 'package:demo/views/medication/index.dart';
import 'package:demo/views/order/index.dart';

import 'package:get/get.dart';
import 'package:demo/middleware/auth_middleware.dart';

class RouteClass{

  static String home = "/";
  static String login = "/login";
  static String register= "/register";
  static String medication = "/medication";
  static String card= "/card";
  static String orders= "/orders";
 



  static String getHomeRoute() => home;
  static String getLoginRoute() => login; 
  static String getRegisterRoute() => register;
  static String getMedictionRoute() => medication;
  static String getCardRoute() => card;
  static String getOrdersRoute() => orders;



  static List<GetPage> getPages() {
    return [
      
      GetPage(name: home, page: () => HomePage(),middlewares: [SanctumAuthMiddleware()],bindings:[AuthBinding(),PharmacyBinding()] ),
      GetPage(name: login, page: () => Login(),bindings:[AuthBinding()] ),
      GetPage(name: register, page: () => Register(),bindings:[AuthBinding()] ),
      GetPage(name: medication, page: () => MedicationListView(),middlewares: [SanctumAuthMiddleware()],bindings:[PharmacyBinding()] ),
      GetPage(name: card, page: () => CardPage(),middlewares: [SanctumAuthMiddleware()],bindings:[PharmacyBinding()] ),
      GetPage(name: orders, page: () => OrderListScreen(),middlewares: [SanctumAuthMiddleware()],bindings:[PharmacyBinding()] ),
      ];
  }
}