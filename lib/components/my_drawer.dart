import 'package:flutter/material.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:ocr_2/pages/contact_us_page.dart';
import 'package:ocr_2/pages/home_page.dart';
import 'package:ocr_2/pages/privacy_policy_page.dart';
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

  void deleteAccount(BuildContext context) async {
    final auth = AuthService();

    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // If the user confirms, delete the account
    if (confirmDelete == true) {
      try {
        await auth.deleteAccount();
        Navigator.pop(context); // Close the drawer
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    }
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
                    'assets/images/ocd.png',
                    color: Colors.brown,
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
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionsPage()));
                },
              ),
              _buildListTile(
                context,
                title: "Privacy Policy",
                icon: Icons.privacy_tip,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage()));
                },
              ),
              _buildListTile(
                context,
                title: "Terms and Conditions",
                icon: Icons.description,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsAndConditionsPage()));
                },
              ),
              _buildListTile(
                context,
                title: "Contact Us",
                icon: Icons.mail_outline,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsPage()));
                },
              ),
              // Add the "Delete Account" button under "Contact Us"
              _buildListTile(
                context,
                title: "Delete Account",
                icon: Icons.delete_forever,
                onTap: () => deleteAccount(context),
                color: const Color.fromARGB(255, 150, 33, 25), // Use red color for delete action
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
      required VoidCallback onTap,
      Color color = Colors.brown}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Icon(
          icon,
          color: color,
        ),
        onTap: onTap,
      ),
    );
  }
}