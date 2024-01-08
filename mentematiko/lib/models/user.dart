import 'package:card/models/role.dart';

class User {
  String email;
  String nome;
  String cf;
  String regione;
  String provincia;
  String istituto;
  String? password;
  ROLE role;

  User(
      {required this.email,
      required this.nome,
      required this.cf,
      required this.regione,
      required this.provincia,
      required this.istituto,
      required this.role,
      this.password});

  ROLE? getFromString(String value) {
    return ROLE.values.firstWhere((e) => e.toString().split('.').last == value);
  }

  Map<String, dynamic> toFirestore(bool isUser){
    return {
      'email': email,
      'nome': nome,
      'cf': cf,
      'regione':regione,
      'provincia':provincia,
      'istituto':istituto,
      'password': password,
      'role': isUser ? ROLE.user.toString().split('.')[1] : ROLE.arb.toString().split('.')[1]
    };
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
        role: ROLE.user);
  }
}
