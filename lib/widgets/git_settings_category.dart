import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/git_settings_provider.dart';
import 'git_settings_form.dart';
import 'git_settings_main_view.dart';

class GitSettingsCategory extends StatelessWidget {
  const GitSettingsCategory({Key? key}) : super(key: key);

  void _showAddUserForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: const GitSettingsForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GitSettingsProvider>(
      builder: (context, gitSettingsProvider, child) {
        return ExpansionTile(
          title: Row(
            children: [
              const Icon(Icons.settings, color: Color(0xFF00FF00)),
              const SizedBox(width: 8),
              const Text(
                'Git Settings',
                style: TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.person_add_outlined,
                  color: Color(0xFF00FF00),
                  size: 20,
                ),
                onPressed: () => _showAddUserForm(context),
                tooltip: 'Add Git User',
              ),
            ],
          ),
          children: const [
            GitSettingsMainView(),
          ],
        );
      },
    );
  }
} 