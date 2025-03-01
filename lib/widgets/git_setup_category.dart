import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/command_provider.dart';
import '../providers/directory_provider.dart';
import '../providers/github_account_provider.dart';
import 'github_account_form.dart';

class GitSetupCategory extends StatelessWidget {
  const GitSetupCategory({Key? key}) : super(key: key);

  void _showAddGitHubAccountForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: const GitHubAccountForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommandProvider, DirectoryProvider>(
      builder: (context, commandProvider, directoryProvider, child) {
        final commands = commandProvider.commands['Git Setup'] ?? [];
        
        return ExpansionTile(
          title: Row(
            children: [
              const Text(
                'Git Setup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.person_add),
                tooltip: 'Add GitHub Account',
                onPressed: () => _showAddGitHubAccountForm(context),
              ),
            ],
          ),
          leading: const Icon(Icons.settings),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: commands.length,
              itemBuilder: (context, index) {
                final command = commands[index];
                return ListTile(
                  title: Text(command['name'] ?? ''),
                  subtitle: Text(command['description'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          commandProvider.copyToClipboard(command['command']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comando copiado!')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: directoryProvider.currentDirectory == null
                            ? null
                            : () => commandProvider.executeCommand(context, command),
                      ),
                    ],
                  ),
                );
              },
            ),
            // GitHub Accounts List
            Consumer<GitHubAccountProvider>(
              builder: (context, provider, child) {
                if (provider.accounts.isEmpty) {
                  provider.loadAccounts();
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No GitHub accounts added yet')),
                  );
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'GitHub Accounts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.accounts.length,
                      itemBuilder: (context, index) {
                        final account = provider.accounts[index];
                        return ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text(account['username']),
                          subtitle: Text('Added on: ${account['createdAt']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete the account ${account['username']}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirm == true) {
                                await provider.deleteAccount(account['username']);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Account deleted successfully')),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
} 