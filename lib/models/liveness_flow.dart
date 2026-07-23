class LivenessFlow {
  /// Starts at Prepare instead of Intro.
  final bool? skipIntro;

  /// Goes straight to capture after Intro, or immediately when `skipIntro` is also true.
  final bool? skipPrepare;

  const LivenessFlow({this.skipIntro, this.skipPrepare});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['skipIntro'] = skipIntro;
    data['skipPrepare'] = skipPrepare;
    return data;
  }
}
