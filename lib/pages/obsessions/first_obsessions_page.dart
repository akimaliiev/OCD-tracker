import 'package:flutter/material.dart';
import 'package:ocr_2/pages/obsessions/second_obsessions_page.dart';
import 'package:ocr_2/pages/obsessions/third_obsessions_page.dart'; 
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/home_page.dart';

class FirstObsessionsPage extends StatefulWidget {
  @override
  _FirstObsessionsPageState createState() => _FirstObsessionsPageState();
}

class _FirstObsessionsPageState extends State<FirstObsessionsPage> {
  final List<String> _obsessions = []; 
  final TextEditingController _controller = TextEditingController();

  void _addCompulsion(String compulsion) {
    if (compulsion.isNotEmpty) {
      setState(() {
        _obsessions.add(compulsion);
      });
      _controller.clear();
    }
  }

  void _removeCompulsion(int index) {
    setState(() {
      _obsessions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage My Obsessions',
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
              'List all of your obsessions, even the scariest ones.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add a new obsession',
                labelStyle: const TextStyle(color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.brown),
                  onPressed: () => _addCompulsion(_controller.text),
                ),
              ),
              onSubmitted: (value) => _addCompulsion(value),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: _obsessions.isEmpty
                  ? Center(
                      child: const Text(
                        'No obsessions added yet. Start by adding one!',
                        style: TextStyle(color: Colors.brown, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _obsessions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              _obsessions[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.brown,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeCompulsion(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            MyButton(
              text: 'Next',
              onTap: () {
                // if (_obsessions.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondObsessionsPage(obsessions: _obsessions),
                    ),
                  );
                // }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: Text(
                  'Version 1.0.1',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
