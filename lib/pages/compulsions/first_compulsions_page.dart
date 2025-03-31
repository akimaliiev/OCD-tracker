import 'package:flutter/material.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/compulsions/timer_page.dart';
import 'package:ocr_2/pages/home_page.dart';
import 'package:ocr_2/pages/compulsions/second_compulsions_page.dart';

class FirstCompulsionsPage extends StatelessWidget {
  final List<String> compulsions;
  FirstCompulsionsPage({super.key, required this.compulsions});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delay Your Compulsions',
          style: TextStyle(color: Colors.brown),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💡 A Little Trick to Manage Your Compulsions: Just Delay Them!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Here's a simple yet powerful tool to help you break free from the cycle of compulsions: the art of delay. "
              "Instead of giving in to a compulsion immediately, try this—tell yourself, “I’ll do it, but not just yet.” "
              "Set a timer for 30 minutes, and during that time, shift your focus to something else—take a few deep breaths, "
              "listen to your favorite song, or engage in a calming activity.\n\n"
              "Why does this work? Because delaying creates space between the urge and the action, giving your brain a chance to realize you don't have to act on the compulsion.\n\n"
              "Sometimes, when the timer ends, the compulsion feels less intense—or maybe even unnecessary. You've just taken a step toward rewiring your response to OCD. 🎉 Try it out—your future self will thank you!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            const Spacer(),
            Center(
              // child: ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.white, backgroundColor: Colors.brown, // Text color
              //     minimumSize: const Size(200, 50), // Button size
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              //   onPressed: () {
              //     // Navigate to the next page
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SecondCompulsionsPage(), // Replace with your next page widget
              //       ),
              //     );
              //   },
                child: MyButton(text: "Let's try!", onTap: (){
              
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(),
                  ),
                );
            }),
            ),
            const SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
