import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/github_account_provider.dart';

class GitHubAccountForm extends StatefulWidget {
  const GitHubAccountForm({Key? key}) : super(key: key);

  @override
  State<GitHubAccountForm> createState() => _GitHubAccountFormState();
}

class _GitHubAccountFormState extends State<GitHubAccountForm> {
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
    return Consumer<GitHubAccountProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF00FF00)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add GitHub Account',
                      style: TextStyle(
                        color: Color(0xFF00FF00),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF00FF00)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: Color(0xFF00FF00)),
                  decoration: const InputDecoration(
                    labelText: 'GitHub Username',
                    labelStyle: TextStyle(color: Color(0xFF00FF00)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00FF00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00FF00), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your GitHub username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tokenController,
                  style: const TextStyle(color: Color(0xFF00FF00)),
                  decoration: const InputDecoration(
                    labelText: 'Personal Access Token',
                    labelStyle: TextStyle(color: Color(0xFF00FF00)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00FF00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00FF00), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your GitHub personal access token';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FF00)),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await provider.addAccount(
                                _usernameController.text,
                                _tokenController.text,
                              );
                              
                              if (provider.error == null && context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('GitHub account added successfully!')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A1A),
                            side: const BorderSide(color: Color(0xFF00FF00)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Add Account',
                            style: TextStyle(color: Color(0xFF00FF00)),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 