import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class SavedDirectories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get path => text()();
  TextColumn get savedAt => text()();
  TextColumn get lastModified => text()();
}

class GitCredentials extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get token => text()();
  TextColumn get clientId => text().nullable()();
  TextColumn get clientSecret => text().nullable()();
  TextColumn get apiUrl => text().nullable()();
}

class GitHubAccounts extends Table {
  TextColumn get username => text()();
  TextColumn get token => text()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {username};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = Directory('projetosalvos');
    if (!dbFolder.existsSync()) {
      dbFolder.createSync();
    }
    
    final file = File(p.join(dbFolder.path, 'command_smart.db'));
    print('Database path: ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [SavedDirectories, GitCredentials, GitHubAccounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 4) {
          await m.createTable(gitHubAccounts);
          await m.deleteTable('git_user_settings');
        }
      },
    );
  }

  // Saved Directories methods
  Future<List<SavedDirectory>> getAllSavedDirectories() =>
      select(savedDirectories).get();

  Stream<List<SavedDirectory>> watchAllSavedDirectories() =>
      select(savedDirectories).watch();

  Future<SavedDirectory> saveDirectory(SavedDirectoriesCompanion entry) async {
    final savedDir = await into(savedDirectories).insertReturning(entry);
    await _backupDatabase();
    return savedDir;
  }

  Future<bool> updateDirectory(SavedDirectoriesCompanion entry) async {
    final result = await update(savedDirectories).replace(entry);
    await _backupDatabase();
    return result;
  }

  Future<int> deleteDirectory(int id) async {
    final result = await (delete(savedDirectories)..where((t) => t.id.equals(id))).go();
    await _backupDatabase();
    return result;
  }

  // Git Credentials methods
  Future<List<GitCredential>> getAllGitCredentials() =>
      select(gitCredentials).get();

  Future<GitCredential> addGitCredential(GitCredentialsCompanion entry) =>
      into(gitCredentials).insertReturning(entry);

  Future<bool> updateGitCredential(GitCredentialsCompanion entry) =>
      update(gitCredentials).replace(entry);

  Future<int> deleteGitCredential(int id) =>
      (delete(gitCredentials)..where((t) => t.id.equals(id))).go();

  // GitHub Accounts methods
  Future<List<GitHubAccount>> getAllGitHubAccounts() =>
      select(gitHubAccounts).get();

  Future<void> addGitHubAccount(GitHubAccountsCompanion entry) =>
      into(gitHubAccounts).insert(entry);

  Future<int> deleteGitHubAccount(String username) =>
      (delete(gitHubAccounts)..where((t) => t.username.equals(username))).go();

  // Backup method
  Future<void> _backupDatabase() async {
    try {
      final mainDbFolder = Directory('projetosalvos');
      final backupDir = Directory('projetosalvosBKP');
      
      if (!mainDbFolder.existsSync()) {
        mainDbFolder.createSync();
      }
      if (!backupDir.existsSync()) {
        backupDir.createSync();
      }

      final mainFiles = mainDbFolder.listSync();
      for (var entity in mainFiles) {
        if (entity is File) {
          final fileName = p.basename(entity.path);
          final backupFile = File(p.join(backupDir.path, fileName));
          await entity.copy(backupFile.path);
        }
      }
      
      print('Database and files backup created at: ${backupDir.path}');
    } catch (e) {
      print('Error creating database backup: $e');
    }
  }
} 