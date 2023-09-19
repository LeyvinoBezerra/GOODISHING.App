import 'package:flutter/material.dart';

import 'HomePages.dart';
import 'InitPages.dart';

class RegisterPages extends StatelessWidget {
  const RegisterPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 252, 253, 253),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 220,
                    child: Image(
                      image: AssetImage('assets/images/logorecortada.png'),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Positioned(
                    height: 80,
                    bottom: 80,
                    left: 200,
                    child: Row(
                      children: [
                        const SizedBox(height: 80),
                        ElevatedButton(
                          onPressed: () => (HomePages()),
                          child: const Text('Registrar'),
                        ),
                        ElevatedButton(
                            onPressed: () => (const InitPages()),
                            child: const Text('Cancelar')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
