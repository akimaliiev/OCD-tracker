import 'package:flutter/material.dart';
import 'package:ocr_2/themes/dark_mode.dart';
import 'package:provider/provider.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:ocr_2/components/my_drawer.dart';
import 'package:ocr_2/pages/anxiety_diary_page.dart';
import 'package:ocr_2/pages/compulsions/first_compulsions_page.dart';
import 'package:ocr_2/pages/obsessions/first_obsessions_page.dart';
import 'package:ocr_2/themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    final auth = AuthService();
    auth.signOut();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeData;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: const Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.brown,
              ),
            ),
          ),
          title: const Text(
            'OCD Tracker',
            style: TextStyle(color: Colors.brown),
          ),
        ),
        drawer: const MyDrawer(),
        backgroundColor: theme.colorScheme.surface,
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
                _buildFeatureButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButtons(BuildContext context) {
    return Column(
      children: [
        _buildAnimatedFeatureButton(
          context,
          icon: Icons.hourglass_empty,
          label: 'Manage My Compulsions',
          routePage: FirstCompulsionsPage(),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedFeatureButton(
              context,
              icon: Icons.psychology,
              label: 'Manage My Obsessions',
              routePage: FirstObsessionsPage(),
            ),
            const SizedBox(width: 20),
            _buildAnimatedFeatureButton(
              context,
              icon: Icons.book,
              label: 'Anxiety Diary',
              routePage: AnxietyDiaryPage(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedFeatureButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget routePage,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        _animateButton(context);
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => routePage),
          );
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(_buttonScale),
            child: Icon(
              icon,
              size: 40,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.brown),
          ),
        ],
      ),
    );
  }

  double _buttonScale = 1.0;

  void _animateButton(BuildContext context) {
    setState(() {
      _buttonScale = 0.9; // Scale down the button
    });

    // Reset the scale after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _buttonScale = 1.0; // Scale back to normal
      });
    });
  }
}