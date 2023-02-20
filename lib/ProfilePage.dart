import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AuthService.dart';
import 'UserModel.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  AuthService _authService = AuthService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _user = _authService.getCurrentUser();
    _usernameController.text = _user!.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    // Update the user's username in Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_user!.id)
                        .update({'username': _usernameController.text});

                    setState(() {
                      _user = UserModel(
                          id: _user!.id,
                          email: _user!.email,
                          username: _usernameController.text,
                          password: "");
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profile updated")));
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
