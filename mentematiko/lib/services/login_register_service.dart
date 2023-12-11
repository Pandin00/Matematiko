import 'package:card/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class LoginService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _log = Logger('LoginService');

  Future<User> login(String username, String password) async {
    QuerySnapshot<User> querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: username)
        .where('password', isEqualTo: password) //unsafe
        .withConverter(
            fromFirestore: (snapshot, _) =>
                User.fromFirestore(snapshot.data()!),
            toFirestore: (user, _) => {})
        .get();
    if (querySnapshot.size > 0) {
      _log.info("user logged");
    }
    return querySnapshot.docs.first.data();
  }
}
