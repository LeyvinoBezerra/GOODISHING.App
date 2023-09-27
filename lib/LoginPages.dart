import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'HomePages.dart';

class LoginPages extends StatefulWidget {
  LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
//cria objeto autenticador na api do google
  late GoogleSignIn _googleSignIn;
  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/contacts.readonly',
        'https://www.googleapis.com/auth/userinfo.profile',
        'openid',
        'email',
      ],
    );
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Image(
                  image: AssetImage('assets/images/loginBack.png'),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 80,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        //pega as credenciais do usuário logado
                        print("xxxxxxxxxxxxx");
                        GoogleSignInAccount? _googleSignInAccount =
                            await _googleSignIn.signIn();
                        print("yyyyyyyyyyyyy");
                        print("account ${_googleSignInAccount}");
                        //Nulo - Login não deu certo
                        //GoogleSignInAccount - Login deu certo

                        if (_googleSignInAccount == null) {
                          //não logou certo
                        } else {
                          //login deu certo
                          //pega as credenciais do usuário logado
                          GoogleSignInAuthentication? _googleSignInCredential =
                              await _googleSignInAccount.authentication;
                          print(_googleSignInCredential.accessToken);
                          //cria credencial do login no firebase
                          final credential = GoogleAuthProvider.credential(
                            accessToken: _googleSignInCredential.accessToken,
                            idToken: _googleSignInCredential.idToken,
                          );

                          //conecta no firebase
                          FirebaseAuth.instance
                              .signInWithCredential(credential);
                          //vai para tela home
                          Get.off(HomePages());
                        }
                      },
                      child: const Text('LOG IN Google'),
                    ),
                    const SizedBox(width: 30),
                    // ElevatedButton(
                    // onPressed: () => Get.to(const RegisterPages()),
                    // child: const Text('REGISTRAR'))
                  ],
                ),
              )
            ])));
  }
}
