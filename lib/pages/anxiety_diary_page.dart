import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/home_page.dart';

class AnxietyDiaryPage extends StatefulWidget {
  @override
  _AnxietyDiaryPageState createState() => _AnxietyDiaryPageState();
}

class _AnxietyDiaryPageState extends State<AnxietyDiaryPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _diaryController = TextEditingController();

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveEntry() async {
    String diaryEntry = _diaryController.text.trim();

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save your entry.')),
      );
      return;
    }

    if (diaryEntry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before saving!')),
      );
      return;
    }

    Map<String, dynamic> diaryData = {
      'date': _selectedDate.toIso8601String(),
      'entry': diaryEntry,
      'timestamp': FieldValue.serverTimestamp(), 
    };

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('diary_entries')
          .add(diaryData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your entry has been saved!')),
      );

      _diaryController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save entry: $error')),
      );
    }
  }

  void _viewHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DiaryHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Anxiety Diary',
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.brown),
            onPressed: _viewHistory, 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Writing about your worries in a journal can feel like unburdening your mind. As the thoughts flow onto the page, it’s as if the weight they carried begins to lift, leaving you with a sense of clarity and calm.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose the Day:',
              style: TextStyle(fontSize: 18, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat.yMMMMd().format(_selectedDate),
                  style: const TextStyle(fontSize: 16, color: Colors.brown),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
  child: TextField(
    controller: _diaryController,
    maxLines: null,
    expands: true,
    textAlignVertical: TextAlignVertical.top, 
    decoration: InputDecoration(
      hintText: 'Write your thoughts here...',
      hintStyle: const TextStyle(color: Colors.brown),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.brown),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.brown), 
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.brown), 
      ),
    ),
    style: const TextStyle(fontSize: 16, color: Colors.brown),
  ),
),

            const SizedBox(height: 20),
            Center(
              child: MyButton(
                text: 'Save',
                onTap: _saveEntry,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
class DiaryHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Diary History'),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: const Center(
          child: Text(
            'You must be logged in to view your diary history.',
            style: TextStyle(fontSize: 16, color: Colors.brown),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diary History',
          style: TextStyle(color: Colors.brown),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AnxietyDiaryPage()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .collection('diary_entries')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final diaryEntries = snapshot.data!.docs;

          if (diaryEntries.isEmpty) {
            return const Center(
              child: Text(
                'No entries found.',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            );
          }

          return ListView.builder(
            itemCount: diaryEntries.length,
            itemBuilder: (context, index) {
              var entry = diaryEntries[index];

              var dateText = entry['date']; 
              var entryText = entry['entry'];
              DateTime parsedDate;

              try {
                parsedDate = DateTime.parse(dateText);
              } catch (e) {
                parsedDate = DateTime.now(); 
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      entryText, 
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Written on: ${DateFormat.yMMMMd().format(parsedDate)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDelete(context, currentUser.uid, entry.id);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String userId, String entryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .collection('diary_entries')
                      .doc(entryId)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entry deleted successfully.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete entry: $e')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
