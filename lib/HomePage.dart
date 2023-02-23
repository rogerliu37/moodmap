import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AuthService.dart';
import 'LoginPage.dart';
import 'ProfilePage.dart';
import 'SignupPage.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();
  Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    print('HomePage: initState called');
    super.initState();
    // Called when the widget is inserted into the widget tree
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      print('HomePage: 5 seconds have passed. ');
    });
  }

  @override
  void dispose() {
    // Called when the widget is removed from the widget tree
    _timer.cancel();
    super.dispose();
    print('HomePage: dispose() called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when the widget's dependencies have changed
    // Handle any changes to the dependencies here
    print('HomePage: didChangeDependencies() called');
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage: build() called');
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('My App'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await _authService.signOut();
              },
            ),
          ],
        ),
      ),
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => _buildHomePage(context);
              break;
            case '/login':
              builder = (BuildContext context) => LoginPage();
              break;
            case '/signup':
              builder = (BuildContext context) => SignupPage();
              break;
            case '/profile':
              builder = (BuildContext context) => ProfilePage();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text("Login"),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text("Signup"),
          ),
        ],
      ),
    );
  }
}
