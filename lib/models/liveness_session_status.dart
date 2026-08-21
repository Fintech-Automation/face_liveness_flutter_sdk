import 'package:flutter/cupertino.dart';

class LivenessSessionStatus {
  SessionStatus? status;
  String? stage;
  String? message;
  bool? isEligible;

  LivenessSessionStatus.fromJson(Map<String, dynamic> json) {
    if (json['stage'] is String) {
      try {
        status = SessionStatus.from(json['status']);
      } catch (e) {
        debugPrint('Error occurred while parsing session status: $e');
      }
    }
    stage = json['stage'];
    message = json['message'];
    isEligible = json['isEligible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status?.displayName;
    data['stage'] = stage;
    data['message'] = message;
    data['isEligible'] = isEligible;
    return data;
  }
}

enum SessionStatus {
  completed('COMPLETED'),
  expired('EXPIRED'),
  invalid('INVALID'),
  ready('READY'),
  readyRetryLimitExceeded('RETRY_LIMIT_EXCEEDED');

  final String displayName;
  const SessionStatus(this.displayName);

  static SessionStatus? from(String name) {
    return SessionStatus.values.firstWhere(
      (e) => e.displayName == name,
      orElse: () => throw Exception('Invalid state: $name'),
    );
  }
}
