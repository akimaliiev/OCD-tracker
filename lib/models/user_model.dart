import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final DateTime trialStartDate;
  final bool isSubscribed;

  UserModel({
    required this.uid,
    required this.email,
    required this.trialStartDate,
    required this.isSubscribed,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      trialStartDate: (data['trialStartDate'] as Timestamp).toDate(),
      isSubscribed: data['isSubscribed'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'trialStartDate': trialStartDate.toIso8601String(),
      'isSubscribed': isSubscribed,
    };
  }
}
