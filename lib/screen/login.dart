import 'package:flutter/material.dart';
import 'package:gas_leakage/screen/home.dart';
import 'package:gas_leakage/screen/register.dart';
import 'package:gas_leakage/services/auth.dart';
import 'package:gas_leakage/shared/decorations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = "";
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (val) {
        emailController.text = val!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return ("please enter email");
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (val) {
        passwordController.text = val!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );

    final loginButton = ElevatedButton(
      onPressed: () async {
        final form = _formkey.currentState;
        if (form!.validate()) {
          dynamic result =
              await signIn(emailController.text, passwordController.text);
          if (result == null) {
            setState(() {
              error = "please enter a valid email";
            });
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          }
        }
      },
      child: Text("Sign in"),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        padding: EdgeInsets.all(15),
      ),
    );

    return Scaffold(
      body: Container(
  //       decoration: BoxDecoration(
  // gradient: LinearGradient(
  //   colors:[ 
  //     Colors.white,
  //     Colors
  //   ],
  //   begin: Alignment.bottomCenter,
  //   end: Alignment.topCenter,
  //   stops: [
  //     0.9,
  //     1
  //   ]
    
  //   )
//),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 40.0,
              ),
              emailField,
              const SizedBox(
                height: 20.0,
              ),
              passwordField,
              const SizedBox(height: 20.0),
              loginButton,
              const SizedBox(
                height: 20,
              ),
              Text(error),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      child: Text("Resgister")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
