import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shoppapp/widgets/auth_card.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 208, 75, 223).withOpacity(0.5),
                const Color.fromARGB(255, 119, 66, 241).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, 1],
            )),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.deepPurple,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: const Text(
                        'MYSHOP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: screenSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
