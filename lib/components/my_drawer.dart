import 'package:flutter/material.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:ocr_2/pages/contact_us_page.dart';
import 'package:ocr_2/pages/home_page.dart';
import 'package:ocr_2/pages/subscriptions_page.dart';
import 'package:ocr_2/pages/terms_and_conditions.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();
    Navigator.pop(context); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    '/Users/akimaliev/VSProjects/mio_1/lib/images/potato.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              _buildListTile(
                context,
                title: "Home",
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                  
                },
              ),
              _buildListTile(
                context,
                title: "Manage My Subscriptions",
                icon: Icons.subscriptions,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SubscriptionsPage()));
                },
              ),
              _buildListTile(
                context,
                title: "Privacy Policy",
                icon: Icons.privacy_tip,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              _buildListTile(
                context,
                title: "Terms and Conditions",
                icon: Icons.description,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage()));},
                
              ),
              _buildListTile(
                context,
                title: "Contact Us",
                icon: Icons.mail_outline,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ContactUsPage()));                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: _buildListTile(
              context,
              title: "Log Out",
              icon: Icons.logout,
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Icon(
          icon,
          color: Colors.brown,
        ),
        onTap: onTap,
      ),
    );
  }
}
