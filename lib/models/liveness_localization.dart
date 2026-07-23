class LivenessLocalization {
  final LivenessLocalizationIntro? intro;

  final LivenessLocalizationPrepare? prepare;

  final LivenessLocalizationPageElements? starting;

  final LivenessLocalizationPageElements? processing;

  final LivenessLocalizationResultElements? success;

  final LivenessLocalizationResultElements? fail;

  final LivenessLocalizationPageElements? cameraPermission;

  const LivenessLocalization({
    this.intro,
    this.prepare,
    this.starting,
    this.processing,
    this.success,
    this.fail,
    this.cameraPermission,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['intro'] = intro?.toJson();
    data['prepare'] = prepare?.toJson();
    data['starting'] = starting?.toJson();
    data['processing'] = processing?.toJson();
    data['success'] = success?.toJson();
    data['fail'] = fail?.toJson();
    data['cameraPermission'] = cameraPermission?.toJson();
    return data;
  }
}

class LivenessLocalizationIntro {
  final String? eyebrow;
  final String? title;
  final String? body;
  final String? cta;

  /// Small trust line under the intro CTA; pass `''` to hide.
  final String? trustLabel;

  const LivenessLocalizationIntro({
    this.eyebrow,
    this.title,
    this.body,
    this.cta,
    this.trustLabel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eyebrow'] = eyebrow;
    data['title'] = title;
    data['body'] = body;
    data['cta'] = cta;
    data['trustLabel'] = trustLabel;

    return data;
  }
}

class LivenessLocalizationPageElements {
  final String? title;
  final String? body;
  const LivenessLocalizationPageElements({this.title, this.body});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}

class LivenessLocalizationPrepare {
  final String? eyebrow;
  final String? title;
  final List<LivenessLocalizationPageElements>? tips;
  final String? cta;
  final String? backLabel;

  const LivenessLocalizationPrepare({
    this.eyebrow,
    this.title,
    this.tips,
    this.cta,
    this.backLabel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eyebrow'] = eyebrow;
    data['title'] = title;
    data['tips'] = tips?.map((e) => e.toJson()).toList();
    data['cta'] = cta;
    data['backLabel'] = backLabel;

    return data;
  }
}

class LivenessLocalizationResultElements
    extends LivenessLocalizationPageElements {
  final String? cta;

  const LivenessLocalizationResultElements({super.title, super.body, this.cta});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['cta'] = cta;

    return data;
  }
}
