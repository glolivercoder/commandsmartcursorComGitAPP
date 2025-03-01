import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GitHubAccountProvider(),
      child: MaterialApp(
        title: 'GitHub App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AddGitHubAccountScreen(),
      ),
    );
  }
}

class AddGitHubAccountScreen extends StatefulWidget {
  @override
  _AddGitHubAccountScreenState createState() => _AddGitHubAccountScreenState();
}

class _AddGitHubAccountScreenState extends State<AddGitHubAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GitHubAccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add GitHub Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'GitHub Username'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your GitHub username';
                  }
                  return null;
                },
             