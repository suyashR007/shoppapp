import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppapp/models/http_exception.dart';
import 'package:shoppapp/providers/auth.dart';
import 'package:shoppapp/screens/auth_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> _opacityAnimation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('An Error Occured'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  Future<void> _submit() async {
    // if (!_formkey.currentState!.validate()) {
    //   return;
    // }
    _formkey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        //log in user
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'].toString(), _authData['password'].toString());
      } else {
        //Sign up user
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'].toString(), _authData['password'].toString());
      }
      // Navigator.of(context).pushNamed('/products-overview'); Bad approch
    } on HttpException catch (error) {
      var errorMesssage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXIST')) {
        errorMesssage = ' This Email address is already registered';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMesssage = 'THIS IS NOT VALID EMAIL';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMesssage = 'THIS PASSWORD IS TOO WEAK';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMesssage = 'COULD NOT FIND THE USER WITH THAT EMAIL';
      } else if (error.toString().contains('INVALID PASSWORD')) {
        errorMesssage = 'INVALID PASSWORDS';
      }
      _showErrorDialog(errorMesssage);
    } catch (error) {
      const errorMessage = 'Couldn\'t Authenticate!.. Please Try  again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signup ? 320 : 260,
        ),
        width: screenSize.width * 0.75,
        padding: const EdgeInsets.all(6),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value.toString();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Passsword'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'Password Invalid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value.toString();
                  },
                ),
                if (_authMode == AuthMode.signup)
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.signup
                          // ignore: body_might_complete_normally_nullable
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                            }
                          : null,
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGHUP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
