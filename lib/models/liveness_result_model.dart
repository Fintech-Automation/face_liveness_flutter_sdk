class LivenessResultModel {
  String? id;
  String? status;
  String? failReason;
  String? createdTime;
  String? completedTime;

  LivenessResultModel({
    this.id,
    this.status,
    this.failReason,
    this.createdTime,
    this.completedTime,
  });

  LivenessResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    failReason = json['fail_reason'];
    createdTime = json['created_time'];
    completedTime = json['completed_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['fail_reason'] = failReason;
    data['created_time'] = createdTime;
    data['completed_time'] = completedTime;
    return data;
  }
}
