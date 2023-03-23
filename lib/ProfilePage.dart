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
  void dispose() {
    _usernameController.dispose();
    super.dispose();
    print('ProfilePage: dispose() called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('ProfilePage: didChangeDependencies() called');
  }

  @override
  void initState() {
    print('ProfilePage: initState called');
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = _authService.getCurrentUser();
    if (_user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.id)
          .get();
      setState(() {
        _user = UserModel(
            id: _user!.id,
            email: _user!.email,
            username: doc['username'] ?? '',
            password: "");
        _usernameController.text = _user!.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ProfilePage: build() called');
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
              Text(
                _user?.username != null && _user!.username.isNotEmpty
                    ? 'Current username: ${_user!.username}'
                    : 'No username set',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Update Username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton( // Save Username
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Update the user's username in Firestore or create a new document
                    await FirebaseFirestore.instance
                        .collection('_user')
                        .doc(_user!.id)
                        .set({'username': _usernameController.text},
                          SetOptions(merge: true));

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
              ElevatedButton( //Delete Account Button
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.id)
                      .delete()
                      .then(
                        (doc) => print("Profile deleted"),
                        onError: (e) => print("Error updating document $e"),
                  );
                },
                child: Text("Delete Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
