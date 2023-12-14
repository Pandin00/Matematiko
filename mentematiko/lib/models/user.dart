


import 'package:card/models/role.dart';

class User{



  String email;
  String nome;
  String cf;
  String regione;
  String provincia;
  String istituto;
  ROLE role; 
  
  


  User({required this.email, required this.nome,required this.cf,required this.regione,required this.provincia,required this.istituto,required this.role});


   ROLE? getFromString(String value) {
    return ROLE.values.firstWhere((e) => e.toString().split('.').last == value);
  }


  factory User.fromFirestore(Map<String, dynamic> data) {
    // Mapping the fields from the Firestore document to the Dart object
    return User(
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      cf: data['cf'] ?? '',
      regione: data['regione'] ?? '',
      provincia: data['provincia'] ?? '',
      istituto: data['istituto'] ?? '',
      role: ROLE.user
    );
  }
}