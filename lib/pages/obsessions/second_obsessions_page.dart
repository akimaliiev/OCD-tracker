import 'package:flutter/material.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/obsessions/third_obsessions_page.dart';

class SecondObsessionsPage extends StatelessWidget {
  final List<String> obsessions; 
  SecondObsessionsPage({required this.obsessions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Face Your Fears',
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ The only way to overcome your fears is to face them.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Allow the fear or thought to be present, without pushing it away or seeking an answer. Notice it, even if it feels uncomfortable.\n\n"
              "Tell yourself:\n"
              '"It might be true, it might not be — I don\'t need to know right now."\n\n'
              "When the urge to fix or control arises, pause. Choose to sit with the uncertainty instead of reacting.\n\n"
              "This is about showing yourself that you can handle not knowing. Every time you face the discomfort without acting on it, you're growing stronger.\n\n"
              "Next, you will plan your activities on exposing yourself to intrusive thoughts. 🧠",
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            const Spacer(),
            Center(
              child: MyButton(
              text: "Let's do it!", // Button text
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThirdObsessionsPage(obsessions: obsessions), // Pass the required compulsions list
                  ),
                );
              },),
            ),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
