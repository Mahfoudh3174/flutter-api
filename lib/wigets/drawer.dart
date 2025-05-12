import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final String userName;
  
  final String userEmail;
  final VoidCallback onLogoutPressed;

  const MainDrawer({
    super.key,
    required this.userName,
    
    required this.userEmail,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // User Accounts Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                // Replace with your image using:
                // child: Image.network('your_image_url', fit: BoxFit.cover)
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: const DecorationImage(
                image: AssetImage('images/bg.jpg'), // Optional
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to home
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Feedback'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),

          // Logout Button at bottom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onLogoutPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}