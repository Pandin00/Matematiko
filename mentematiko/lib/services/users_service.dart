import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
}
