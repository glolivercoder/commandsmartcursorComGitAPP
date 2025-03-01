class GitUserSettings {
  final String username;
  final String clientId;
  final String clientSecret;
  final String token;
  final DateTime createdAt;

  GitUserSettings({
    required this.username,
    required this.clientId,
    required this.clientSecret,
    required this.token,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GitUserSettings.fromJson(Map<String, dynamic> json) {
    return GitUserSettings(
      username: json['username'] as String,
      clientId: json['clientId'] as String,
      clientSecret: json['clientSecret'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
} 