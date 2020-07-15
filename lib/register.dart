import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Registration Form",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    FontAwesomeIcons.solidRegistered,
                    size: 150,
                    color: Colors.blue,
                  ),
          ],
              ),
              const SizedBox(height: 50.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email ID',
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'email is required';
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Password is required';
                  }
                },
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      padding:
                      EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                      color:Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                    ),

                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Checking",
                            ),
                          ),
                        );
                        _submit(emailController.text, passwordController.text);
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                ],
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(String email, String password) {
    print(email);
    print(password);
    if (_formKey.currentState.validate() == true) {
      // firebase code
      final FirebaseAuth _register = FirebaseAuth.instance;
      _register
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((currentUser) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration Successful",
            ),
          ),

        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }).catchError((err) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration Unsuccessful",
            ),
          ),
        );
      });


    }
  }
}