import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/wigets/drawer.dart';

class Homepage extends StatelessWidget {
  final Clientscontroller clientscontroller = Get.put(Clientscontroller());
  final Authcontroller authCtrl = Get.put(Authcontroller());

  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        userName: authCtrl.user_name.value,

        userEmail: authCtrl.user_email.value,
        onLogoutPressed: () {
          // Handle logout action
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
        title: Text("GetX API Demo"),
      ),
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: () => clientscontroller.fetchClients(),
          icon: Icon(Icons.refresh),
          label: Text('Refresh'),
        ),
      ],
      body: Obx(() {
        if (clientscontroller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: clientscontroller.clients.length,
            itemBuilder: (context, index) {
              final client = clientscontroller.clients[index];
              return ListTile(
                title: Text(client.name),
                subtitle: Text(client.phone),
                leading: CircleAvatar(child: Text(client.id)),
                trailing: IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'delete Client ',
                      content: Text('delete ${client.name} ?'),
                      confirm: TextButton(
                        onPressed: () {
                          clientscontroller.deleteClient(id: client.id);
                          Get.back();
                        },
                        child: Text('yes'),
                      ),
                      cancel: TextButton(
                        onPressed: () => Get.back(),
                        child: Text('no'),
                      ),
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('create-client'), // Refresh data
        child: Icon(Icons.add),
      ),
    );
  }
}
