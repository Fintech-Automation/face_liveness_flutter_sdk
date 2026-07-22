class LivenessResultModel {
  String? id;
  String? sessionId;
  String? status;
  String? failReason;
  String? responseJson;
  String? referenceImgFileIds;
  String? auditImgFileIds;
  String? createdTime;
  String? completedTime;
  String? callbackUrl;

  LivenessResultModel({
    this.id,
    this.sessionId,
    this.status,
    this.failReason,
    this.responseJson,
    this.referenceImgFileIds,
    this.auditImgFileIds,
    this.createdTime,
    this.completedTime,
    this.callbackUrl,
  });

  LivenessResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['session_id'];
    status = json['status'];
    failReason = json['fail_reason'];
    responseJson = json['response_json'];
    referenceImgFileIds = json['reference_img_file_ids'];
    auditImgFileIds = json['audit_img_file_ids'];
    createdTime = json['created_time'];
    completedTime = json['completed_time'];
    callbackUrl = json['callback_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['session_id'] = sessionId;
    data['status'] = status;
    data['fail_reason'] = failReason;
    data['response_json'] = responseJson;
    data['reference_img_file_ids'] = referenceImgFileIds;
    data['audit_img_file_ids'] = auditImgFileIds;
    data['created_time'] = createdTime;
    data['completed_time'] = completedTime;
    data['callback_url'] = callbackUrl;
    return data;
  }
}
