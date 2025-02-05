import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last updated: January 1, 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Section 1: Introduction
            const Text(
              '1. Introduction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to our app. By using this application, you agree to these Terms and Conditions. Please read them carefully before using the app.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 2: User Responsibilities
            const Text(
              '2. User Responsibilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'As a user, you are responsible for ensuring that your use of the app complies with all applicable laws and regulations. You must not misuse the app in any way, including but not limited to engaging in fraudulent activities, spreading malware, or violating the rights of others.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 3: Account Registration
            const Text(
              '3. Account Registration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'When registering for an account, you agree to provide accurate, current, and complete information. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 4: Privacy Policy
            const Text(
              '4. Privacy Policy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We are committed to protecting your privacy. Please refer to our Privacy Policy to learn more about how we collect, use, and safeguard your personal information.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 5: Limitation of Liability
            const Text(
              '5. Limitation of Liability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'To the fullest extent permitted by law, we will not be liable for any direct, indirect, incidental, special, or consequential damages resulting from your use of the app or your inability to use the app.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 6: Modifications to Terms
            const Text(
              '6. Modifications to Terms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We reserve the right to modify these Terms and Conditions at any time. We will notify users of any significant changes through the app or via email. Continued use of the app after such changes will constitute your acceptance of the new terms.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 7: Termination
            const Text(
              '7. Termination',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We may terminate or suspend your access to the app at our sole discretion, without prior notice, if we believe you have violated these Terms and Conditions.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 8: Governing Law
            const Text(
              '8. Governing Law',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'These Terms and Conditions are governed by and construed in accordance with the laws of [Your Country/State], without regard to its conflict of law principles.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 9: Contact Information
            const Text(
              '9. Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions or concerns about these Terms and Conditions, please contact us at support@example.com.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 30),

            // Accept Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'ACCEPT',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
