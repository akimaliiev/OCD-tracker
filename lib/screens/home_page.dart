import 'package:flutter/material.dart';
import 'package:ocr_2/auth/auth_service.dart';

import 'package:ocr_2/screens/anxiety_diary_page.dart';
import 'package:ocr_2/screens/manage_compulsions_page.dart';
import 'package:ocr_2/screens/manage_obsessions_page.dart';

class HomePage extends StatelessWidget {
  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.account_circle,
            size: 38,
            color: Colors.brown, // Adjust color to match AppBar theme
          ),
          title: const Text(
            'OCD Tracker Home',
            style: TextStyle(color: Colors.brown),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.brown,
              onPressed: logout,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'OCD Tracker',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Find peace of mind with our app, designed to help you manage '
                  'intrusive thoughts and compulsions through proven techniques. '
                  'Improve the quality of your life with effective exercises, instructions, '
                  'and progress tracking.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _buildFeatureButton(
                      context,
                      icon: Icons.hourglass_empty,
                      label: 'Manage My Compulsions',
                      routePage: ManageCompulsionsScreen(),
                    ),
                    _buildFeatureButton(
                      context,
                      icon: Icons.psychology,
                      label: 'Manage My Obsessions',
                      routePage: ManageObsessionsScreen(),
                    ),
                    _buildFeatureButton(
                      context,
                      icon: Icons.book,
                      label: 'Anxiety Diary',
                      routePage: AnxietyDiaryScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context,
      {required IconData icon, required String label, required Widget routePage}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => routePage),
            );
          },
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.brown),
        ),
      ],
    );
  }
}
