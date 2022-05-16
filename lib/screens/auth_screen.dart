import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pappi_store/model/http_exception.dart';
import 'package:pappi_store/model/provider/auth_provider.dart';
import 'package:provider/provider.dart';

enum AuthenticationMode { signUp, logIn }

class AuthenticationScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 94.0,
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'FashoNova',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .titleSmall!
                              .color,
                          fontSize: 35,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
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

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthenticationMode _authMode = AuthenticationMode.logIn;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController? _authScreenController;
  Animation<Size>? _formBoxAnimation;
  Animation<double>? _passwordAnimation;

  @override
  void initState() {
    super.initState();
    _authScreenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _formBoxAnimation = Tween<Size>(
      begin: const Size(double.infinity, 260),
      end: const Size(double.infinity, 320),
    ).animate(
      CurvedAnimation(
        parent: _authScreenController!,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _passwordAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _authScreenController!,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _authScreenController!.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (cont) => AlertDialog(
        title: const Text('An error occurred'),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(cont).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthenticationMode.logIn) {
        await Provider.of<AuthenticationProvider>(context, listen: false).logIn(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      } else {
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signUp(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      }
    } on HttpExceptionError catch (error) {
      var errorMess = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMess = 'Email Address already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMess = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMess = 'Weak Password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMess = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMess = 'Invalid Password';
      }
      _showErrorDialog(errorMess);
    } catch (error) {
      const errorMess = 'Could not authenticate user. Please try again.';
      _showErrorDialog(errorMess);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthenticationMode.logIn) {
      setState(() {
        _authMode = AuthenticationMode.signUp;
      });
      _authScreenController!.forward();
    } else {
      setState(() {
        _authMode = AuthenticationMode.logIn;
      });
      _authScreenController!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthenticationMode.signUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthenticationMode.signUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthenticationMode.signUp ? 60 : 0,
                    maxHeight: _authMode == AuthenticationMode.signUp ? 120 : 0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _passwordAnimation!,
                    child: TextFormField(
                      enabled: _authMode == AuthenticationMode.signUp,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                      validator: _authMode == AuthenticationMode.signUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                      _authMode == AuthenticationMode.logIn
                          ? 'LOGIN'
                          : 'SIGN UP',
                    ),
                    onPressed: _submitForm,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8.0,
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                  ),
                FlatButton(
                  child: Text(
                    '${_authMode == AuthenticationMode.logIn ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  ),
                  onPressed: _switchAuthMode,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 4,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
