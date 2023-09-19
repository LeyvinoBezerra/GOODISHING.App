import 'package:flutter/material.dart';

import 'LoginPages.dart';
import 'RegisterPages.dart';

import 'LoginPages.dart';
import 'RegisterPages.dart';

class InitPages extends StatelessWidget {
  const InitPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/imagens/loginBack.png'),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 80,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => (const LoginPages()),
                    child: const Text('LOG IN'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                      onPressed: () => (const RegisterPages()),
                      child: const Text('REGISTRAR'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
