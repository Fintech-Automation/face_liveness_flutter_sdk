class LivenessTheme {
  final LivenessThemeColors? colors;

  final LivenessThemeShape? shape;

  final LivenessThemeTypography? typography;

  // final LivenessThemeLayout? layout;

  const LivenessTheme({
    this.colors,
    this.shape,
    this.typography /*this.layout*/,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['colors'] = colors?.toJson();
    data['shape'] = shape?.toJson();
    data['typography'] = typography?.toJson();
    // data['layout'] = layout?.toJson();
    return data;
  }
}

class LivenessThemeColors {
  /// Main brand color. Drives buttons, progress, loader, focus, and capture primary tokens.
  final String? primary;

  /// Secondary brand accent color used for optional UI accents.
  final String? secondary;

  /// Main heading and strong text color.
  final String? heading;

  /// @internal
  /// The following properties are for internal use only — not exposed externally.
  /// Light tint of the brand color, used for badge / tip icon backgrounds.
  final String? brandTint;

  /// Body / paragraph text color.
  final String? body;

  /// Muted / secondary text color for captions, labels, and metadata.
  final String? muted;

  /// Border and separator line color.
  final String? line;

  /// Page / root background color (behind the card).
  final String? bg;

  /// Card / surface background color.
  final String? card;

  /// Primary button text color. Auto-computed as black or white based on primary luminance; override to use a custom color.
  final String? primaryText;

  const LivenessThemeColors({
    this.primary,
    this.secondary,
    this.heading,
    this.brandTint,
    this.body,
    this.muted,
    this.line,
    this.bg,
    this.card,
    this.primaryText,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primary'] = primary;
    data['secondary'] = secondary;
    data['heading'] = heading;
    data['brandTint'] = brandTint;
    data['body'] = body;
    data['muted'] = muted;
    data['line'] = line;
    data['bg'] = bg;
    data['card'] = card;
    data['primaryText'] = primaryText;

    return data;
  }
}

class LivenessThemeShape {
  /// Root/card corner radius in pixels.
  final num? radius;

  const LivenessThemeShape({this.radius});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['radius'] = radius;
    return data;
  }
}

class LivenessThemeTypography {
  /// Font family used by wrapper screens and capture theme.
  final String? fontFamily;

  const LivenessThemeTypography({this.fontFamily});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fontFamily'] = fontFamily;
    return data;
  }
}

class LivenessThemeLayout {
  /// Card width. Number values are treated as pixels.
  final num? width;

  /// Uses a full-height mobile/portrait tablet layout.
  final bool? fullscreen;

  const LivenessThemeLayout({this.width, this.fullscreen});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['width'] = width;
    data['fullscreen'] = fullscreen;

    return data;
  }
}
