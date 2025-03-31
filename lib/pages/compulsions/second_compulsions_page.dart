import 'package:flutter/material.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/compulsions/first_compulsions_page.dart';
import 'package:ocr_2/pages/compulsions/timer_page.dart';
import 'package:ocr_2/pages/home_page.dart';

class SecondCompulsionsPage extends StatefulWidget {
  @override
  _SecondCompulsionsPageState createState() => _SecondCompulsionsPageState();
}

class _SecondCompulsionsPageState extends State<SecondCompulsionsPage> {
  final List<String> _compulsions = []; // List to store compulsions
  final TextEditingController _controller = TextEditingController();

  void _addCompulsion(String compulsion) async {
  if (compulsion.isNotEmpty) {
    setState(() {
      _compulsions.add(compulsion);
    });
    _controller.clear();
    await AuthService().saveCompulsion(compulsion); // Save to Firestore
  }
}


  void _removeCompulsion(int index) {
    setState(() {
      _compulsions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage My Compulsions',
          style: TextStyle(color: Colors.brown),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
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
              'Add your compulsions from the easiest to resist to the hardest to resist.',
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
                labelText: 'Add a new compulsion',
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
              child: _compulsions.isEmpty
                  ? Center(
                      child: const Text(
                        'No compulsions added yet. Start by adding one!',
                        style: TextStyle(color: Colors.brown, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _compulsions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              _compulsions[index],
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
            MyButton(text: 'Next', onTap: (){
              // if (_compulsions.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirstCompulsionsPage(compulsions:_compulsions,),
                  ),
                );
              //}
            }),
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
