import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AuthService.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  void initState() {
    print('SignupPage: initState called');
    super.initState();
    // Called when the widget is inserted into the widget tree
  }

  @override
  void dispose() {
    // Called when the widget is removed from the widget tree
    super.dispose();
    print('SignupPage: dispose() called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when the widget's dependencies have changed
    // Handle any changes to the dependencies here
    print('SignupPage: didChangeDependencies() called');
  }

  @override
  Widget build(BuildContext context) {
    print('SignupPage: build() called');
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result =
                        await _authService.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      username: _usernameController.text.trim(),
                    );
                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Unable to create an account")),
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  }
                },
                child: Text("Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
