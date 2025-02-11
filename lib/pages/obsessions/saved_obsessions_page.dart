import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedObsessionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get the current authenticated user
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Records', style: TextStyle(color: Colors.brown)),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: const Center(
          child: Text('Please sign in to view your records.'),
        ),
      );
    }

    final userId = user.uid; // Get the user's UID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Records', style: TextStyle(color: Colors.brown)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('obsessions')
            .orderBy('timestamp', descending: true) // Sort by timestamp (newest first)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No records found.'));
          }

          final records = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final data = record.data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    data['compulsion'] ?? 'Unnamed Compulsion',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.brown,
                    ),
                  ),
                  subtitle: Text(
                    'Actions: ${(data['planningData'] as List).length}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Delete the record
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userId)
                          .collection('obsessions')
                          .doc(record.id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Record deleted successfully!')),
                      );
                    },
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Action Plan:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.brown,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...(data['planningData'] as List).map((plan) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📌 Action: ${plan['action']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '📅 Date: ${plan['date']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '💬 Comments: ${plan['comments']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const Divider(height: 20),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}