
import 'package:demo/views/auth/login.dart';
import 'package:demo/views/clients/create.dart';
import 'package:demo/views/homepage.dart';
import 'package:demo/views/notifications/index.dart';
import 'package:get/get.dart';
import 'package:demo/middleware/auth_middleware.dart';

class RouteClass{
  static const String home = '/';
  static const String login = '/login';
  static const String clients = '/clients';
  static const String createClient = '/create-client';
  static const String notifications = '/notifications';

  static String getHomeRoute() => home;
  static String getLoginRoute() => login; 
  static String getClientsRoute() => clients;
  static String getNotificationsRoute() => notifications;
  static String getCreateClientRoute() => createClient;

  static List<GetPage> getPages() {
    return [
      GetPage(name: home, page: () => HomePage(),middlewares: [SanctumAuthMiddleware()]),
      GetPage(name: login, page: () => Login(),middlewares: [SanctumAuthMiddleware()]),
      GetPage(name: createClient, page: () => CreateClient(),middlewares: [SanctumAuthMiddleware()]),
      GetPage(name: notifications, page: () => NotificationPage(),middlewares: [SanctumAuthMiddleware()]),
    ];
  }
}