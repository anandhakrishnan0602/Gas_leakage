import 'package:flutter/material.dart';
import 'package:gas_leakage/screen/home.dart';
import 'package:gas_leakage/services/auth.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = "";
  
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
              await RegisterInWithEmail(emailController.text, passwordController.text);
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
      child: Text("Register"),
      style: ElevatedButton.styleFrom(
      elevation: 0.0,
      padding: EdgeInsets.all(15),  
      ),
    );
    
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        color: Colors.white,
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              emailField,
              SizedBox(
                height: 20.0,
              ),
              passwordField,
              SizedBox(height: 20.0),
              loginButton,
              SizedBox(
                height: 20,
              ),
              Text(error),
            ],
          ),
        ),
      ),
    );
      
  }
}