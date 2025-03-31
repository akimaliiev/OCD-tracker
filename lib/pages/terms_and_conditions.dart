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
              'Effective Date: March 11, 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Section 1: Acceptance of Terms
            _buildSectionTitle('1. Acceptance of Terms'),
            const SizedBox(height: 10),
            const Text(
              '1.1 By accessing or using the App, you agree to be bound by these Terms and our Privacy Policy.\n'
              '1.2 If you do not agree with these Terms, you must not use the App.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 2: Eligibility
            _buildSectionTitle('2. Eligibility'),
            const SizedBox(height: 10),
            const Text(
              '2.1 You must be at least 18 years old to use the App.\n'
              '2.2 By using the App, you represent that you meet the eligibility requirements.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 3: Use of the App
            _buildSectionTitle('3. Use of the App'),
            const SizedBox(height: 10),
            const Text(
              '3.1 You agree to use the App only for its intended purposes and in compliance with all applicable laws and regulations.\n'
              '3.2 You agree not to:\n'
              '- Reverse engineer, decompile, or disassemble the App.\n'
              '- Use the App to distribute malicious software or content.\n'
              '- Use automated systems (e.g., bots) to access or interact with the App.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 4: User Account
            _buildSectionTitle('4. User Account'),
            const SizedBox(height: 10),
            const Text(
              '4.1 You need to create an account to access features of the App.\n'
              '4.2 You are responsible for maintaining the confidentiality of your account credentials.\n'
              '4.3 You agree to notify us immediately of any unauthorized use of your account.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 5: Intellectual Property
            _buildSectionTitle('5. Intellectual Property'),
            const SizedBox(height: 10),
            const Text(
              '5.1 All content, features, and functionality of the App, including but not limited to text, graphics, logos, and software, are owned by OCD Tracker App or its licensors.\n'
              '5.2 You may not use any of the App’s intellectual property without prior written consent.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 6: Fees and Payments
            _buildSectionTitle('6. Fees and Payments'),
            const SizedBox(height: 10),
            const Text(
              '6.1 The App offers paid subscriptions once the free trial is over. Fees and billing details will be disclosed prior to purchase.\n'
              '6.2 All payments are final, except as required by applicable law or expressly stated.\n'
              '6.3 You can request a refund by contacting us in the Contact Us section of the App.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 7: Limitation of Liability
            _buildSectionTitle('7. Limitation of Liability'),
            const SizedBox(height: 10),
            const Text(
              '7.1 To the fullest extent permitted by law, OCD Tracker App is not liable for:\n'
              '- Any indirect, incidental, or consequential damages arising from your use of the App.\n'
              '- Loss of data or interruption of services.\n'
              '7.2 The App is provided on an "as is" and "as available" basis without warranties of any kind.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 8: Termination
            _buildSectionTitle('8. Termination'),
            const SizedBox(height: 10),
            const Text(
              '8.1 We reserve the right to suspend or terminate your access to the App at any time for any reason, including violation of these Terms.\n'
              '8.2 Upon termination, all rights granted to you under these Terms will cease immediately.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 9: Changes to the Terms
            _buildSectionTitle('9. Changes to the Terms'),
            const SizedBox(height: 10),
            const Text(
              '9.1 We may update these Terms from time to time.\n'
              '9.2 Continued use of the App after updates constitutes your acceptance of the revised Terms.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 10: Governing Law
            _buildSectionTitle('10. Governing Law'),
            const SizedBox(height: 10),
            const Text(
              '10.1 These Terms are governed by the laws of the Republic of Kazakhstan, without regard to its conflict of law principles.\n'
              '10.2 Any disputes arising under these Terms will be resolved exclusively in the courts of the city of Astana, Kazakhstan.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 11: Medical Disclaimer
            _buildSectionTitle('11. Medical Disclaimer'),
            const SizedBox(height: 10),
            const Text(
              '11.1 The approaches used in the App have not been clinically validated or endorsed. The App is not designed to diagnose, treat, or cure any mental health conditions. Any decisions or actions based on the information provided in this App are solely at your own risk. This App is not a substitute for professional mental health advice, diagnosis, or treatment. Always consult a qualified mental health professional with any questions regarding a mental health condition, and we strongly recommend using the App under professional supervision.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 12: Contact Information
            _buildSectionTitle('12. Contact Information'),
            const SizedBox(height: 10),
            const Text(
              '12.1 If you have any questions or concerns about these Terms, please contact us at:\n'
              'ahashn@gmail.com',
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

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.brown,
      ),
    );
  }
}
