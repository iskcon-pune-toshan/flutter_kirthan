import 'dart:convert';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/services/signin_service.dart';

class AutheticationAPIService extends BaseAPIService {

  static final AutheticationAPIService _token = AutheticationAPIService.internal();

  factory AutheticationAPIService() {
    return _token;
  }

  AutheticationAPIService.internal();

  String sessionJWTToken ;

  Future<String> autheticate() async {

    //String tokenBody = '{"username": "kirthanuser","password": "123456"}';

    print(SignInService().fireUser.email);
    print(SignInService().fireUser.uid);
    //print(SignInService().fireUser.hashCode);

    String email = SignInService().fireUser.email;
    String uid = SignInService().fireUser.uid;
    //int hashCode  = SignInService().fireUser.hashCode;




    print("Entered singleton");

    String tokenBody = '{"username":"$email","password": "$uid" }';
     print(tokenBody);
    var token =  await client1.post('$baseUrl/authenticate',headers: {"Content-Type": "application/json"},body:tokenBody );

    //print("Token Body from auth");
    print(token.body);


    var jwt_token = '';

    print(token.statusCode);



    if(token.statusCode==200) {

      var decoder = jsonDecode(token.body);

      jwt_token = decoder['jwt'];
      sessionJWTToken = jwt_token;

    }

    //return sessionJWTToken;
  //print(jwt_token);

  }
}