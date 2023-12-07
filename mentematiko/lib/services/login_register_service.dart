import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class LoginService {
   
   final FirebaseFirestore firestore = FirebaseFirestore.instance;
   static final _log = Logger('LoginService');

  Future<User> login(String username,String password) async{
    
     QuerySnapshot<User> querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: username)
          .where('password', isEqualTo: password) //unsafe
          .withConverter(
            fromFirestore: (snapshot, _) => User.fromFirestore(snapshot.data()!),
            toFirestore: (user, _) => {})
          .get();
      if(querySnapshot.size>0){
        _log.info("user logged");
      }
      return querySnapshot.docs.first.data();
   }



}


class User{
  String email;
  String nome;
  String cf;
  String regione;
  String provincia;
  String istituto; 


  User({required this.email, required this.nome,required this.cf,required this.regione,required this.provincia,required this.istituto});


  factory User.fromFirestore(Map<String, dynamic> data) {
    // Mapping the fields from the Firestore document to the Dart object
    return User(
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      cf: data['cf'] ?? '',
      regione: data['regione'] ?? '',
      provincia: data['provincia'] ?? '',
      istituto: data['istituto'] ?? '',
    );
  }
}