class LivenessErrorModel {
  /// Where the failure occurred.
  /// 'camera' | 'createSession' | 'getResults' | 'aws' | 'config'
  String? stage;
  String? message;
  dynamic cause;

  LivenessErrorModel({this.stage, this.message, this.cause});
}
