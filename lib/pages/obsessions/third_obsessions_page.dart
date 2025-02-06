import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting
import 'package:ocr_2/components/my_button.dart';

class ThirdObsessionsPage extends StatefulWidget {
  final List<String> obsessions; // List of compulsions passed from the previous screen

  ThirdObsessionsPage({required this.obsessions});

  @override
  _ThirdObsessionsPageState createState() => _ThirdObsessionsPageState();
}

class _ThirdObsessionsPageState extends State<ThirdObsessionsPage> {
  String? _selectedCompulsion;
  List<Map<String, TextEditingController>> _planningControllers = []; // Use controllers for inputs

  @override
  void initState() {
    super.initState();
    // Initialize 4 rows of data with today's date
    _planningControllers = List.generate(
      4,
      (index) => {
        'action': TextEditingController(),
        'date': TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now())), // Today's date
        'comments': TextEditingController(),
      },
    );
  }

  @override
  void dispose() {
    // Dispose of all controllers
    for (var controllers in _planningControllers) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  void _addMoreRows() {
    setState(() {
      _planningControllers.add({
        'action': TextEditingController(),
        'date': TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now())), // Today's date
        'comments': TextEditingController(),
      });
    });
  }

  void _saveData() {
    if (_selectedCompulsion != null) {
      List<Map<String, String>> planningData = _planningControllers.map((controllers) {
        return {
          'action': controllers['action']!.text,
          'date': controllers['date']!.text,
          'comments': controllers['comments']!.text,
        };
      }).toList();

      print('Selected compulsion: $_selectedCompulsion');
      print('Planning data: $planningData');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a compulsion first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan Your Actions',
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
              'Select an obsession:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCompulsion,
              hint: const Text('Choose a compulsion'),
              isExpanded: true,
              items: widget.obsessions.map((String compulsion) {
                return DropdownMenuItem<String>(
                  value: compulsion,
                  child: Text(compulsion),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCompulsion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Plan your actions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _planningControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _planningControllers[index]['action'],
                            decoration: const InputDecoration(
                              labelText: 'Action / Situation',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _planningControllers[index]['date'],
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _planningControllers[index]['date']!.text =
                                      DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _planningControllers[index]['comments'],
                            decoration: const InputDecoration(
                              labelText: 'Comments',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _addMoreRows,
                  icon: const Icon(Icons.add),
                  label: const Text('Add more'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MyButton(
              text: 'Save',
              onTap: _saveData,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: Text(
                  '',
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
}
