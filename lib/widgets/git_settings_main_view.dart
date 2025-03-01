import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/git_settings_provider.dart';
import 'git_settings_form.dart';

class GitSettingsMainView extends StatefulWidget {
  const GitSettingsMainView({Key? key}) : super(key: key);

  @override
  State<GitSettingsMainView> createState() => _GitSettingsMainViewState();
}

class _GitSettingsMainViewState extends State<GitSettingsMainView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isRepoDropdownOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GitSettingsProvider>(
      builder: (context, gitSettingsProvider, child) {
        if (!gitSettingsProvider.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FF00)),
            ),
          );
        }

        if (gitSettingsProvider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No Git users configured',
                  style: TextStyle(color: Color(0xFF00FF00)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showAddUserForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    side: const BorderSide(color: Color(0xFF00FF00)),
                  ),
                  child: const Text(
                    'Add Git User',
                    style: TextStyle(color: Color(0xFF00FF00)),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current User Display
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF00FF00)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Color(0xFF00FF00)),
                    const SizedBox(width: 8),
                    Text(
                      'Current User: ${gitSettingsProvider.currentUser?.username ?? "None"}',
                      style: const TextStyle(color: Color(0xFF00FF00)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Repository Search
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Color(0xFF00FF00)),
                decoration: InputDecoration(
                  hintText: 'Search repository...',
                  hintStyle: TextStyle(color: const Color(0xFF00FF00).withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF00FF00)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00FF00)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00FF00)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00FF00), width: 2),
                  ),
                ),
                onTap: () => setState(() => _isRepoDropdownOpen = !_isRepoDropdownOpen),
              ),

              if (_isRepoDropdownOpen)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00FF00)),
                  ),
                  child: const ListTile(
                    leading: Icon(Icons.info, color: Color(0xFF00FF00)),
                    title: Text(
                      'Repository list will be populated when implemented',
                      style: TextStyle(color: Color(0xFF00FF00), fontSize: 12),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh, color: Color(0xFF00FF00)),
                      label: const Text('Refresh', style: TextStyle(color: Color(0xFF00FF00))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        side: const BorderSide(color: Color(0xFF00FF00)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // Implement refresh functionality
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.settings, color: Color(0xFF00FF00)),
                      label: const Text('Settings', style: TextStyle(color: Color(0xFF00FF00))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        side: const BorderSide(color: Color(0xFF00FF00)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => _showAddUserForm(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddUserForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: const GitSettingsForm(),
      ),
    );
  }
} 