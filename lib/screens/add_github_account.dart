import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:github/github.dart';
import '../providers/github_account_provider.dart';

class AddGitHubAccountScreen extends StatefulWidget {
  @override
  _AddGitHubAccountScreenState createState() => _AddGitHubAccountScreenState();
}

class _AddGitHubAccountScreenState extends State<AddGitHubAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _addGitHubAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text;
      final token = _tokenController.text;

      try {
        final github = GitHub(auth: Authentication.withToken(token));
        final user = await github.users.getCurrentUser();

        if (user.login == username) {
          // Save the credentials using a Provider or any state management solution
          Provider.of<GitHubAccountProvider>(context, listen: false).addAccount(username, token);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account added successfully!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid GitHub username or token.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding account: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your GitHub username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(labelText: 'Personal Access Token'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your GitHub personal access token';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _addGitHubAccount,
                      child: Text('Add Account'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}