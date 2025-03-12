import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last updated: March 11, 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Section 1: Introduction
            _buildSectionTitle('1. Introduction'),
            const SizedBox(height: 10),
            const Text(
              'OCD Tracker App ("we," "our," "us") respects your privacy and is committed to protecting your personal information. This Privacy Policy describes how we collect, use, and disclose information when you use our mobile application (the "App"). By using the App, you agree to the terms of this Privacy Policy.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 2: Information We Collect
            _buildSectionTitle('2. Information We Collect'),
            const SizedBox(height: 10),
            _buildSubSectionTitle('2.1 Information You Provide'),
            const Text(
              '- Account Information: When you sign up, we may collect your name, email address, username, and password.\n'
              '- User Content: Any information you input, such as text entries or other data you choose to share.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            _buildSubSectionTitle('2.2 Automatically Collected Information'),
            const Text(
              '- Device Information: Information about your mobile device, including model, operating system, and unique device identifiers.\n'
              '- Usage Data: Information about how you interact with the App, such as features used, and time spent.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            _buildSubSectionTitle('2.3 Third-Party Services'),
            const Text(
              'We may collect information from third-party services if you choose to integrate them with our App, such as analytics tools or authentication providers.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 3: How We Use Your Information
            _buildSectionTitle('3. How We Use Your Information'),
            const SizedBox(height: 10),
            const Text(
              'We use the information we collect to:\n'
              '- Provide, improve, and personalize the App.\n'
              '- Communicate with you about updates, promotions, and support.\n'
              '- Monitor and analyze usage trends and improve user experience.\n'
              '- Ensure compliance with legal obligations.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 4: Sharing Your Information
            _buildSectionTitle('4. Sharing Your Information'),
            const SizedBox(height: 10),
            const Text(
              'We may share your information:\n'
              '- With Service Providers: To facilitate App operations, such as hosting and analytics.\n'
              '- For Legal Reasons: If required to comply with legal obligations or protect our rights.\n'
              '- With Your Consent: When you explicitly agree to share your information.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 5: Data Retention
            _buildSectionTitle('5. Data Retention'),
            const SizedBox(height: 10),
            const Text(
              'We retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, or as required by law. You may request the deletion of your data at any time.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 6: Security
            _buildSectionTitle('6. Security'),
            const SizedBox(height: 10),
            const Text(
              'We take reasonable measures to protect your information from unauthorized access, loss, or misuse. However, no system can guarantee absolute security.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 7: Your Choices
            _buildSectionTitle('7. Your Choices'),
            const SizedBox(height: 10),
            const Text(
              '- Access and Update: You can access and update your personal information in the App’s settings.\n'
              '- Opt-Out: You can opt out of certain data collection practices, such as marketing communications.\n'
              '- Delete Account: Contact us to delete your account and associated data.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 8: GDPR Compliance
            _buildSectionTitle('8. GDPR Compliance'),
            const SizedBox(height: 10),
            const Text(
              'While we are committed to adhering to the European General Data Protection Regulation (GDPR), we currently cannot fully guarantee compliance due to our limited operational capacity. We plan to achieve full compliance in the future. Additionally, in accordance with GDPR definitions, we also collect "data concerning health" — that is, any personal information concerning the physical or mental health of a natural person, including details provided through health care services that reveal information about their health status.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 9: Children’s Privacy
            _buildSectionTitle('9. Children’s Privacy'),
            const SizedBox(height: 10),
            const Text(
              'The App is not intended for children under the age of 18, and we do not knowingly collect personal information from children.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 10: Changes to This Privacy Policy
            _buildSectionTitle('10. Changes to This Privacy Policy'),
            const SizedBox(height: 10),
            const Text(
              'We may update this Privacy Policy from time to time. Any changes will be posted in the App, and your continued use of the App constitutes acceptance of the updated terms.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Section 11: Contact Us
            _buildSectionTitle('11. Contact Us'),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions or concerns about this Privacy Policy, please reach out to us at ahashn@gmail.com.',
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

  // Helper method to build subsection titles
  Widget _buildSubSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.brown,
      ),
    );
  }
}