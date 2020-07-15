import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgotpassword.dart';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  List<String> data = ['', ''];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();


  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.userEdit,
                    size: 150,
                    color: Colors.blue,
                  )
                ],
              ),
              const SizedBox(height: 50.0),
              TextFormField(
                controller: userController,
                decoration: const InputDecoration(
                  labelText: 'Email ID',
                ),
                validator: (String value) {
                  if (value
                      .trim()
                      .isEmpty) {
                    return 'Email ID is required';
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                controller: passController,
                decoration: const InputDecoration(
                  labelText: 'password',
                ),
                validator: (String value) {
                  if (value
                      .trim()
                      .isEmpty) {
                    return 'password is required';
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Forgot Password ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassPage()),
                      );
                    },
                    child: Text(
                      "Click Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      padding:
                      EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                      ),
                      onPressed: () async {
                        print(userController.text + passController.text);
                        //TEST CODE
                        FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                        AuthResult authResult = await _firebaseAuth
                            .signInWithEmailAndPassword(email: userController
                            .text, password: passController.text);
                        FirebaseUser user = authResult.user;

                        //FirebaseUser user = await _logInEmailPass(
                        // userController.text, passController.text);
                        if (user == null) {
                          return;
                        }
                        data[0] = user.email;
                        data[1] = user.uid;
                        await FirebaseAuth.instance.signOut();
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setStringList('my_string_list_key', data);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.solidEnvelope,color: Colors.white,),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Login with Email',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),

                ],
              ),
              const SizedBox(height: 16.0),

              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Click Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(" to Register"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<FirebaseUser> _logInEmailPass(String email, String pass) async {
    if (_formKey.currentState.validate() == true) {
      FirebaseUser user;
      AuthResult result;
      try {
        result = await _auth
            .signInWithEmailAndPassword(email: email, password: pass);
      }
      catch (err) {
        print('-------------------------');
        print(err);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login Unsuccessful",
            ),
          ),
        );
      }
      if (user != null) {
        user = result.user;
        return user;
      }
//    } else {
//      return null;
//    }
    }
  }
}