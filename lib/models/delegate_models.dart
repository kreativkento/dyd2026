class DelegateEntry {
  const DelegateEntry({
    required this.id,
    required this.fullName,
    required this.vicariate,
    required this.parish,
  });

  final String id;
  final String fullName;
  final String vicariate;
  final String parish;

  factory DelegateEntry.fromJson(Map<String, dynamic> json) {
    return DelegateEntry(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      vicariate: json['vicariate'] as String,
      parish: json['parish'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'vicariate': vicariate,
        'parish': parish,
      };
}

class UserProfile {
  const UserProfile({
    required this.nickname,
    required this.delegateId,
    required this.fullName,
    required this.vicariate,
    required this.parish,
  });

  final String nickname;
  final String delegateId;
  final String fullName;
  final String vicariate;
  final String parish;

  factory UserProfile.fromDelegate({
    required String nickname,
    required DelegateEntry delegate,
  }) {
    return UserProfile(
      nickname: nickname,
      delegateId: delegate.id,
      fullName: delegate.fullName,
      vicariate: delegate.vicariate,
      parish: delegate.parish,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String,
      delegateId: json['delegateId'] as String,
      fullName: json['fullName'] as String,
      vicariate: json['vicariate'] as String,
      parish: json['parish'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'delegateId': delegateId,
        'fullName': fullName,
        'vicariate': vicariate,
        'parish': parish,
      };
}
