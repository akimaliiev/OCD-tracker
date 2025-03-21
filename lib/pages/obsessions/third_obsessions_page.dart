import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/home_page.dart';
import 'saved_obsessions_page.dart';

class ThirdObsessionsPage extends StatefulWidget {
  final List<String> obsessions;
  final String? recordId;
  final Map<String, dynamic>? preFilledData;

  ThirdObsessionsPage({required this.obsessions, this.recordId, this.preFilledData});

  @override
  _ThirdObsessionsPageState createState() => _ThirdObsessionsPageState();
}

class _ThirdObsessionsPageState extends State<ThirdObsessionsPage> {
  String? _selectedCompulsion;
  List<Map<String, TextEditingController>> _planningControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.preFilledData != null) {
      _selectedCompulsion = widget.preFilledData!['compulsion'];
      _planningControllers = (widget.preFilledData!['planningData'] as List).map((plan) {
        return {
          'action': TextEditingController(text: plan['action']),
          'date': TextEditingController(text: plan['date']),
          'comments': TextEditingController(text: plan['comments']),
        };
      }).toList();
    } else {
      _planningControllers = List.generate(
        4,
        (index) => {
          'action': TextEditingController(),
          'date': TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())),
          'comments': TextEditingController(),
        },
      );
    }
  }

  @override
  void dispose() {
    for (var controllers in _planningControllers) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  void _addMoreRows() {
    setState(() {
      _planningControllers.add({
        'action': TextEditingController(),
        'date': TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())),
        'comments': TextEditingController(),
      });
    });
  }

  Future<void> _saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save data.')),
      );
      return;
    }

    final userId = user.uid;

    if (_selectedCompulsion != null) {
      List<Map<String, String>> planningData = _planningControllers
          .where((controllers) => controllers['action']!.text.isNotEmpty)
          .map((controllers) {
        return {
          'action': controllers['action']!.text,
          'date': controllers['date']!.text,
          'comments': controllers['comments']!.text,
        };
      }).toList();

      if (planningData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one valid action.')),
        );
        return;
      }

      try {
        if (widget.recordId != null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('obsessions')
              .doc(widget.recordId)
              .update({
            'compulsion': _selectedCompulsion,
            'planningData': planningData,
            'timestamp': FieldValue.serverTimestamp(),
          });
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('obsessions')
              .add({
            'compulsion': _selectedCompulsion,
            'planningData': planningData,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.brown),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedObsessionsPage(),
                ),
              );
            },
          ),
        ],
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
            _buildAdvancedDropdown(
              context,
              value: _selectedCompulsion,
              hint: 'Choose an obsession',
              items: widget.obsessions,
              onSelected: (value) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedDropdown(
    BuildContext context, {
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 16, color: Colors.brown),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.brown, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hint,
              style: const TextStyle(fontSize: 16, color: Colors.brown),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.brown),
          ],
        ),
      ),
    );
  }
}