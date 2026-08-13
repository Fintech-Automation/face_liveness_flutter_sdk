class LivenessLocalization {
  LivenessLocalizationIntro? intro;

  LivenessLocalizationPrepare? prepare;

  LivenessLocalizationPageElements? starting;

  LivenessLocalizationPageElements? processing;

  LivenessLocalizationResultElements? success;

  LivenessLocalizationResultElements? fail;

  LivenessLocalizationPageElements? cameraPermission;

  LivenessLocalization({
    this.intro,
    this.prepare,
    this.starting,
    this.processing,
    this.success,
    this.fail,
    this.cameraPermission,
  });

  LivenessLocalization.fromJson(Map<String, dynamic> json) {
    if (json['intro'] is Map) {
      intro = LivenessLocalizationIntro.fromJson(json['intro']);
    }
    if (json['prepare'] is Map) {
      prepare = LivenessLocalizationPrepare.fromJson(json['prepare']);
    }
    if (json['starting'] is Map) {
      starting = LivenessLocalizationPageElements.fromJson(json['starting']);
    }
    if (json['processing'] is Map) {
      processing = LivenessLocalizationPageElements.fromJson(
        json['processing'],
      );
    }
    if (json['success'] is Map) {
      success = LivenessLocalizationResultElements.fromJson(json['success']);
    }
    if (json['fail'] is Map) {
      fail = LivenessLocalizationResultElements.fromJson(json['fail']);
    }
    if (json['cameraPermission'] is Map) {
      cameraPermission = LivenessLocalizationPageElements.fromJson(
        json['cameraPermission'],
      );
    }
  }

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
  String? eyebrow;
  String? title;
  String? body;
  String? cta;

  /// Small trust line under the intro CTA; pass `''` to hide.
  String? trustLabel;

  LivenessLocalizationIntro({
    this.eyebrow,
    this.title,
    this.body,
    this.cta,
    this.trustLabel,
  });

  LivenessLocalizationIntro.fromJson(Map<String, dynamic> json) {
    eyebrow = json['eyebrow'];
    title = json['title'];
    body = json['body'];
    cta = json['cta'];
    trustLabel = json['trustLabel'];
  }

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
  String? title;
  String? body;
  LivenessLocalizationPageElements({this.title, this.body});

  LivenessLocalizationPageElements.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}

class LivenessLocalizationPrepare {
  String? eyebrow;
  String? title;
  List<LivenessLocalizationPageElements>? tips;
  String? cta;
  String? backLabel;

  LivenessLocalizationPrepare({
    this.eyebrow,
    this.title,
    this.tips,
    this.cta,
    this.backLabel,
  });

  LivenessLocalizationPrepare.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    eyebrow = json['eyebrow'];
    if (json['tips'] is List) {
      tips = (json['tips'] as List)
          .where((e) => e.values.every((v) => v != null))
          .map(
            (e) => LivenessLocalizationPageElements.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList();
    }
    cta = json['cta'];
    backLabel = json['backLabel'];
  }

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
  String? cta;

  LivenessLocalizationResultElements({super.title, super.body, this.cta});

  LivenessLocalizationResultElements.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    cta = json['cta'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['cta'] = cta;

    return data;
  }
}
